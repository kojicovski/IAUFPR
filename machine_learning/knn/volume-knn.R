### Instalação dos pacotes
library(caret)

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-volume/")
data <- read.csv("Material 02 - 3 – Estimativa de Volume - Dados.csv")

### Ver dados
#View(data)


### Cria arquivos de treino e teste
set.seed(4)
ind <- createDataPartition(data$Volume, p=0.80, list = FALSE)
treino <- data[ind,]
teste <- data[-ind,]

### Prepara um grid com os valores de k que serão usados 
tuneGrid <- expand.grid(k = c(1,3,5,7,9,11,13,15,17,19,21,23,25))

### Executa o Knn com esse grid
set.seed(4)
knn <- train(Volume ~ ., data = treino, method = "knn",
             tuneGrid=tuneGrid)
knn

### Aplica o modelo no arquivo de teste
predict.knn <- predict(knn, teste)
knn

### Mostra as métricas
library(Metrics)

r2 <- function(predito, observado) {
  return(1 - (sum((predito-observado)^2) / sum((predito-mean(observado))^2)))
}

Syx <- function(obs, pred, n){
  return(sqrt(sum((obs - pred) ^ 2) / (n - 2)))
}

r2(teste$Volume, predict.knn)
Syx(teste$Volume, predict.knn, length(predict.knn))
cor(teste$Volume, teste$Idade, method="pearson")
rmse(teste$Volume, predict.knn)
mae(teste$Volume, predict.knn)

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv("Material 02 - 3 – Estimativa de Volume - Dados - Novos Casos.csv")
View(dados_novos_casos)

predict.knn <- predict(knn, dados_novos_casos)
dados_novos_casos$Volume <- NULL
resultado <- cbind(dados_novos_casos, predict.knn)
View(resultado)
