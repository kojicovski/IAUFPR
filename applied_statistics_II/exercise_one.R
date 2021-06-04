#import data of ceo.txt
ceo <- read.table("./ceo.txt", header = TRUE, sep = "", 
                   na.strings = "NA", dec = ".", strip.white = TRUE)
save ("ceo", file = "./ceo.RData")
load("./ceo.RData")

#statistics summary
summary(ceo)

#preliminary model
library (Rcmdr)

library(RcmdrMisc)

normalityTest(~salary, test="lillie.test", data=ceo)

result <- lm(salary ~ age + college + grad + comten + ceoten + sales + profits
             + mktval + profmarg, data = ceo)

summary(result)

install.packages("PanJen")
library("PanJen")

formBase <- formula(salary ~ age + college + grad + comten + ceoten + sales 
                    + profits + mktval + profmarg)

summary(gam(formBase, method="GCV.Cp", data = ceo))

#variables specification - Get the smaller BIC
#Do not test binary variables
PanJenArea<-fform(ceo,"age",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"comten",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"ceoten",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"sales",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"profits",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"mktval",formBase,distribution=gaussian)

PanJenArea<-fform(ceo,"profmarg",formBase,distribution=gaussian)

#Testing the modified model
#ceoten x^2
#sales sqr(x)
#mktval sqr(x)
#profmarg sqr(x)

ceo$ceoten2 <- with(ceo, ceoten^2)
ceo$salessqrt <- with(ceo, sqrt(sales))
ceo$mktvalsqrt <- with(ceo, sqrt(mktval))
ceo$profmarg_prof2 <- with(ceo, profmarg+profmarg^2)

save ("ceo", file = "./ceo.RData")

library(Rcmdr)


result1 <- lm(salary ~ age + college + grad + comten + ceoten + sales + profits
             + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
             + profmarg_prof2, data = ceo)

summary(result1)


#removing outliers by Bonferroni's test
library (carData)
library(car)

outlierTest(result1)
ceo <- ceo[-c(74, 103),]

result1 <- lm(salary ~ age + college + grad + comten + ceoten + sales + profits
              + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
              + profmarg_prof2, data = ceo)

summary(result1)

save ("ceo", file = "./ceo.RData")

#Reset test - model of specification

library (zoo)
library (lmtest)

resettest(salary ~ age + college + grad + comten + ceoten + sales + profits
          + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
          + profmarg_prof2, power=2:3, type="regressor", data=ceo)

qf(.95, df1=54, df2=130)

#Residuals autocorrelation
#employable for time series data

library(lmtest)

dwtest(salary ~ age + college + grad + comten + ceoten + sales + profits
       + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
       + profmarg_prof2,  alternative="greater", data=ceo)

#Estimator sandwich "HAC"
library(sandwich)

summary(result1)

coeftest(result1, vcov. = vcovHAC)


#Heteroscedasticity test

bptest(salary ~ age + college + grad + comten + ceoten + sales + profits
       + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
       + profmarg_prof2, studentize=FALSE, data=ceo)

chisup <- qchisq(.95, df = 13)
chisup


# Correction of non-constant variance by robust regression

library(Rcmdr)
library (lmtest)
library (sandwich)

result1 <- lm(salary ~ age + college + grad + comten + ceoten + sales + profits
              + mktval + profmarg + ceoten2 + salessqrt + mktvalsqrt 
              + profmarg_prof2, data = ceo)

summary(result1)

coeftest(result1, vcov=vcovHC(result1, type="HC1"))

# Models by STEPWISE - use BIC for calculation
library(Rcmdr)

stepwise(result1, direction= 'backward', criterion ='BIC')

result_final <- lm(formula = salary ~ comten + ceoten + profmarg + ceoten2 + 
                     mktvalsqrt + profmarg_prof2, data = ceo)
summary(result_final)

# Retest - Heteroscedasticity test
bptest(salary ~ comten + ceoten + profmarg + ceoten2 + 
         mktvalsqrt + profmarg_prof2, studentize=FALSE, data=ceo)

chisup <- qchisq(.95, df = 24.551)
chisup

#
AIC (result1)
BIC (result1)

install.packages("AICcmodavg")

library(AICcmodavg)

# AICc used for small samples
AICc (result1)

library(performance)
model_performance(result1)
model_performance(result_final)

confint(result1)
confint(result_final)
