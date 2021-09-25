### Pacotes necessários:
install.packages("e1071") 
install.packages("kernlab")
install.packages("randomForest") 
install.packages("caret")
library("caret")

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-alunos/")
data <- read.csv("Material 02 - 10 – Alunos - Dados.csv")

### Ver dados
#View(data)


### Criar bases de Treino e Teste
set.seed(4)
indices <- createDataPartition(data$G3, p=0.80,list=FALSE)
treino <- data[indices,]
teste <- data[-indices,]

### Treinar Randon Forest com a base de Treino 
set.seed(4)
rf <- train(G3~., data=treino, method="rf")
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

r2(teste$G3, predicoes.rf)
Syx(teste$G3, predicoes.rf, length(predicoes.rf))
cor(teste$G3, predicoes.rf, method="pearson")
rmse(teste$G3, predicoes.rf)
mae(teste$G3, predicoes.rf)

#### Cross-validation RF
ctrl <- trainControl(method = "cv", number = 10)

set.seed(4)
cv_rf <- train(G3~., data=treino, method="rf", trControl=ctrl)
cv_rf
cv_predicoes.rf <- predict(cv_rf, teste)

### Calcular as métricas
r2(cv_predicoes.rf ,teste$G3)
Syx(teste$G3, cv_predicoes.rf, length(cv_predicoes.rf))
cor(teste$G3, cv_predicoes.rf, method="pearson")
rmse(teste$G3, cv_predicoes.rf)
mae(teste$G3, cv_predicoes.rf)

#### Vários mtry
tuneGrid = expand.grid(mtry=seq(from=1, to=45, by=2))

set.seed(4)
tun_rf <- train(G3~., data=data, method="rf", trControl=ctrl, tuneGrid=tuneGrid)
tun_rf

### matriz de confusao com todos os dados
tun_predict.rf <- predict(tun_rf, teste)

r2(tun_predict.rf ,teste$G3)
Syx(teste$G3, tun_predict.rf, length(tun_predict.rf))
cor(teste$G3, tun_predict.rf, method="pearson")
rmse(teste$G3, tun_predict.rf)
mae(teste$G3, tun_predict.rf)

### SALVAR O MELHOR MODELO PARA USO NA PRÁTICA

###SALVAR O MODELO
saveRDS(tun_rf,"~/Documents/github/IAUFPR/machine_learning/randonForest/alunos-best-rf.rds")

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv("Material 02 - 10 – Alunos - Dados - Novos Casos.csv")
View(dados_novos_casos)

predict.rf <- predict(tun_rf, dados_novos_casos)
dados_novos_casos$G3 <- NULL
resultado <- cbind(dados_novos_casos, predict.rf)
View(resultado)
