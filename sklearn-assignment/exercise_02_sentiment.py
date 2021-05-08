"""Build a sentiment analysis / polarity model

Sentiment analysis can be casted as a binary text classification problem,
that is fitting a linear classifier on features extracted from the text
of the user messages so as to guess wether the opinion of the author is
positive or negative.

In this examples we will use a movie review dataset.

"""

from sklearn.feature_extraction.text import TfidfVectorizer, TfidfTransformer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.model_selection import GridSearchCV
from sklearn.datasets import load_files
from sklearn.model_selection import train_test_split
from sklearn.linear_model import SGDClassifier
from sklearn import metrics
import numpy as np
from datetime import datetime


# Choose a clafissier, SDGClassifier [SDG] or Multinomial.
classifier = 'SGD'
mean_pipe = []
mean_SV = []

if __name__ == "__main__":
    # NOTE: we put the following in a 'if __name__ == "__main__"' protected
    # block to be able to use a multi-core grid search that also works under
    # Windows, see:http://docs.python.org/library/multiprocessing.html#windows
    # The multiprocessing module is used as the backend of joblib.Parallel
    # that is used when n_jobs != 1 in GridSearchCV
    
    start = datetime.now()
    # the training data folder must be passed as first argument
    movie_reviews_data_folder = r"/home/Documents/sentiment_exercise/data"
    dataset = load_files(movie_reviews_data_folder, shuffle=False)
    print("n_samples: %d" % len(dataset.data))
    

    # split the dataset in training and test set:
    docs_train, docs_test, y_train, y_test = train_test_split(
        dataset.data, dataset.target, test_size=0.25, random_state=None)
    
    # TASK: Build a vectorizer / classifier pipeline that filters out tokens
    if classifier == 'Multinomial':
      text_clf = Pipeline([('vect', TfidfVectorizer()),
                        ('tfidf', TfidfTransformer()),
                        ('clf', MultinomialNB()),
      ])
    elif classifier == 'SDG':
      text_clf = Pipeline([('vect', TfidfVectorizer()),
                        ('tfidf', TfidfTransformer()),
                        ('clf', SGDClassifier(loss='hinge', penalty='l2',
                                              alpha=1e-3, random_state=60,
                                              max_iter=5, tol=None)),
                        ])

    text_clf.fit(docs_train, y_train)   
    predicted = text_clf.predict(docs_test)

    print("###############Usando apenas o Pipeline###############")
    print(metrics.confusion_matrix(y_test, predicted))
    print(text_clf, metrics.classification_report(y_test, predicted))
    print(np.mean(predicted == y_test))
    
    
    # TASK: Build a grid search to find out whether unigrams or bigrams are
    # more useful.
    # Fit the pipeline on the training set using grid search for the 
    # parameters
    
    parameters = {'vect__ngram_range': [(1, 1), (1, 2)],
                  'tfidf__use_idf': (True, False),
                  'clf__alpha': (1e-2, 1e-3),
                  }
    
    gs_clf = GridSearchCV(text_clf, parameters, n_jobs=-1)
    gs_clf = gs_clf.fit(docs_train, y_train)
       

    # TASK: print the cross-validated scores for the each parameters set
    # explored by the grid search
    for param_name in sorted(parameters.keys()):
        print("%s: %r" % (param_name, gs_clf.best_params_[param_name]))

    # TASK: Predict the outcome on the testing set and store it in a variable
    # named y_predicted
    
    y_predicted = gs_clf.predict(docs_test)
    
    cm = metrics.confusion_matrix(y_test, y_predicted)
    print("\n ###############GridSearchCV###############")
    print(cm)
    print(gs_clf, metrics.classification_report(y_test, y_predicted))
    print(np.mean(y_predicted == y_test))
    
    end = datetime.now()
    tmp = end - start
    
    print(tmp)

    # import matplotlib.pyplot as plt
    # plt.matshow(cm)
    # plt.show()
    
##############################################################################
# Através do classificador Multinomial Naive Bayes, modelo que utiliza a proba-
# bilidade de cada evento ocorrer, desconsiderando a correlação entre features
# obteve-se uma média de acurácia de precisão de 80% e um recall de 80%, 
# utilizando apenas a função Pipeline. Já encontrando os melhores parâmetros 
# através do GridSeachCV, conseguiu-se uma acurácia de 81%. 
# Sendo os parâmetros:
#
# clf__alpha: 0.01
# tfidf__use_idf: False
# vect__ngram_range: (1, 2)
#
# Verificando sua matriz de confusão é possível verificar que sua precisão é
# baixa:
# [[203  51]
# [ 53 193]]
#
# Seu tempo de execução (treinamento e teste) foi em média 1 min e 25 segundos.
#
##############################################################################
# Utilizando o classificador SGDClassifier, obteve-se um aumento de acurácia
# pouco significativa, de 82% utilizando apenas a função de Pipeline(). Já
# utilizando a fução de GridSearchCV(), obteve-se uma precisão de 83%. Os parâ-
# metros melhores encontrados foram:
#
# clf__alpha: 0.001
# tfidf__use_idf: False
# vect__ngram_range: (1, 1)
#
# Sua matriz de confusão:
# [[206  40]
# [ 45 209]]
#
# Seu tempo de execução com os parâmetros foi em média de 2 minutos.
#
#############################################################################
# Observou-se que, embora o classificador SDG tenha conseguido uma acurácia de
# valor pouco maior que o classificador Multinomail Naive Bayer, seu tempo de 
# execução foi maior. Para o tamanho do dataset utilizado, essa diferença leva
# a utilização do classificador SDG para identificar dos reviews de filmes.