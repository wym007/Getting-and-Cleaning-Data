##Getting and Cleaning Data Course Project 
##The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
##The goal is to prepare tidy data that can be used for later analysis. 
##You will be graded by your peers on a series of yes/no questions related to the project. 
##You will be required to submit: 
##1) a tidy data set as described below, 
##2) a link to a Github repository with your script for performing the analysis, and 
##3) a code book that describes the variables, the data, and any transformations or work that you performed 
##to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. 
##This repo explains how all of the scripts work and how they are connected. 
##One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
##Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
##http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##Here are the data for the project:
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##You should create one R script called run_analysis.R that does the following. 
##1) Merges the training and the test sets to create one data set.
##2) Extracts only the measurements on the mean and standard deviation for each measurement. 
##3) Uses descriptive activity names to name the activities in the data set
#34) Appropriately labels the data set with descriptive variable names. 
##5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Step 0: download dataset into working directory with subdirectory as "UCI HAR Dataset"
## its corresponding subdirectories

## Step 1: Merge the training and test sets to create one data set

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_data <- rbind(x_train, x_test) ## create 'x' data set
y_data <- rbind(y_train, y_test) ## create 'y' data set
subject_data <- rbind(subject_train, subject_test) ## create 'subject' data set


## Step 2: Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt")

## get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2]) 

x_data <- x_data[, mean_and_std_features] ## subset the desired columns
names(x_data) <- features[mean_and_std_features, 2] ## correct the column names


## Step 3: Use descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

## update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

names(y_data) <- "activity" ## correct column name


## Step 4: Appropriately label the data set with descriptive variable names

names(subject_data) <- "subject" ## correct column name

all_data <- cbind(x_data, y_data, subject_data) ## bind all the data in a single data set

## Step 5: Create a second, independent tidy data set with the average of each variable
## for each activity and each subject

## 66 <- 68 columns but last two (activity & subject)
library(plyr)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)