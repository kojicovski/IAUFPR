### Instalação dos pacotes necessários
install.packages("klaR")
library(klaR)

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/agrupamento/")
dados <- read.csv("Material 07 - 2 - Moveis - Dados.csv")
View(dados)

set.seed(4)
cluster.results <- kmodes(dados, 10, iter.max = 10, weighted = FALSE ) 
cluster.results

### Cria um arquivo com todos os registros e mais os clusters de cada um
resultado <- cbind(dados, cluster.results$cluster)
resultado
