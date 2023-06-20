##################################################################
# 1. Get and unzip data. Load packages needed for analysis
##################################################################

unzip("getdata_projectfiles_UCI HAR Dataset.zip",exdir = getwd())
my_packages <- c("dplyr","data.table","Hmisc")
lapply(my_packages,require,character.only=TRUE)

##################################################################
# 2. Read the test and training data
##################################################################

pathto_file <- "./UCI HAR Dataset"
test_subjects <- read.table(file.path(pathto_file,"test","subject_test.txt"), header = FALSE, sep = " ")
test_results <- read.table(file.path(pathto_file,"test","X_test.txt"), header = FALSE, sep = " ", fill = TRUE)
test_activities <- read.table(file.path(pathto_file,"test","y_test.txt"), header = FALSE, sep = " ")
