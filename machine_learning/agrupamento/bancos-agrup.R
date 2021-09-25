install.packages("klaR")
library(ggplot2)
library(klaR)
library(mice)
library(mlbench)

# Set working directory
setwd("~/Documents/UFPR/data_bases/pratica-bancos/")

# Read data
dataframe <- read.csv("Material 02 - 11 – Banco - Dados.csv")
#View(dataframe)

# Remove id column and complete values
set.seed(4)
dataframe$Id <- NULL
values    <- mice(dataframe)
dataframe <- complete(values, 1)

# Execute Kmeans
set.seed(4)
cluster <- kmodes(dataframe, 5, iter.max = 10, weighted = FALSE)
cluster

# Create a file
result <- cbind(dataframe, cluster$cluster)

# Rename column
colnames(result)[which(names(result) == "cluster$cluster")] <- "Cluster"
result

# Plot clusters
clusplot(dataframe, cluster$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)