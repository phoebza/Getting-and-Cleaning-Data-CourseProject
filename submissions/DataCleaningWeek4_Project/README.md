# Getting and Cleaning Data - Course Project

This is the `week 4` course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset (`zip file`) (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
2. Unzip the file to the directory; first check if it exists
3. Load the activity and feature info
4. Loads both the training and test datasets. Only keep the columns that reflect a mean or standard        deviation
5. Loads the activity and subject data for each dataset, and merges those columns with the dataset
6. Merges the two datasets
7. Add labels to the data set with descriptive variable names
8. Converts the `activity_type` and `subject` columns into factors
9. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The end result is shown in the file `tidy_dataset_mean.txt`.
