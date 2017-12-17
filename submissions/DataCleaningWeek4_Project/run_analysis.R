# Download data from web
getDownloadedFile <- function(){
     setwd("~/R/Coursera/submissions/DataCleaningWeek4_Project/")
     
     # Download and unzip the .zip file
     fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     filename <- "downloaded_dataset.zip"
     download.file(url = fileUrl, destfile = filename)
     if (!file.exists("UCI HAR Dataset")) { 
          unzip(filename) 
     }
     
     file_path <- file.path(getwd(), "UCI HAR Dataset")
     files<-list.files(file_path, recursive=TRUE)
     files
}

# merge the two datasets: train and test; and save the mean results to a file.
mergingDataFiles <- function(){
     getDownloadedFile()
     # The files that will be used to load data are listed as follows:
     # - test/subject_test.txt
     # - test/X_test.txt
     # - test/y_test.txt
     # - train/subject_train.txt
     # - train/X_train.txt
     # - train/y_train.txt
     
     
     # load activity labels and feature
     activityLabels <- read.table(file = "UCI HAR Dataset/activity_labels.txt")
     activityLabels[,2] <- as.character(x = activityLabels[,2])
     activityLabels[,2]
     
     features <- read.table(file = "UCI HAR Dataset/features.txt")
     features[,2] <- as.character(x = features[,2])
     features[,2]

     #####STEP 2: EXCTRACT ONLY MEASUREMENTS ON THE MEAN AND STD DEVIATION.
     featureStats <- grep(pattern = ".*mean.*|.*std.*", x = features[,2], value = TRUE)
     # featureStats.names <- features[featureStats,2]
     featureStats <- gsub(pattern = "-mean", replacement = "Mean", x = featureStats)
     featureStats <- gsub(pattern = "-std", replacement = "Std", x = featureStats)
     featureStats <- gsub(pattern = "[-()]", replacement = "", x = featureStats)
     
     getFeatureMeanStdRows <- grep(pattern = ".*mean.*|.*std.*", x = features[,2])
     # retrieve data for train data
     train <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
     
     trainStats <- train[getFeatureMeanStdRows]
     trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
     trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
     trainStats <- cbind(trainSubjects, trainActivities, trainStats)
     
     # retrieve data for test data
     test <- read.table("UCI HAR Dataset/test/X_test.txt")
     
     testStats <- test[getFeatureMeanStdRows]
     testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
     testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
     testStats <- cbind(testSubjects, testActivities, testStats)
     
     #####STEP 1: MERGE TRAIN AND TEST DATASETS VERTICALLY
     completeData <- rbind(trainStats, testStats)
     
     ####STEP 3 AND 4: ADD LABELS TO THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES 
     colnames(x = completeData) <- c("subject", "activity_type", featureStats)

     # turn activities and features into factors
     completeData$activity_type <- factor(x = completeData$activity_type, levels = activityLabels[,1],labels = activityLabels[,2])
     completeData$subject <- as.factor(x = completeData$subject)
     
     library(reshape2)
     
     ####STEP 5: CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVG. OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
     completeData.melted <- melt(completeData, id = c("subject", "activity_type"))
     completeData.mean <- dcast(completeData.melted, subject + activity_type ~ variable, mean)

     write.table(completeData.mean, "tidy_dataset_mean.txt", row.names = FALSE, quote = FALSE)
}