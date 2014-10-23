GetAndCleanDataCourse
=====================

Getting and Cleaning Data Course Project

Please note that details about the data used and created are provided in [CodeBook.md](CodeBook.md)

# Setup

1. Set your working directory<br>
   I'm fine with: ```setwd("~/coursera/getting_data/course_project")```
2. Download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
   and unzip it in your working directory (resulting in a 'UCI HAR Dataset' subdirectory)<br>
   Please note that a full description is available here:
   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Running the script

1. Load 'run_analysis.R' into R - if it's stored within the working directory, type ```source("run_analysis.R")```<br>Please note that the package 'reshape2' will be
   installed immediately if it is not found on your computer
2. Type ```df <- compute_averages()``` to call the main function.
    + Several files of the 'UCI HAR Dataset' are merged and processed resulting in a tidy data
      set 1 which is written as 'tidy_data.csv' into the working directory
    + An aggregated tidy data set 2 with the average of each variable for each activity
      and each subject is created using tidy data set 1 and written as 'result_data.txt'
      into the working directory

