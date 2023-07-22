## Downloading Data.
################################################################

url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url1, destfile = "./exdata_data_NEI_data.zip")
unzip("exdata_data_NEI_data.zip", exdir = getwd())
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

################################################################
## Manipulating the data (EDA)
################################################################

using("gmp", "dplyr")
str(NEI)
summary(NEI) # max: 646952 tons?
head(NEI, 30)
tail(NEI, 30)
missing_NEI <- sum(is.na(NEI)) # 0 missing
range(NEI$Emissions, na.rm = T) # [0,646952]
NEI$Emissions <- as.bigz(NEI$Emissions)
head(NEI$Emissions, 30)
tail(NEI$Emissions, 30)
summary(SCC)
str(SCC)

nonzero_emissions <- subset(NEI, Emissions != 0)
avg_emissions <- mean(nonzero_emissions$Emissions) ## 38.76 tons, #76109 value pairs greater than 38 tons
range(nonzero_emissions$Emissions) # [1,646951]
all_outliers <- which(NEI$Emissions >= 9e+4)
print(all_outliers)

#####################################################
# Loading Baltimore data
#####################################################

NEI <- NEI[-c(1175315, 1259402), ]

# Visualizing Emissions var v. year in frequency table for Baltimore, MA
NEI$Emissions_factor <- cut(NEI$Emissions,
                            breaks = c(0, 1000, 10000, 50000, 90000),
                            lables = c("0 - 1000", "1001 - 10000", "10001 - 50000", "50001 - 90000"),
                            include.lowest = TRUE)

Balt_emission <- subset(NEI,fips == "24510")
head(Balt_emission,7)
tail(Balt_emission,7)

Balt_table <- table(Balt_emission$Emissions_factor,Balt_emission$year)
print(Balt_table)

#               1999 2002 2005 2008
# [0,1e+03]      319  535  542  699
# (1e+03,1e+04]    1    0    0    0
# (1e+04,5e+04]    0    0    0    0
# (5e+04,9e+04]    0    0    0    0

mean(Balt_emission$Emissions) # 4.890744 0 value pairs pull mean down.
# What's non-zero mean for Baltimore, MA?
mean(Balt_emission$Emissions !=0) # 0.2361641 or 24% non-zero values
mean(Balt_emission$Emissions[Balt_emission$Emissions != 0]) # 20.70909
range(Balt_emission$Emissions) [0,1043]
mean(Balt_emission$Emissions >= 20.7) # 0.04198473 o 4.2% values above mean. 


###################################################
## Plot of Baltimore emission from 1999 - 2008
###################################################

year_col <- c("2008" = "wheat", "2005" = "coral", "2002" = "brown1", "1999" = "firebrick2")
plot(Balt_emission$year, Balt_emission$Emissions, pch = 19, col = year_col[as.character(Balt_emission$year)], ylim = c(0, 500))
model <- lm(Emissions ~ year, Balt_emission)
abline(model, col = "gray0", lwd = 2) ## Negative relationship. Avg. emissions across U.S decrease as time progresses
dev.copy(png,"final_project_Plot2.png",width=480,height=480)
dev.off()
