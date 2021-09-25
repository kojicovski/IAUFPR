### Pacotes necessários:
install.packages("e1071") 
install.packages("kernlab")
install.packages("randomForest") 
install.packages("caret")
library("caret")

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-biomassa/")
data <- read.csv("Material 02 - 4 - R - Biomassa - Dados.csv")

### Ver dados
#View(data)


### Criar bases de Treino e Teste
set.seed(4)
indices <- createDataPartition(data$biomassa, p=0.80,list=FALSE)
treino <- data[indices,]
teste <- data[-indices,]

### Treinar Randon Forest com a base de Treino 
set.seed(4)
rf <- train(biomassa~., data=treino, method="rf")
rf

### 6. Aplicar modelos treinados na base de Teste
predicoes.rf <- predict(rf, teste)

### Calcular as métricas
#install.packages("Metrics")
library(Metrics)

r2 <- function(predito, observado) {
  return(1 - (sum((predito-observado)^2) / sum((observado-mean(observado))^2)))
}

Syx <- function(obs, pred, n){
  return(sqrt(sum((obs - pred) ^ 2) / (n - 2)))
}

r2(teste$biomassa, predicoes.rf)
Syx(teste$biomassa, predicoes.rf, length(predicoes.rf))
rmse(teste$biomassa, predicoes.rf)
mae(teste$biomassa, predicoes.rf)
cor(teste$biomassa, predicoes.rf, method="pearson")

#### Cross-validation RF
ctrl <- trainControl(method = "cv", number = 10)

set.seed(4)
cv_rf <- train(biomassa~., data=treino, method="rf", trControl=ctrl)
cv_rf
cv_predicoes.rf <- predict(rf, teste)

### Calcular as métricas
r2(cv_predicoes.rf ,teste$biomassa)
Syx(teste$biomassa, cv_predicoes.rf, length(cv_predicoes.rf))
rmse(teste$biomassa, cv_predicoes.rf)
mae(teste$biomassa, cv_predicoes.rf)
cor(teste$biomassa, cv_predicoes.rf, method="pearson")

#### Vários mtry
tuneGrid = expand.grid(mtry=c(2, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23))

set.seed(4)
tun_rf <- train(biomassa~., data=data, method="rf", trControl=ctrl, tuneGrid=tuneGrid)
tun_rf

### matriz de confusao com todos os dados
tun_predict.rf <- predict(tun_rf, teste)

r2(tun_predict.rf ,teste$biomassa)
Syx(teste$biomassa, tun_predict.rf, length(tun_predict.rf))
cor(teste$biomassa, tun_predict.rf, method="pearson")
rmse(teste$biomassa, tun_predict.rf)
mae(teste$biomassa, tun_predict.rf)

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

###SALVAR O MODELO
saveRDS(tun_rf,"~/Documents/github/IAUFPR/machine_learning/randonForest/biomassa-rf.rds")

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv("Material 02 - 4 - R - Biomassa - Dados - Novos Casos.csv")
View(dados_novos_casos)

predict.rf <- predict(tun_rf, dados_novos_casos)
dados_novos_casos$biomassa <- NULL
resultado <- cbind(dados_novos_casos, predict.rf)
View(resultado)
