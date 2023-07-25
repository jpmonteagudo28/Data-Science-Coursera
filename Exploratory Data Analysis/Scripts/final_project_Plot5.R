################################################################
## Downloading Data.
################################################################

url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url1, destfile = "./exdata_data_NEI_data.zip")
unzip("exdata_data_NEI_data.zip", exdir = getwd())
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#----------Additional file not needed for project-----------#
mamot <- read.csv("MA_MOT.csv", header = T)
colnames(mamot) <- c("Year", "Annual_miles")
######################################################
## Manipulating the data (EDA)
######################################################

using("gmp", "dplyr", "ggplot2", "gridExtra")
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
# Loading Baltimore, MA motor vehicle data
#####################################################

NEI <- NEI[-c(1175315, 1259402), ]

# Creating Emissions_factor var to visualize coal emissions
NEI$Emissions_factor <- cut(NEI$Emissions,
  breaks = c(0, 1000, 10000, 50000, 90000),
  lables = c("0 - 1000", "1001 - 10000", "10001 - 50000", "50001 - 90000"),
  include.lowest = TRUE
)

#------- Creating State variable to add to NEI df.--------# 
NEI$State <- substr(NEI$fips, 1, 2)

## Finding Baltimore motor vehicle subset
MAmotor_emi <- filter(NEI, type == "ON-ROAD" & fips == "24510")
range(MAmotor_emi$Emissions) # [1] 4.421016e-07 4.643000e+01

MAmotor_table <- table(MAmotor_emi$Emissions_factor, MAmotor_emi$year)
print(MAmotor_table)

#                1999 2002 2005 2008
# [0,1e+03]      192  321  324  282
# (1e+03,1e+04]    0    0    0    0
# (1e+04,5e+04]    0    0    0    0
# (5e+04,9e+04]    0    0    0    0


######################################################
## Plot of motor vehicle emissions in Baltimore, MA
######################################################

year_col3 <- c("2008" = "forestgreen", "2005" = "coral", "2002" = "dodgerblue4", "1999" = "firebrick2")
MAmotor_emi$year <- as.factor(MAmotor_emi$year)
ggplot(data = MAmotor_emi, aes(x = year, y = Emissions, col = year)) +
  geom_point(shape = 15, size = 2) +
  scale_color_manual(values = year_col3)
dev.copy(png, "final_project_Plot5.png", width = 480, height = 480)
dev.off()

## Although it seems motor vehicle emissions, you can see in the frequency table
## that emissions have actually increased in Baltimore, MA during 1999 - 2008.

######################################################
## Plot comparing No. miles driven in MA and emissions
######################################################

mamot_set <- filter(mamot, Year >= 1999 & Year <= 2008)
range(mamot_set$Annual_miles) # [49075,56766]
mamot_set$Annual_miles <- (mamot_set$Annual_miles / 1000)
mamot_set$Year <- as.factor(mamot_set$Year)

plot1 <- ggplot() +
  geom_point(data = MAmotor_emi, aes(x = year, y = Emissions, col = year)) +
  geom_point(shape = 15, size = 2) +
  scale_color_manual(values = year_col3)

year_col2 <- c("2008" = "forestgreen", "2007" = "brown3", "2006" = "darkslateblue", "2005" = "coral", "2004" = "darkolivegreen", "2003" = "indianred", "2002" = "dodgerblue4", "2001" = "orangered", "2000" = "tomato", "1999" = "firebrick2")
plot2 <- ggplot() +
  geom_point(data = mamot_set, aes(x = Year, y = Annual_miles, col = Year, size = 1)) +
  scale_color_manual(values = year_col2)
grid.arrange(plot1, plot2, ncol = 2)
dev.copy(png, "final_project_ExtraPlot2.png", width = 480, height = 480)
dev.off()

cor(MAmotor_emi$Emissions[c(1, 23, 69, 86, 235, 671, 834, 915, 1005, 1118)], mamot_set$Annual_miles)
# [1] 0.283933

## As annual miles driven in Maryland increases, the amount of motor vehicles' emission
## also increases. The increase in total annual miles driven in Maryland from 1999 - 2008
## is positively correlated to a randomly selected subset of motor vehicle emission data
## from 1999 - 2008.
