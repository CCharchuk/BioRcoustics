#Basics to R.
#How to import your data from GitHub
#Learning how to write functions and loops.
library(RCurl)

url <- "https://raw.githubusercontent.com/CCharchuk/BioRcoustics/master/Count_All_Birds_Each_Station_Crosstab.csv"
sitespp <- getURL(url)
sitespp <- read.csv(textConnection(sitespp))
