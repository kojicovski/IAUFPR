# Install packages
install.packages("e1071")
install.packages("kernlab")
install.packages("caret")
install.packages("mlbench")
install.packages("mice")
library(kernlab)
library(caret)
library(mlbench)
library(mice)

# Set working directory
setwd("D:/Documentos/UFPR/1.REPO/iaa-ufpr-r/pratica-cancer-de-mama")

# Read data
data <- read.csv("Material 02 - 2 - Cancer de Mama - Dados.csv")
#View(data)

# Remove missing or non-util values
set.seed(4)
data$Id   <- NULL
values    <- mice(data)
dataframe <- complete(values, 1)

# Partionate database (train and test)
set.seed(4)
index <- createDataPartition(dataframe$Class, p=0.80, list=FALSE)
train <- dataframe[index,]
test  <- dataframe[-index,]

# Train model 
set.seed(4)
svm.holdout <- train(Class~., data=train, method='svmRadial')
#svm.holdout

# Predict values based in test set (hold-out)
predict_holdout.svm <- predict(svm.holdout, test)

# Confusion matrix
confusionMatrix(predict_holdout.svm, as.factor(test$Class))

# Save model
save(svm.holdout, file="svm_holdout.RData")
# load("svm_holdout.RData")

# ----------------------------------------------------------------#
# Cross validation
cv_control <- trainControl(method="cv", number=10)

# Execute RNA with cross-validation
set.seed(4)
svm.cv <- train(Class~., data=train, method='svmRadial',  trControl=cv_control)
#svm.cv

# Predict values based in test set (cross-validation)
predict_cv.svm <- predict(svm.cv, test)

# Confusion matrix
confusionMatrix(predict_cv.svm, as.factor(test$Class))

# Save model
save(svm.cv, file="svm_cv.RData")
# load("svm_cv.RData")

# ----------------------------------------------------------------#
# SVM parameters
grid <- expand.grid(C=c(1,2,5,10,25,50,100,200), sigma=c(0.01, 0.015, 0.020, 0.1, 0.2, 0.3, 0.4))

set.seed(4)
svm.tuned <- train(form=Class~., data=train, method='svmRadial', tuneGrid=grid, trControl=cv_control)
#svm.tuned

# Predict values based in test set (cross-validation tuned)
predict_tuned.svm <- predict(svm.tuned, test)

# Confusion matrix
confusionMatrix(predict_tuned.svm, as.factor(test$Class))

# Save model
save(svm.tuned, file="svm_tuned.RData")
# load("svm_tuned.RData")

#------------------------------------------------------------------#
# Read new data
new_data <- read.csv("Material 02 - 2 - Cancer de Mama - Dados - Novos Casos.csv")
#View(new_data)

# Remove missing or non-util values
set.seed(4)
new_data$Id    <- NULL
new_data$Class <- NULL

# Predict values based in test set (cross-validation)
predict_tuned.svm <- predict(svm.tuned, new_data)

# Insert values in dataframe
result = cbind(new_data, predict_tuned.svm)
View(result)

# Save the best model
saveRDS(svm.tuned, "svm_tuned.rds")

#------------------------------------------------------------------#
# Execute a model with the best hyperparameters
best_grid <- expand.grid(C=c(1), sigma=c(0.02))

set.seed(4)
svm.best <- train(form=Class~., data=dataframe, method='svmRadial', tuneGrid=best_grid, trControl=cv_control)

# Save the best model (size and decay fixed)
saveRDS(svm.best, "svm_best.rds")

# Predict values based in test set
predict_best.svm <- predict(svm.best, test)

# Confusion matrix
confusionMatrix(predict_best.svm, as.factor(test$Class))
