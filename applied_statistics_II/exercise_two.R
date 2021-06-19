###############################################################################
#################SCRIPT USED FOR SECOND EXERCISE OF APPLIED STATISTIC##########
###############################################################################
setwd("C:/Users/Smart/Documents/IAA/IAUFPR/applied_statistics_II/")

library(readxl)

#import data of prostate.xlsx
prostate <- read_excel("prostate.xlsx")

prostate$ObsNumber <- 1:nrow(prostate)

save ("prostate", file = "./prostate.RData")
load("./prostate.RData")

summary(prostate)

#preliminary model
library (Rcmdr)

library(RcmdrMisc)

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
, data = prostate)

summary(result)

prostate <- within(prostate, {
  residuos <- residuals(result) 
})

save ("prostate", file = "./prostate.RData")

##############################################################################
################################GRUBBS TEST###################################
##############################################################################

# install.packages("outliers")

library ("outliers")

grubbs.test(prostate$residuos, type = 10, opposite = FALSE, two.sided = TRUE)


##############################################################################
################################CHI SQUARE TEST###############################
##############################################################################
load("./prostate.RData")

chisq.out.test(prostate$residuos,opposite=FALSE)


#removing outlier
#if p-value <0.05 there is outlier and his value: -1.88603397103562

prostate <- prostate[prostate$residuos != -1.88603397103562, ]

## New test after of removed outlier

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

prostate <- within(prostate, {
  residuos <- residuals(result) 
})

chisq.out.test(prostate$residuos,opposite=FALSE)

## p_value > 0.05, so there aren't outliers

##############################################################################
#############################Bonferroni Outlier Test##########################
##############################################################################

load("./prostate.RData")

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

library (car)
outlierTest(result)

prostate <- prostate[prostate$ObsNumber != 69, ]

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

outlierTest(result)


##############################################################################
###############################Cook distance test############################
##############################################################################

load("./prostate.RData")

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

prostate <- within(prostate, {
  residuos <- residuals(result) 
})

prostate$cooksd <- cooks.distance(result)

prostate$outlier <- with(prostate, ifelse(cooksd>4/97,"yes","no"))

# Separating outliers
outliers <- prostate[prostate$outlier != "no", ]
outliers


# Plot Outliers's graph

cooksd <- cooks.distance(result)

sample_size <- nrow(prostate)
X11(width = 10, height = 12)
# plot cook's distance
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")
# add cutoff line
abline(h = 4/177, col="red")
# add labels
text(x=2:length(cooksd)+2, y=cooksd, labels=ifelse(cooksd>4/sample_size, 
                                                   names(cooksd),""), col="red")

##############################################################################
#################Kolmogorov-Smirnov e Shapiro-Wilk normality test#############
##############################################################################


load("./prostate.RData")


result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

library (car)
outlierTest(result)

prostate <- prostate[prostate$ObsNumber != 69, ]

result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

outlierTest(result)

prostate <- within(prostate, {
  residuos <- residuals(result) 
})

library("RcmdrMisc")

normalityTest(~residuos, test="lillie.test", data=prostate)

# Vai ficar em pt-br mesmo daqui pra baixo, ficou confuso o entendimento de
# teste de normalidade até a escrita deste script

# H0: Distribuição normal
# HA: Distribuição não normal

# Dtabelado = 1/raiz(n)
# Para n=96 ==> D= 1/raiz(96) = 0,102
#Como Dcalculado é menor que tabelado, aceita-se H0

# A distribuição é normal.
# Toda vez que p-value for menor que 0.05 rejeita-se a normalidade
# caso contrário (se p-value for maior que 0.05) aceita-se a normalidade

#############################################################################
###########################Shapiro-Wilk test#################################
#############################################################################

normalityTest(~residuos, test="shapiro.test", data=prostate)

# H0: Distribuição provém de uma população normalmente distribuída
# HA: Distribuição não provém de uma população normalmente distribuída

# W-tabelado = 0.98198

# p-value = 0.2106
# Como W-calculado (0.98198) é maior que o W-tabelado (0.947) aceita-se H0
# A distribuição provém de uma população com distribuição normal.
# Toda vez que p-value for menor que 0.05 rejeita-se a normalidade, caso 
# contrário (se p-value for maior que 0.05) aceita-se a normalidade.


#############################################################################
#####################Autocorrelation test####################################
#############################################################################
load("./prostate.RData")
library(lmtest)

dwtest(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa, 
       alternative="greater", data=prostate)

# DW = 2.3129, p-value = 0.9318
# alternative hypothesis: true autocorrelation is greater than 0
# There are not correlation


#############################################################################
############################ heteroscedasticity test#########################
#############################################################################

bptest(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa, 
       studentize=FALSE, data=prostate)

#data:  lcavol ~ lweight + age + lbph + svi + lcp + gleason + pgg45 +     lpsa
#BP = 14.854, df = 8, p-value = 0.06205

chisup <- qchisq(0.95, df=8)
chisup

#> chisup <- qchisq(0.95, df=8)
#> chisup
#[1] 15.50731


# Como o resultado do teste BP (14.854) é menor que o tabelado (15.50731)
# aceita-se a hipótese de homocedasticidade 

#############################################################################
######################Stepwise regression####################################
#############################################################################

# Models by STEPWISE - use BIC for calculation
load("./prostate.RData")
result <- lm(lcavol ~  lweight + age + lbph + svi + lcp + gleason + pgg45 + lpsa
             , data = prostate)

summary(result)
library(Rcmdr)

stepwise(result, direction= 'backward', criterion ='BIC')

result_stepwise <- lm(formula = lcavol ~ lcp + lpsa, data = prostate)
summary(result_stepwise)

# The best model stepwise was worse than result model with all variables

##############################################################################
###############################AIC, BIC E AICc test###########################
##############################################################################

AIC (result)
BIC (result)

library(AICcmodavg)

# AICc used for small samples
AICc (result)


library(performance)
model_performance(result)
model_performance(result_stepwise)

confint(result)
confint(result_stepwise)
