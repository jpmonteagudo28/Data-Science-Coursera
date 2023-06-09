##################################################################
# Get and unzip data. Load packages needed for analysis
##################################################################
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url1,destfile = "./UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip",exdir = getwd())
my_packages <- c("dplyr","data.table")
lapply(my_packages,require,character.only=TRUE)

##################################################################
# Read the test and train data & label variables
##################################################################

pathto_file <- "./UCI HAR Dataset"
test_subjects <- read.table(file.path(pathto_file,"test","subject_test.txt"), header = FALSE, sep = " ")

## if you're using Windows' notepad, you will get undelimited X_test.txt and X_train.txt files 
## so recommend defining " " as na.strings

test_results <- read.table(file.path(pathto_file,"test","X_test.txt"), header = FALSE, na.strings = " ")
test_activities <- read.table(file.path(pathto_file,"test","y_test.txt"), header = FALSE, sep = " ")

## Features data

features <- read.table(file.path(pathto_file,"features.txt"), header = FALSE, sep = " ")
features <-features[,2]
features <- gsub("[\\(\\)-]","",features)
features <- gsub("^t","time_",features)
features <- gsub("^f","freq_",features)
features <- gsub("BodyBody","body",features)
features <- gsub("Mag","magnitude",features)
features <- gsub("Acc","_Accelerometer_",features)
features <- gsub("Gyro", "_Gyroscope_",features)
features <- gsub("std","_StDev.",features)
features <- gsub("mean","_Mean.",features)
features <- gsub("anglet","angle_time_",features)


## Activities

activities <- read.table(file.path(pathto_file,"activity_labels.txt"), header = FALSE, sep = " ")
colnames(activities) <- c("ID","Label")

## Train data

training_subjects <-read.table(file.path(pathto_file,"train","subject_train.txt"), header = FALSE, sep = " ")
training_results <- read.table(file.path(pathto_file,"train","X_train.txt"), header = FALSE, na.strings = " ")
training_activities <- read.table(file.path(pathto_file,"train","y_train.txt"), header = FALSE, sep = " ")


####################################################################
# Combine data sets & extract mean & SD measurements
####################################################################

test_data <-cbind(test_subjects,test_activities,test_results)
colnames(test_data) <- c("subject", "activities",features)
cols_to_keep <-grep("subject|activities|Mean.[X-Z]|StDev.[X-Z]",colnames(test_data))
test_data <- test_data[,cols_to_keep]

## Train data

train_data <- cbind(training_subjects,training_activities, training_results)
colnames(train_data) <- c("subject","activities",features)
cols_to_keep2 <-grep("subject|activities|Mean.[X-Z]|StDev.[X-Z]",colnames(train_data))
train_data <- train_data[,cols_to_keep2]

## Joining both data sets

humanAR_df <- rbind(test_data,train_data)

## Remove unnecessary data tables

rm(test_activities,test_results, test_subjects,training_activities,training_results,training_subjects)

#####################################################################
# Descriptive activity names
#####################################################################

## Making humanAR$activities into factor var. with 6 levels

humanAR_df$activities <- factor(humanAR_df$activities, levels = activities[,1], labels = activities[,2])

#####################################################################
# Create an independently tidy data set with variable avg.
#####################################################################

humanAR_df <- humanAR_df %>% group_by(subject,activities) %>% summarize_each(mean)

## Both, .csv and .txt data tables are created. Separator in .txt file = "|" will 
## have to be converted to na.strings when reading the file.
write.table(humanAR_df,"tidy_data.csv", sep = ",", row.names = FALSE, quote = FALSE)

write.table(humanAR_df, "tidy_data.txt", sep = "|", row.names = FALSE, quote = FALSE)
