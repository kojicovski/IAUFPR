
#install.packages('arules', dep=T)
library(arules)
library(datasets)

### Leitura dos dados
setwd("~/Documents/UFPR/data_bases/associacao/")
dados <- read.transactions(file="Material 08 – 2 - Musculacao - Dados.csv",format="basket",sep=";")
View(dados)
inspect(dados[1:26])

### Podemos ver a frequência dos 10 primeiros itens:
itemFrequencyPlot(dados, topN=10, type='absolute')
summary(dados)


### Agora vamos obter as regras:
### Primeiramente definimos o Suporte=0,001 e Confiança=0,7
set.seed(4)
rules <- apriori(dados, parameter = list(supp = 0.02, conf = 0.85, minlen=2))
summary(rules)


### Vamos ver as 5 primeiras regras ordenadas pela confiança:
options(digits=2)
inspect(sort(rules[1:79], by="confidence"))
