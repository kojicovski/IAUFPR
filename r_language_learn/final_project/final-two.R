library("caret")
library("mlbench")
library("randomForest")

#Set directory file
setwd("C:/Users/Smart/Documents/IAA/IAUFPR/r_language_learn/final_project")
start_time <- Sys.time()

#Load dataset from csv
dataset <- read.csv2("http://www.razer.net.br/datasets/Volumes.csv")
dataset$NR <- NULL

#Create data partition
#<20% test>
#<80% train>
index <- createDataPartition(dataset$VOL, p=0.80, list=FALSE)
train_ <- dataset[index,]
test <- dataset[-index,]

#R-Squared function
#Return <dinamic int/double>
r2 <- function(obs, pred){
  return(1-(sum((obs - pred) ^ 2) / sum((obs - mean(obs))^2)))
}

#Standard Error function
#Return <dinamic int/double>
Syx <- function(obs, pred, n){
  return(sqrt(sum((obs - pred) ^ 2) / (n - 2)))
}

#SVM method
set.seed(7)
svm <- train(VOL~., data=train_, method="svmRadial", linout=T)
predict.svm <- predict(svm, test)
#predict.svm

svm_r2_result <- r2(test$VOL, predict.svm)
#svm_r2_result

svm_Syx_result <- Syx(test$VOL, predict.svm, length(predict.svm))
#svm_Syx_result

#RNA Method
set.seed(7)
rna <- train(VOL~., data=train_, method="neuralnet")
predict.rna <- predict(rna, test)
#predict.rna

rna_r2_result <- r2(test$VOL, predict.rna)
#rna_r2_result

rna_Syx_result <- Syx(test$VOL, predict.rna, length(predict.rna))
#rna_Syx_result

#Random Forest method
set.seed(7)
rf <- train(VOL~., data=train_, method="rf", linout=T)
predict.rf <- predict(rf, test)

rf_r2_result <- r2(test$VOL, predict.rf)
#rf_r2_result

rf_Syx_result <- Syx(test$VOL, predict.rf, length(predict.rf))
#rf_Syx_result

#Alometric method
set.seed(7)
alom <- nls(VOL ~ b0 + b1*DAP*DAP*HT, train_, start=list(b0=0.5, b1=0.5))
predict.alom <- predict(alom, test)
#predict.alom

alom_r2_result <- r2(test$VOL, predict.alom)
#alom_r2_result

alom_Syx_result <- Syx(test$VOL, predict.alom, length(predict.alom))
#alom_Syx_result

end_time <- Sys.time()

final_time <- end_time - start_time
paste("Timer of train methods: ", final_time)

# Prints
cat(paste("Method |   R²  |  Syx",
          "\nRF     |", round(rf_r2_result, 5), "|", round(rf_Syx_result, 5), 
          "\nSVM    |", round(svm_r2_result, 5), "|", round(svm_Syx_result, 5),
          "\nNNET   |", round(rna_r2_result, 5), "|", round(rna_Syx_result, 5),
          "\nALOM   |", round(alom_r2_result, 5), "|", round(alom_Syx_result, 5),
          sep=""))


# Train the best model according
best_model <- randomForest(VOL~., 
                           data=dataset, 
                           type="regression", 
                           importance=TRUE)

final_predict.rf <- predict(best_model, dataset)

# Get the R2 and Syx
rf_r2_final <- r2(dataset$VOL, final_predict.rf)
rf_Syx_final <- Syx(dataset$VOL, final_predict.rf, length(final_predict.rf))

typeof(rf_r2_final)
# Prints
cat(paste("     Random Forest \n |   R²   |  Syx   |\n",
          "|", round(rf_r2_final, 4), "|", round(rf_Syx_final, 4), "|" ))
# Save model
saveRDS(best_model, "tree_volumes_random_forest.rds")


