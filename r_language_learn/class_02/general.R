#Just a test with matrix in R

cities <- matrix(0,nrow = 4, ncol = 4)

colnames(cities) <- c("atenas","madri","paris","estocolmo")
rownames(cities) <- c("atenas","madri","paris","estocolmo")

cities["atenas","paris"] <- 3000
cities["atenas","estocolmo"] <- 3927
cities["madri","paris"] <- 1273
cities["atenas","madri"] <- 3949
cities["paris","estocolmo"] <- 1827
cities["madri","estocolmo"] <- 3188

cities["paris","atenas"] <- 3000
cities["estocolmo","atenas"] <- 3927
cities["paris","madri"] <- 1273
cities["madri","atenas"] <- 3949
cities["estocolmo","paris"] <- 1827
cities["estocolmo","madri"] <- 3188

cities