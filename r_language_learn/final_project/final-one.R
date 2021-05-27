install.packages("e1071")
install.packages("randomForest")
install.packages("kernlab")
install.packages("caret")
install.packages("mlbench")
library("caret")
library("mlbench")

data(Satellite)
dataset <- Satellite
summary(dataset)

#Partitioning bases in training (80%) and testing (20%)
#species-based
index <- createDataPartition(dataset$classes, p=0.75, list=FALSE)
train_ <- dataset[index,]
test <- dataset[-index,]

#Random Forest training
set.seed(7)
rf <- train(classes~., data=train_, method="rf")
predict.rf <- predict(rf, test)

#Confusion Matrix
confusionMatrix(predict.rf, test$classes)

#SVM method
set.seed(7)
svm <- train(classes~., data=train_, method="svmRadial")
predict.svm <- predict(svm, test)

#Confusion Matrix
confusionMatrix(predict.svm, test$classes)

#RNA method
set.seed(7)
rna <- train(classes~., data=train_, method="nnet",trace=F)
predict.rna <- predict(rna, test)

#Confusion Matrix
confusionMatrix(predict.rna, test$classes)