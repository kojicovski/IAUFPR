# Dadas as leituras mensais em um medidor de consumo de energia elétrica
# Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez
# 9839 10149 10486 10746 11264 11684 12082 12599 13004 13350 13717 14052


# a) Crie um vetor com todas as leituras.

# cria um vetor
vet <- c(9839,10149,10486,10746,11264,11684,12082,12599,13004,13350,13717,14052)
vet

# b) Calcule a média das leituras no período

min_test <- mean(vet)
m
  
# c) Calcule o máximo e o mínimo das leituras no período

max_test <- max(vet)
max_test

min_test <- min(vet)
min_test

length(vet)
  
# d) Ordene as medidas de forma crescente e decrescente

sort(vet, decreasing=T)
order(vet, decreasing=F)
order(vet, decreasing=T)
