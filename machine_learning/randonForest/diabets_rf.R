### Pacotes necessários:
#install.packages("e1071") 
#install.packages("kernlab")
#install.packages("caret")
#install.packages("randomForest") 
library("caret")
library("mice")

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-diabets/")
tmp_data <- read.csv("Material 02 - 9 – C - Diabetes - Dados.csv")

### Retira o ID e preenche valores faltantes
set.seed(4)
imp <- mice(tmp_data) 
data <- complete(imp, 1)
View(data)

### Criar bases de Treino e Teste
set.seed(4)
indices <- createDataPartition(data$diabetes, p=0.80,list=FALSE)
treino <- data[indices,] 
teste <- data[-indices,]

### Treinar Random Forest com a base de Treino
set.seed(4)
rf <- train(diabetes~., data=treino, method="rf")
rf

### 6. Aplicar modelos treinados na base de Teste
predict.rf <- predict(rf, teste)
confusionMatrix(predict.rf, as.factor(teste$diabetes)) 

#### Cross-validation
ctrl <- trainControl(method = "cv", number = 10)

set.seed(4)
rf <- train(diabetes~., data=treino, method="rf", trControl=ctrl)
rf

### matriz de confusao com todos os dados
predict.rf <- predict(rf, teste)
confusionMatrix(predict.rf, as.factor(teste$diabetes))

#### Vários mtry
tuneGrid = expand.grid(mtry=c(2, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23))

set.seed(4)
rf <- train(diabetes~., data=treino, method="rf", trControl=ctrl, tuneGrid=tuneGrid)
rf

### matriz de confusao com todos os dados
predict.rf <- predict(rf, teste)
confusionMatrix(predict.rf, as.factor(teste$diabetes))

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

### EXECUTAR UM MODELO COM OS MELHORES HIPERPARÂMETROS
tuneGrid = expand.grid(mtry=c(9))

set.seed(4)
best_model_rf <- train(diabetes~., data=treino, method="rf", trControl=ctrl, tuneGrid=tuneGrid)
best_model_rf

best_predict.rf <- predict(best_model_rf, teste)
confusionMatrix(best_predict.rf, as.factor(teste$diabetes))

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

###SALVAR O MODELO
saveRDS(best_model_rf,"~/Documents/github/IAUFPR/machine_learning/randonForest/diabets_best_rf.RDS")

### LER E APLICAR O MODELO
modelo_lido <- readRDS("~/Documents/github/IAUFPR/machine_learning/randonForest/diabets_best_rf.RDS")
predict_best <- predict(modelo_lido, teste)
result = cbind(teste, predict_best)

View(result)
