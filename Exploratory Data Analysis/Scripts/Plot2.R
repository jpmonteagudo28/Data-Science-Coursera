####################################################################
## B. Getting Data
####################################################################

using("dplyr", "data.table", "lubridate")

url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url1, destfile = "./Electric Power Consumption.zip")
unzip("Electric Power Consumption.zip", exdir = getwd())
pathto_file <- getwd()
housepw_consume <- read.table(file.path(pathto_file, "household_power_consumption.txt"), header = TRUE, sep = ";")
feb_housepw_consume <- subset(housepw_consume, housepw_consume$Date == c("1/2/2007", "2/2/2007"))

glimpse(feb_housepw_consume)
summary(feb_housepw_consume)
head(feb_housepw_consume, 30)
tail(feb_housepw_consume, 30)
missing <- sum(is.na(feb_housepw_consume))
print(missing)

####################################################################
## C. Transforming the Data
####################################################################

## Changing Object type (Date and Time)
feb_housepw_consume$Date <- dmy(feb_housepw_consume$Date)
feb_housepw_consume$Date_Time <- paste(feb_housepw_consume$Date, feb_housepw_consume$Time, sep = " ")
feb_housepw_consume$Date_Time <- ymd_hms(feb_housepw_consume$Date_Time, tz = "UTC")
feb_housepw_consume <- feb_housepw_consume[, -c(1:2)]

## (Changing Object Type for all columns)
feb_housepw_consume <- feb_housepw_consume %>% mutate(across(-Date_Time, as.numeric))
glimpse(feb_housepw_consume)
rm(housepw_consume)
###################################################################
## D. Plot of Global Active Power during two-day period in Feb. 07
###################################################################

plot(feb_housepw_consume$Date_Time, feb_housepw_consume$Global_active_power,
  pch = 20, type = "b", lty = 2, lwd = 2, col = "darkblue",
  main = "Global Active Power during Two-Day Period in February",
  xlab = "Days", ylab = "Global Active Power(kilowatts)"
)
dev.copy(png, "Plot2.png", width = 480, height = 480)
dev.off()
