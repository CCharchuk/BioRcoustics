#Basics to R.
#How to import your data from GitHub
#Learning how to write functions and loops.
library(RCurl)

url <- "https://raw.githubusercontent.com/CCharchuk/BioRcoustics/master/sitesppdata.csv"
sitespp <- getURL(url)
sitespp <- read.csv(textConnection(sitespp))

sites <- as.factor(sitespp$SITE)
stations <- sitespp$STATION
richness <- sitespp$Total.Of.MaxOfINDIV_ID
surveyyear <- sitespp$Year
#Things work faster as a matrix 
sitespp <- as.matrix(sitespp[,5:57])
spp <- colnames(sitespp)
#simple anova testing for richenss differences between stations (treatments)
rawrich <- lm(richness~stations)
rawrichcoef <- coef(rawrich)
save(rawrichcoef, file="rawrichcoef.rda")
