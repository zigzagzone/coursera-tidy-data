#install.package("dplyr")
library(dplyr)
#install.package("downloader")
library(downloader)

makeTidyData <- function () {
  
  ## Download data file
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  directoryName <- "./"
  fileName <- "dataset.zip"
  fileLocationToStore <- file.path(directoryName, fileName)
  if (!file.exists(fileLocationToStore)) {
    download(url, dest=fileName, mode="wb") 
    unzip (fileName, exdir = directoryName)
  }
  
  ## 1. Merges the training and the test sets to create one data set.
  ## read all data from test files
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  data_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  label_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  
  ## read all data from train files
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  data_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  label_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  
  ## use rbind to combined the data between test and train
  combined_subject <- rbind(subject_test, subject_train)
  combined_label <- rbind(label_test, label_train)
  combined_data <- rbind(data_test, data_train)
  
  ## use cbind to combind all data to create DF
  df <- cbind(combined_subject, combined_label, combined_data)
  
  ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  ## read features from file
  features <- read.table("./UCI HAR Dataset/features.txt")
  ## search for row contain only string '-mean()' and '-std()'
  filterdFeatures <- features[grep('-(mean|std)\\(\\)', features[,2]), 2]
  df <- df[, c(1,2,filterdFeatures)]
  
  #3. Uses descriptive activity names to name the activities in the data set
  ## read activities from file
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
  ## Get factor from activity_labels
  filterdActivities <- activity_labels[df[, 2], 2]
  df[, 2] <- filterdActivities
  
  #4. Appropriately labels the data set with descriptive variable names.
  ## rename column
  names(df) <- c("subject", "activity", as.character(filterdFeatures))
  
  #5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  df <- df %>%
    group_by(subject, activity) %>%
    summarise_all(mean, na.rm=TRUE)
  write.table(df, file = "tidy_data.txt", row.name=FALSE)
}

