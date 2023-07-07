## Introduction

This assignment uses data from
the <a href="http://archive.ics.uci.edu/ml/">UC Irvine Machine
Learning Repository</a>, a popular repository for machine learning
datasets. In particular, I will be using the "Individual household
electric power consumption Data Set" which is available on
the course web site:


* <b>Dataset</b>: <a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip">Electric power consumption</a> [20Mb]

* <b>Description</b>: Measurements of electric power consumption in
one household with a one-minute sampling rate over a period of almost
4 years. Different electrical quantities and some sub-metering values
are available.


The following descriptions of the 9 variables in the dataset are taken
from
the <a href="https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption">UCI
web site</a>:

<ol>
<li><b>Date</b>: Date in format dd/mm/yyyy </li>
<li><b>Time</b>: time in format hh:mm:ss </li>
<li><b>Global_active_power</b>: household global minute-averaged active power (in kilowatt) </li>
<li><b>Global_reactive_power</b>: household global minute-averaged reactive power (in kilowatt) </li>
<li><b>Voltage</b>: minute-averaged voltage (in volt) </li>
<li><b>Global_intensity</b>: household global minute-averaged current intensity (in ampere) </li>
<li><b>Sub_metering_1</b>: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). </li>
<li><b>Sub_metering_2</b>: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. </li>
<li><b>Sub_metering_3</b>: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.</li>
</ol>

### Loading the data (in the `Scripts` folder)  

The `Scripts` folder contains five script files related to the EDA class Project #1. Before you run the scripts, **RUN THE `missing_package` FUNCTION**. If you don't run the `missing_package` function, you will not be able to load the data and transform the `Date` and `Time` variables. 

Secondly, the `memory` function will simply provide an estimate of how much space the dataset will occupy in RAM. You do not have to run the code for it, but it you do, it will ask you to input the `rows` and `columns`and yield a character vector of length 1 with the size of the dataset in GB. 

Also note that, depending on your OS, the `Date` and `Times` variables may be displayed in an *unambiguous format*. I own a Windows computer so I had to transform my data in a roundabout way. These transformations may not yield the appropriate results for you when you run the code. Therefore, you will want to use your own working code to load the `Date`and `Time` variables in the appropriate format (`POSIXct`. However, the following piece of code has worked for other people, and you may be able to use it.   

```{r eval=FALSE}
dataFile <- "your_household_electric_consumption_file_here.txt"
data <- read.table(dataFile, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
subSetData <- data[data$Date %in% c("1/2/2007","2/2/2007") ,]
datetime <- strptime(paste(subSetData$Date, subSetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
```



### The Plots (in the `Plots` folder)  


This folder contains four plots:  

1. `Plot1.png`: contains a histogram for Global Active Power in February 2007.  
2. `Plot2.png`: contains a line graph for Global Active Power during two-day period in February 2007.  
3. `Plot3.png`: contains a line graph for Energy Sub-metering during two-day period in February 2007.  
4. `Plot4.png`: contains multiple plots for House Electric Power during two-day period in February 2007.  


### Questions?

Feel free to reach out/connect at jpmonteagudo2014@gmail.com




