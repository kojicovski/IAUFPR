### Pacotes necessários:
install.packages("e1071") 
install.packages("caret")
library("caret")


### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-diabets/")
data <- read.csv("Material 02 - 9 – C - Diabetes - Dados.csv")

# Remove missing or non-util values
View(data)

### Cria um arquivo com treino com 80% e teste com 20% das linhas de forma randomizada
set.seed(4)
ran <- sample(1:nrow(data), 0.8 * nrow(data))
treino <- data[ran,] 
teste <- data[-ran,]

knn_control <- trainControl(verboseIter = TRUE)

### Faz um grid com valores para K e Executa o KNN
tuneGrid <- expand.grid(k = c(1,3,5,7,9,11,13,15))

set.seed(4)
knn <- train(diabetes ~ ., data = treino, trControl=knn_control, method = "knn",tuneGrid=tuneGrid)
knn


### Faz a predição e mostra a matriz de confusão
predict.knn <- predict(knn, teste)
confusionMatrix(predict.knn, as.factor(teste$diabetes))

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

### EXECUTAR UM MODELO COM OS MELHORES HIPERPARÂMETROS
tuneGrid <- expand.grid(k = c(15))

set.seed(4)
best_model_knn <- train(diabetes ~ ., data = treino, method = "knn",tuneGrid=tuneGrid)
best_model_knn

best_predict.knn <- predict(best_model_knn, teste)
confusionMatrix(best_predict.knn, as.factor(teste$diabetes))
### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

###SALVAR O MODELO
saveRDS(best_model_knn,"~/Documents/github/IAUFPR/machine_learning/knn/diabets-knn.rds")

### LER E APLICAR O MODELO
modelo_lido <- readRDS("~/Documents/github/IAUFPR/machine_learning/knn/diabets-knn.rds")

best_predict_knn <- predict(modelo_lido, teste)
result = cbind(teste, best_predict_knn)
result$diabetes <- NULL

confusionMatrix(best_predict_knn, as.factor(teste$diabetes))

View(result)
