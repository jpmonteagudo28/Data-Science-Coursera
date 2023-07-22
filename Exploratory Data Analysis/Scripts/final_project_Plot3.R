################################################################
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

using("gmp", "dplyr","ggplot2")
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

Balt_table <- table(Balt_emission$Emissions_factor,Balt_emission$type,Balt_emission$year)
print(Balt_table)

# , ,  = 1999


#                 NON-ROAD NONPOINT ON-ROAD POINT
# [0,1e+03]           90       24     192    13
# (1e+03,1e+04]        0        1       0     0
# (1e+04,5e+04]        0        0       0     0
# (5e+04,9e+04]        0        0       0     0

# , ,  = 2002


#                 NON-ROAD NONPOINT ON-ROAD POINT
# [0,1e+03]          111       36     321    67
# (1e+03,1e+04]        0        0       0     0
# (1e+04,5e+04]        0        0       0     0
# (5e+04,9e+04]        0        0       0     0

# , ,  = 2005


#                 NON-ROAD NONPOINT ON-ROAD POINT
# [0,1e+03]          111       36     324    71
# (1e+03,1e+04]        0        0       0     0
# (1e+04,5e+04]        0        0       0     0
# (5e+04,9e+04]        0        0       0     0

# , ,  = 2008


#                 NON-ROAD NONPOINT ON-ROAD POINT
# [0,1e+03]          104       45     282   268
# (1e+03,1e+04]        0        0       0     0
# (1e+04,5e+04]        0        0       0     0
# (5e+04,9e+04]        0        0       0     0

#########################################################
## Plot of Baltimore emission from 1999 - 2008 by source
#########################################################

year_col <- c("2008" = "forestgreen", "2005" = "coral", "2002" = "dodgerblue4", "1999" = "firebrick2")
Balt_emission$year <- as.factor(Balt_emission$year)
ggplot(data = Balt_emission,aes(x = year,y = Emissions, col = year))+ geom_point() +facet_wrap(~type) +geom_smooth() + scale_color_manual(values = year_col)
dev.copy(png,"final_project_Plot3.png",width=480,height=480)
dev.off()

