# Install packages
install.packages("e1071")
install.packages("caret")
install.packages("mlbench")
install.packages("mice")
library(caret)
library(mlbench)
library(mice)

# Set working directory
setwd("/home/kojicovski/Documents/UFPR/data_bases/pratica-cancer-de-mama")

# Read data
data <- read.csv("Material 02 - 2 - Cancer de Mama - Dados.csv")
#View(data)

# Remove missing or non-util values
set.seed(4)
data$a   <- NULL
values    <- mice(data)
dataframe <- complete(values, 1)

# Partionate database (train and test)
set.seed(4)
index <- createDataPartition(dataframe$Class, p=0.80, list=FALSE)
train <- dataframe[index,]
test  <- dataframe[-index,]

# Train model 
set.seed(4)
rna.holdout <- train(Class~., data=train, method='nnet', trace=FALSE)
#rna.holdout

# Predict values based in test set (hold-out)
predict_holdout.rna <- predict(rna.holdout, test)

# Confusion matrix
confusionMatrix(predict_holdout.rna, as.factor(test$Class))

# Save model
save(rna.holdout, file="rna_holdout.RData")
# load("rna_holdout.RData")

# Cross validation
cv_control <- trainControl(method="cv", number=10)

# Execute RNA with cross-validation
set.seed(4)
rna.cv <- train(Class~., data=train, method='nnet', trace=FALSE, trControl=cv_control)
#rna.cv

# Predict values based in test set (cross-validation)
predict_cv.rna <- predict(rna.cv, test)

# Confusion matrix
confusionMatrix(predict_cv.rna, as.factor(test$Class))

# Save model
save(rna.cv, file="rna_cv.RData")
# load("rna_cv.RData")

# RNA parameters
grid <- expand.grid(size=seq(from=1, to=45, by=10), decay=seq(from=0.1, to=0.9, by=0.3))

set.seed(4)
rna.tuned <- train(form=Class~., data=train, method='nnet', tuneGrid=grid, trace=FALSE, trControl=cv_control, maxit=2000)
#rna.tuned

# Predict values based in test set (cross-validation tuned)
predict_tuned.rna <- predict(rna.tuned, test)

# Confusion matrix
confusionMatrix(predict_tuned.rna, as.factor(test$Class))

# Save model
save(rna.tuned, file="rna_tuned.RData")
# load("rna_tuned.RData")

# Read new data
new_data <- read.csv("Material 02 - 2 - Cancer de Mama - Dados - Novos Casos.csv")
#View(new_data)

# Remove missing or non-util values
set.seed(4)
new_data$Id    <- NULL
new_data$Class <- NULL

# Predict values based in test set (cross-validation)
predict_tuned.rna <- predict(rna.tuned, new_data)

# Insert values in dataframe
result = cbind(new_data, predict_tuned.rna)
# View(result)

# Save the best model
saveRDS(rna.tuned, "rna_tuned.rds")

# Execute a model with the best hyperparameters
best_grid <- expand.grid(size = c(1), decay = c(0.7))

set.seed(4)
rna.best <- train(form=Class~., data=dataframe, method='nnet', tuneGrid=best_grid, trace=FALSE, trControl=cv_control, maxit=2000)

# Save the best model (size and decay fixed)
saveRDS(rna.best, "rna_best.rds")

# Predict values based in test set
predict_best.rna <- predict(rna.best, test)

# Confusion matrix
confusionMatrix(predict_best.rna, as.factor(test$Class))
