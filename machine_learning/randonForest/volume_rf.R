### Pacotes necessários:
install.packages("e1071") 
install.packages("kernlab")
install.packages("randomForest") 
install.packages("caret")
library("caret")

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-volume/")
data <- read.csv("Material 02 - 3 – Estimativa de Volume - Dados.csv")

### Ver dados
#View(data)


### Criar bases de Treino e Teste
set.seed(4)
indices <- createDataPartition(data$Volume, p=0.80,list=FALSE)
treino <- data[indices,] 
teste <- data[-indices,]

### Treinar Randon Forest com a base de Treino 
set.seed(4)
rf <- train(Volume~., data=treino, method="rf")
rf

### 6. Aplicar modelos treinados na base de Teste
predicoes.rf <- predict(rf, teste)

### Calcular as métricas
#install.packages("Metrics")
library(Metrics)
rmse(teste$Volume, predicoes.rf)


r2 <- function(predito, observado) {
  return(1 - (sum((predito-observado)^2) / sum((observado-mean(observado))^2)))
}

Syx <- function(obs, pred, n){
  return(sqrt(sum((obs - pred) ^ 2) / (n - 2)))
}

r2(teste$Volume, predicoes.rf)
Syx(teste$Volume, predicoes.rf, length(predicoes.rf))
mae(teste$Volume, predicoes.rf)
cor(teste$Volume, teste$Idade, method="pearson")

#### Cross-validation RF
ctrl <- trainControl(method = "cv", number = 10)

set.seed(4)
rf <- train(Volume~., data=treino, method="rf", trControl=ctrl)
rf
predicoes.rf <- predict(rf, teste)

### Calcular as métricas
r2(predicoes.rf ,teste$Volume)
Syx(teste$Volume, predicoes.rf, length(predicoes.rf))
rmse(teste$Volume, predicoes.rf)
mae(teste$Volume, predicoes.rf)
cor(teste$Volume, predicoes.rf, method="pearson")

#### Vários mtry
tuneGrid = expand.grid(mtry=c(2, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23))

set.seed(4)
tun_rf <- train(Volume~., data=data, method="rf", trControl=ctrl, tuneGrid=tuneGrid)
tun_rf

### matriz de confusao com todos os dados
tun_predict.rf <- predict(rf, teste)


r2(tun_predict.rf,teste$Volume)
Syx(teste$Volume, tun_predict.rf, length(tun_predict.rf))
rmse(teste$Volume, tun_predict.rf)
mae(teste$Volume, tun_predict.rf)
cor(teste$Volume, tun_predict.rf, method="pearson")

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

###SALVAR O MODELO
saveRDS(best_model_knn,"~/Documents/github/IAUFPR/machine_learning/randonForest/volume-rf.rds")

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv("Material 02 - 3 – Estimativa de Volume - Dados - Novos Casos.csv")
View(dados_novos_casos)

predict.rf <- predict(rf, dados_novos_casos)
dados_novos_casos$biomassa <- NULL
resultado <- cbind(dados_novos_casos, predict.rf)
View(resultado)
