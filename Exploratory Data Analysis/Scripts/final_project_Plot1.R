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

          #########################################
                # Dealing with outliers
          #########################################

outlier <- which(NEI$Emissions == 646951)
print(outlier)
NEI[1175315, ]

#          fips        SCC Pollutant Emissions     type year
# 4685317 02290 2810001000  PM25-PRI    646951 NONPOINT 2002

fips_outlier <- subset(NEI, fips == "02290")
plot(fips_outlier$fips, log10(fips_outlier$Emissions), xlim = c(2288, 2293), pch = 19, col = "orangered")
hist(fips_outlier$Emissions, ylim = c(0, 200), col = "orangered")

fips_other <- subset(NEI, fips != "02290")
boxplot(log10(fips_outlier$Emission), log10(fips_other$Emissions)) # Emissions for fips = 2290 10x larger than rest of US

nonzero_emissions <- subset(NEI, Emissions != 0)
avg_emissions <- mean(nonzero_emissions$Emissions) ## 38.76 tons, #76109 value pairs greater than 38 tons
range(nonzero_emissions$Emissions) # [1,646951]
all_outliers <- which(NEI$Emissions >= 9e+4)
print(all_outliers)

      #####################################################
        # Removing extreme outliers greater than 9e+4
      #####################################################

NEI <- NEI[-c(1175315, 1259402), ]

# Visualizing Emissions var v. year in frequency table
NEI$Emissions_factor <- cut(NEI$Emissions,
  breaks = c(0, 1000, 10000, 50000, 90000),
  lables = c("0 - 1000", "1001 - 10000", "10001 - 50000", "50001 - 90000"),
  include.lowest = TRUE
)
freq_table <- table(NEI$Emissions_factor, NEI$year)
print(freq_table)

#                 1999    2002    2005    2008
# [0,1e+03]     1107355 1698139 1713163 1976325
# (1e+03,1e+04]    1107     527     671     327
# (1e+04,5e+04]       6       8      15       3
# (5e+04,9e+04]       1       1       1       0

      ####################################################
        # Looking at emission levels by state for 1999,
        # 2002,2005,2008
      ####################################################

NEI$State <- substr(NEI$fips, 1, 2)

avg_state_emission <- NEI %>% filter(year %in% year) %>% group_by(State, year) %>%
  summarize(avg_emission = mean(Emissions))

year_col <- c("2008" = "wheat", "2005" = "coral", "2002" = "brown1", "1999" = "firebrick2")
plot(avg_state_emission$year, avg_state_emission$avg_emission, pch = 19, col = year_col[as.character(avg_state_emission$year)], ylim = c(0, 65))
model <- lm(avg_emission ~ year, avg_state_emission)
abline(model, col = "gray0", lwd = 2) ## Outliers pulling relationship in opposite direction

## Removing outliers
no_outlier_avg_emission <- subset(avg_state_emission, avg_emission <= 100)
range(no_outlier_avg_emission$avg_emission) # [0.2, 55]

        ####################################################
          # Plot total PM2.5 for 1999, 2002, 2005, and 2008
        ####################################################

plot(no_outlier_avg_emission$year, no_outlier_avg_emission$avg_emission, pch = 19, col = year_col[as.character(no_outlier_avg_emission$year)], ylim = c(0, 65))
model <- lm(avg_emission ~ year, no_outlier_avg_emission)
abline(model, col = "gray0", lwd = 2) ## Negative relationship. Avg. emissions across U.S decrease as time progresses
dev.copy(png,"final_project_Plot1.png",width=480,height=480)
dev.off()


summary(SCC)
str(SCC)
