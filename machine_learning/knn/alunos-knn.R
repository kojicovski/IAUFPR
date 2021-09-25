### Instalação dos pacotes
library(caret)

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/pratica-alunos/")
data <- read.csv("Material 02 - 10 – Alunos - Dados.csv")

### Ver dados
#View(data)


### Cria arquivos de treino e teste
set.seed(4)
ind <- createDataPartition(data$G3, p=0.80, list = FALSE)
treino <- data[ind,]
teste <- data[-ind,]

### Prepara um grid com os valores de k que serão usados 
tuneGrid <- expand.grid(k = seq(from=1, to=45, by=2))

### Executa o Knn com esse grid
set.seed(4)
knn <- train(G3 ~ ., data = treino, method = "knn",
             tuneGrid=tuneGrid)
knn

### Aplica o modelo no arquivo de teste
predict.knn <- predict(knn, teste)

### Mostra as métricas
library(Metrics)

r2 <- function(predito, observado) {
  return(1 - (sum((predito-observado)^2) / sum((predito-mean(observado))^2)))
}

Syx <- function(obs, pred, n){
  return(sqrt(sum((obs - pred) ^ 2) / (n - 2)))
}

r2(teste$G3, predict.knn)
Syx(teste$G3, predict.knn, length(predict.knn))
cor(teste$G3, predict.knn, method="pearson")
rmse(teste$G3, predict.knn)
mae(teste$G3, predict.knn)

saveRDS(knn,"~/Documents/github/IAUFPR/machine_learning/randonForest/aluno-best-knn.rds")

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv("Material 02 - 10 – Alunos - Dados - Novos Casos.csv")
View(dados_novos_casos)

predict.knn <- predict(knn, dados_novos_casos)
dados_novos_casos$G3 <- NULL
resultado <- cbind(dados_novos_casos, predict.knn)
View(resultado)
