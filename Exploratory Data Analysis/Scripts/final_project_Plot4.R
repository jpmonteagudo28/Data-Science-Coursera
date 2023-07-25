################################################################
## Downloading Data.
################################################################

url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url1, destfile = "./exdata_data_NEI_data.zip")
unzip("exdata_data_NEI_data.zip", exdir = getwd())
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#----------Additional file not needed for project-----------#
house_const <- read.csv("under_cust_1.csv", header = FALSE)

################################################################
## Manipulating the data (EDA)
################################################################

using("gmp", "dplyr", "ggplot2")
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
# Loading Coal Emission data
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

## Finding all categories in SCC containing "coal" in description
coal_codes <- grepl("Coal", SCC$Short.Name)
NCC_coal <- SCC$SCC[coal_codes]
## Subsetting NEI df to show data for coal emissions only.
NEicoal_emi <- subset(NEI, SCC %in% NCC_coal)

# Visualizing Emissions var v. year in frequency table for Coal emissions
Coal_table <- table(NEicoal_emi$Emissions_factor, NEicoal_emi$type, NEicoal_emi$year)
print(Coal_table)

# , ,  = 1999


#               NONPOINT POINT
# [0,1e+03]         6468  3318
# (1e+03,1e+04]        1   147
# (1e+04,5e+04]        0     3
# (5e+04,9e+04]        0     0

# , ,  = 2002


#               NONPOINT POINT
# [0,1e+03]         9350  3125
# (1e+03,1e+04]        4   133
# (1e+04,5e+04]        0     1
# (5e+04,9e+04]        0     0

# , ,  = 2005


#               NONPOINT POINT
# [0,1e+03]         9350  3196
# (1e+03,1e+04]        4   136
# (1e+04,5e+04]        0     3
# (5e+04,9e+04]        0     0

# , ,  = 2008


#               NONPOINT POINT
# [0,1e+03]         9567  7842
# (1e+03,1e+04]        0    63
# (1e+04,5e+04]        0     0
# (5e+04,9e+04]        0     0

###########################################################
## Plot of Coals emission from 1999 - 2008 from all sources
###########################################################

year_col <- c("2008" = "forestgreen", "2005" = "coral", "2002" = "dodgerblue4", "1999" = "firebrick2")
NEicoal_emi$year <- as.factor(NEicoal_emi$year)
ggplot(data = NEicoal_emi, aes(x = year, y = Emissions, fill = year)) +
  geom_col() +
  facet_wrap(~type) +
  geom_smooth() +
  scale_fill_manual(values = year_col)
dev.copy(png, "final_project_Plot4.png", width = 480, height = 480)
dev.off()

## Notice large increase in coal emissions of non-point sources during the early
## 2000's. According to the EPA, non-point sources include residential heating,
## charcoal grilling, asphalt paving, and commercial and consumer solvent use.


###########################################################
## . Plot of Housing Units built during 1999 - 2008
###########################################################
house_const <- house_const[-c(1:7, 8, 9), ]
cnames <- c("year", "total_units", "1 unit", "2-4 units", "5 units or more", "Northeast", "NE 1 unit", "Midwest", "MW 1 unit", "South", "South 1 unit", "West", "West 1 unit")
colnames(house_const) <- cnames
year_set <- c("1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008")
year_subset <- subset(house_const, year %in% year_set)
house_const$year <- as.factor(house_const$year)
year_subset$total_units <- as.numeric(gsub(",", "", year_subset$total_units))
year_subset$total_units <- order(as.numeric(year_subset$total_units))
year_col2 <- c("2008" = "forestgreen", "2007" = "brown3", "2006" = "darkslateblue", "2005" = "coral", "2004" = "darkolivegreen", "2003" = "indianred", "2002" = "dodgerblue4", "2001" = "orangered", "2000" = "tomato", "1999" = "firebrick2")
ggplot(data = year_subset, aes(x = year, y = total_units, col = year)) +
  geom_point(shape = 15, size = 4) +
  geom_line(aes(group = 1), linewidth = 1) +
  scale_color_manual(values = year_col2)


##############################################################
## Plot comparing No. Housing units built with coal emissions
## during 1999 - 2008
##############################################################

ggplot(data = year_subset, aes(x = year, y = total_units, col = year)) +
  +geom_point(shape = 15, size = 4) +
  +geom_line(
    data = subset(NEicoal_emi, type == "NONPOINT"),
    +aes(x = year, y = Emissions), col = "royalblue"
  ) +
  +geom_line(aes(group = 1), linewidth = 1) +
  +scale_color_manual(values = year_col2)
dev.copy(png, "final_project_ExtraPlot.png", width = 480, height = 480)
dev.off()

## The increase in total owned home units from 1999 - 2005 is positively correlated
## to a randomly selected subset of coal emission data from 1999 - 2005

cor(NEicoal_emi$Emissions[c(2, 34, 4667, 6979, 16489, 36780, 965, 3481, 31156, 43790)], year_subset$total_units)
# [1] 0.2805122
