library(arules)

# Set working directory
setwd("D:/Documentos/UFPR/1.REPO/iaa-ufpr-r/pratica-compras/")

# Read data
dataframe <- read.transactions(file="Material 08 – 1 - Lista de Compras - Dados.csv", format="basket", sep=";")
inspect(dataframe)
itemFrequencyPlot(dataframe)

# Extract rules
set.seed(4)
rules <- apriori(dataframe, parameter=list(supp=0.3, conf=0.6, target="rules"))
inspect(rules)