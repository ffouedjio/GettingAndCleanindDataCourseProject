###########################################################################################################
#                                                                                                         #
#                                 Getting and Cleaning Data Course Project                                #
#                                                                                                         #
###########################################################################################################

### Loading Necessary Packages ###
library(plyr)

## Checking and Creating Directory
if(!file.exists("Getting and Cleaning Data Course Project")){dir.create("Getting and Cleaning Data Course Project")}

## Getting and Loading Data from the Internet ##
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile ="~/Getting and Cleaning Data Course Project/dataset.zip")
unzip("~/Getting and Cleaning Data Course Project/dataset.zip")
list.files("~/Getting and Cleaning Data Course Project/")
list.files(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), recursive=TRUE)

subject_train <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "train", "subject_train.txt"),header=FALSE)
subject_test  <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "test" , "subject_test.txt" ),header=FALSE)

X_train <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "train", "X_train.txt"),header=FALSE)
X_test  <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "test" , "X_test.txt" ),header=FALSE)

Y_train <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "train", "Y_train.txt"),header=FALSE)
Y_test  <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "test" , "Y_test.txt" ),header=FALSE)

### 1. Merging Training and Test sets ###
subject <- rbind(subject_train, subject_test) #create subject train + test data
activity <- rbind(Y_train, Y_test)            #create Y train + test data
data <- rbind(X_train, X_test)                #create X train + test data


### 2. Extracting only the measurements on the mean and standard deviation for each measurement ###
features <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "features.txt"),header=FALSE)
featuresIndex <- grep("-(mean|std)\\(\\)", features[, 2])  # only columns with mean() or std() in their names
data <- data[, featuresIndex]                              # subset the desired columns
names(data) <- features[featuresIndex, 2]                  # correct the column names

### 3. Using descriptive activity names ###
activities <- read.table(file.path(file.path("~/Getting and Cleaning Data Course Project/", "UCI HAR Dataset"), "activity_labels.txt"),header=FALSE)
activity[, 1] <- activities[activity[, 1], 2]            # update values with correct activity names
names(activity) <- "activity"                            #column name activity


###4. Appropriately label the data set with descriptive variable names ###
names(subject) <- "subject"
wholedata <- cbind(data, activity, subject)    #create subject, X, Y train + test data

### 5. Creating a tidy data set ###
averages_data <- ddply(wholedata, .(subject, activity), function(x) colMeans(x[, 1:66]))  #The last two variables are activity and subject
write.table(averages_data, "~/Getting and Cleaning Data Course Project/averages_data.txt", row.name=FALSE)
