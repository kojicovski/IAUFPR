#1 matrix
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

#2 list
v1 <- c(2005:2016)
v2 <- c(1:12)
v3 <- c(1:31)

date <- list(year=v1,month=v2,day=v3)
date

vec <- c(1,3,4,7,11,18,29)
list_test <- list("x*2"=vec*2,"x/2"=vec/2,"sqrt(x)"=sqrt(vec))

list_test[["sqrt(x)"]][3:5]

#3 dataframe
df <- data.frame(letter=letters[1:10], num=21:30, value=rnorm(10))
#return line 5
df[5,]
#return col 2 (as vector and data frame -drop=F)
df[,2] #
df[,2,drop=F] #as factor
#return col 2,3
df[,2:3]
#return line 6, but just col 1,3
df[6,2:3]
print(df)
#return col "value" && greater  than zero
ret <- df[df$"value">0,]
ret["value"]
#return col "num" && odd number
ret1 <- df[df$"num"%%2==1,]
ret1["num"]
#return col "value" > 0 and col "num" pair number
ret2 <- df[df$"value">0 & df$"num"%%2==0,]
ret2
#return col "letter" 'b', 'g', 'h'
ret3 <- df[df$"letter" %in% c("b","h","g"),]
ret3


#4 dataframe joins
#Make two dataframes and execute merges
people <- data.frame(name=c("Samuel","Kojicovski","Gabriela","Oliveira"),cityId=c(3,10,2,3))
cities1 <- data.frame(cityId=c(1,2,3,4), city=c("Curitiba", "SJP", "Pinhais", "Colombo"))
#cross join
merge(people, cities1, by=NULL)
#inner join
merge(people, cities1, by="cityId")
#outer join
merge(people, cities1, by="cityId", all=T)
#left  outer join
merge(people, cities1, by="cityId", all.x=T)
#right outer join
merge(people, cities1, by="cityId", all.y=T)

#5
n <- 10
sex <- sample(c("male", "female"), n, replace=TRUE)
age <- sample (12:102, n, replace=TRUE)
weight <- sample(50:90, n, replace=TRUE)
minor <- age<18

people <- data.frame(sex=sex, age=age, weight=weight, minor=minor, stringsAsFactors=TRUE)
str(people)

#order by weight
people[order(people$weight),]
#order by weight and sex
people[order(people$sex, -people$weight),]
#max age
max(people$age)
#mean age
mean(people$age)
#just female
people[people$sex=="female",]
#count female
nrow(people[people$sex=="female",])

######files
data <- read.csv("http://www.razer.net.br/datasets/fruitohms.csv")
head(data)

biomass <- read.csv2("http://www.razer.net.br/datasets/Biomassa_REG.csv")
head(biomass)

fertility <- read.csv("http://www.razer.net.br/datasets/fertility.csv")
head(fertility)

data1 <- iris
data2 <- iris
write.table(data1, "r_language_learn/class_02/iris.txt", 
            sep="**",dec=".", row.names=F,col.names=F)
head(data1)

write.table(data2, "r_language_learn/class_02/iris2.csv", 
            sep="**",dec=".", row.names=F, col.names=T, quote=F)
head(data2)