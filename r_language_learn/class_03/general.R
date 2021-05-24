install.packages("e1071")
install.packages("randomForest")
install.packages("kernlab")
install.packages("caret")
library("caret")

#dataset iris
data(iris)
dataset <- iris
head(dataset)

#Partitioning bases in training (80%) and testing (20%)
#species-based
index <- createDataPartition(dataset$Species, p=0.75, list=FALSE)
train_ <- dataset[index,]
test <- dataset[-index,]

#Random Forest training
set.seed(7)
rf <- train(Species~., data=train_, method="rf")
predict.rf <- predict(rf, test)

#Confusion Matrix
confusionMatrix(predict.rf, test$Species)


#SVM model
set.seed(7)
svm <- train(Species~., data=train_, method="svmRadial")
predict.svm <- predict(svm, test)
confusionMatrix(predict.svm, test$Species)