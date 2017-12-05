#Basics to R.
#How to import your data from GitHub
#Learning how to write functions and loops.
#Reading data from website:
library(RCurl)

url <- "https://raw.githubusercontent.com/CCharchuk/BioRcoustics/master/sitesppdata.csv"
sitespp <- getURL(url)
sitespp <- read.csv(textConnection(sitespp))
#Reading data straight from your computer
sitespp <- read.csv("sitesppdata.csv")

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


