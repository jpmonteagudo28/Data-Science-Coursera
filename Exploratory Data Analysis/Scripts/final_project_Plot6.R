################################################################
## Downloading Data.
################################################################

url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url1, destfile = "./exdata_data_NEI_data.zip")
unzip("exdata_data_NEI_data.zip", exdir = getwd())
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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
## Loading Baltimore, MA and LA, CA motor vehicle data
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

#                1999 2002 2005 2008 RoC(2002)  RoC(2005)   RoC(2008)
# [0,1e+03]      192  321  324  282     +67%         0%         -29%
# (1e+03,1e+04]    0    0    0    0
# (1e+04,5e+04]    0    0    0    0
# (5e+04,9e+04]    0    0    0    0

LACmotor_emi <- filter(NEI, type == "ON-ROAD" & fips == "06037")
range(LACmotor_emi$Emissions) # [3.170501e-04,1.643850e+03]

LACmotor_table <- table(LACmotor_emi$Emissions_factor, LACmotor_emi$year)
print(LACmotor_table)

#                1999 2002 2005 2008  RoC(2002)  RoC(2005)   RoC(2008)
# [0,1e+03]      144  396  396   41     +175%          0%        -90% 
# (1e+03,1e+04]    0    0    0    1
# (1e+04,5e+04]    0    0    0    0
# (5e+04,9e+04]    0    0    0    0

## It is obvious that the more drastic negative change over time is seen in
## LA, CA from 1999 to 2002 (+175%) and the more drastic positive change is in 
## 2005 to 2008. There's a 90% reduction in motor vehicle emissions.

##--------Calculating Rate of Change for Ma and CA----------##

Rochan <- function(num1,num2){ # num1 = first data point
                                # num2 = subseq. data point
  rate <- ((abs(num2 -num1))/num1)*100
    return(rate)
}

## * Look at freq. tables for MAmotor and LACmotor to find RoC

#######################################################
## Plot comparing MV emissions in MA and CA 1999 - 2008
#######################################################
MAmotor_emi$year <- as.factor(MAmotor_emi$year)
plot1 <-ggplot()+
  geom_col(data=MAmotor_emi, aes(x = year, y = Emissions, col = year), width = .5)+
  scale_color_manual(values = year_col)+
  labs(title = "Baltimore, MA MV Emissions")
LACmotor_emi$year <- as.factor(LACmotor_emi$year)
year_col4 <- c("2008" = "dodgerblue", "2005" = "orangered", "2002" = "darkgreen", "1999" = "gold")
plot2 <- ggplot()+
  geom_col(data = LACmotor_emi, aes(x = year, y = Emissions, col = year), width = .5)+
  scale_color_manual(values = year_col4)+
  labs(title = "LA,CA MV Emissions")
grid.arrange(plot1, plot2, ncol =2)
dev.copy(png, "final_project_Plot6.png", width = 480, height = 480)
dev.off()
