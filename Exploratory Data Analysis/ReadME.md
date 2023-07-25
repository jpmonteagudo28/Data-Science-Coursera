## Introduction :desktop_computer:

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


## The PM2.5 Final Class Assignment  :steam_locomotive:

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximately every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the 
[EPA National Emissions Inventory website](http://www.epa.gov/ttn/chief/eiinformation.html)
.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.


* <b>Dataset</b>: <a
href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip">National Emission Inventory</a> [29Mb]

The zip file contains two files:

PM2.5 Emissions Data (
summarySCC_PM25.rds
summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains the number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

```
 fips      SCC Pollutant Emissions  type year State Emissions_factor
4  09001 10100401  PM25-PRI        15 POINT 1999    09        [0,1e+03]
8  09001 10100404  PM25-PRI       234 POINT 1999    09        [0,1e+03]
12 09001 10100501  PM25-PRI         0 POINT 1999    09        [0,1e+03]
16 09001 10200401  PM25-PRI         2 POINT 1999    09        [0,1e+03]
20 09001 10200504  PM25-PRI         0 POINT 1999    09        [0,1e+03]
24 09001 10200602  PM25-PRI         1 POINT 1999    09        [0,1e+03]
28 09001 10200603  PM25-PRI         0 POINT 1999    09        [0,1e+03]
```


### The variable descriptions

- **fips**: A five-digit number indicating the U.S county (represented as a string)   

  - the first two digits represent the state while the last three refer to the specific county.  
  
    - fips code starting with "TR" refer to Native American Tribes. You can find more information [here](https://gaftp.epa.gov/air/nei/2008/data_summaries/nei_2008_v3_tribal_tier1.xls)   
     
    
- **State**: represents the state or tribe in which the PM2.5 emissions were measured. You can find the U.S State fips code [here](https://transition.fcc.gov/oet/info/maps/census/fips/fips.txt)  


- **SCC**: the name of the source as indicated by a digit string (see [source code classification table](https://sor.epa.gov/sor_internet/registry/scc/SCC-IntroToSCCs_2021.pdf))  

  - provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source.  
  
  - The sources are categorized differently, from more general to more specific. You may choose to explore any of the categories in the source code. 
  
- **Pollutant**: a string indicating the pollutant  

- **Emissions**: the amount of PM2.5 emitted, in tons 


- **type**: the type of source  

  - point, non-point, on-road,non-road  
  
  
- **year**: the year of emissions recorded (1999, 2002, 2005, 2008)   


- **Emissions_Factor**: represents the level of PM2.5 Emissions from 0 - 1000, 1001 - 10000, 10001 - 50000, 50001 - 90000 *m<sup>3</sup>* *tons*.

```              
                   1999    2002    2005    2008
  [0,1e+03]     1107355 1698139 1713163 1976325
  (1e+03,1e+04]    1107     527     671     327
  (1e+04,5e+04]       6       8      15       3
  (5e+04,9e+04]       1       1       1       0
```
 
 

### Script files

As I mentioned earlier, the `Scripts` folder contains five script files related to the EDA class Project #1 and the final_project. Before you run the scripts, **RUN THE `missing_package` FUNCTION**. If you don't run the `missing_package` function, you will not be able to load the data and transform the datasets.

The Scripts folder also contains six additional scripts dealing with the PM2.5 data. Each script will focus on Exploratory Data Analysis(EDA), and you will end up with datasets that contain no outliers or missing values. 

  - `final_project_Plot1.R` answers the question: ***Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?***

 - `final_project_Plot2.R` answers the question: ***Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?***

 - `final_project-Plot3.R` answers the question: ***Which type of emission-generating activity has seen increases in emissions from 1999–2008 in Baltimore, MA?***

- `final_project_Plot4.R` answers the question: ***How have emissions from coal combustion-related sources changed from 1999–2008 across the U.S.?***

- `final_project_Plot5.R` answers the question: ***How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?***

- `final_project_Plot6.R` answers the question: ***Which city (Baltimore, MA or LA, CA) has seen greater changes over time in motor vehicle emissions?***

Additionally, each script will provide a frequency table that will serve as a reference to understand the resulting plot. For example: 

```{r}
Finding Baltimore motor vehicle emissions
MAmotor_emi <- filter(NEI, type == "ON-ROAD" & fips == "24510")
range(MAmotor_emi$Emissions) # [1] 4.421016e-07 4.643000e+01

MAmotor_table <- table(MAmotor_emi$Emissions_factor, MAmotor_emi$year)
print(MAmotor_table)

               1999 2002 2005 2008
 [0,1e+03]      192  321  324  282
 (1e+03,1e+04]    0    0    0    0
 (1e+04,5e+04]    0    0    0    0
 (5e+04,9e+04]    0    0    0    0
```

### The Plots folder

The plots folder is the cherry on top. By looking at all the plots in the format `final_project_Plotx.png` you will be able to better understand the data. 

`final_project_Plot1.png`: contains a scatterplot of total PM2.5 emissions in *m<sup>3</sup>* tons in the U.S from 1999 - 2008.

`final_project_Plot2.png`: contains a scatterplot of total PM2.5 emissions in *m<sup>3</sup>* tons in Baltimore, MA from 1999 - 2008

`final_project_Plot3.png`: contains four scatterplots which divide the total PM2.5 emissions in *m<sup>3</sup>* tons into four type of emission-generating activities. 

`final_project_Plot4.png`: contains a bar chart comparing Non-Point and Point sources of PM2.5 **coal** emissions

`final_project_Plot5.png`: contains a scatterplot showing the total PM2.5 emissions in *m<sup>3</sup>* tons produced by motor vehicles in Baltimore, MA. 

`final_project_Plot6.png`: contains two bar charts comparing motor vehicle emission levels in Baltimore, MA, and Los Angeles, CA from 1999 - 2008. 

`final_project_ExtraPlot.png`: contains an **OPTIONAL** plot comparing the total number of housing units being built during 1999 - 2008 and the total PM2.5 emissions in *m<sup>3</sup>* tons from Non-Point sources ( include residential heating, charcoal grilling, asphalt paving, and commercial and consumer solvent use). 

`final_project_ExtraPlot2.png`: contains an **OPTIONAL** plot comparing the total number of miles driven in Maryland from 1999 - 2008 and the total PM2.5 emissions in *m<sup>3</sup>* tons from On-Road sources (motor vehicles). 


### The Housing (und_cust) and Maryland Miles of Travel (MA_MOT) datasets

**These datasets are entirely optional and were not required in the final project. I chose to use them simply because I wanted to dig deeper and display my technical skills. You do not have to use it.**

The Housing dataset was obtained from the [U.S Census website](https://www.census.gov/construction/nrc/historical_data/index.html). You can download the dataset [here](https://www.census.gov/construction/nrc/xls/under_cust.xls)

The MA_MOT dataset was obtained from [Maryland's Open Data Portal](https://dev.socrata.com/foundry/opendata.maryland.gov/exua-btti), and you can either connect to the API to fetch the data or download an alternative .csv file. 


### Questions?

Feel free to reach out/connect at jpmonteagudo2014@gmail.com




