## Q1
url1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url1,destfile = "housing.csv")
idaho_df <-read.csv("housing.csv")
## Checking for var. names, class, etc.
str(idaho_df)
split_names <- strsplit(names(idaho_df),"wgtp")
## Looking for 123th value pair in new var
split_names[123]

## Q2
library(data.table)
url2 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url2, destfile = "gdp.csv")
gdp_DF <-fread("gdp.csv", skip = 5, nrows = 190, select = c(1,2,4,5), col.names = c("CountryCode","Rank","Economy","GDP"))
str(gdp_DF)
gdp <- as.integer(gsub(",","",gdp_DF$`US dollars)`))
mean(gdp,na.rm = TRUE)

## Q3
## Two names, Côte d’Ivoire and São Tomé and Príncipe will throw warning but 
## can be disregarded 
grep("^United",gdp_DF$Economy)

## Q4
url3 <- ("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
download.file(url3, destfile = "edu_data.csv", mode = "wb")
edu_df <- fread("edu_data.csv")
edu_gdp_DF <- merge(edu_df,gdp_DF, by = "CountryCode")
## Extra space after ":" needs to be added in order to find exact match
Fiscalyear_June <- grep("Fiscal year end: June",edu_gdp_DF$`Special Notes`)
NROW(Fiscalyear_June)

## Q5
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
values_2012 <- sampleTimes[grep("^2012",sampleTimes)]
mondays <- values_2012[weekdays(values_2012)=="Monday"]
NROW(mondays)
