#####
##
## Getting & Cleaning Data (https://class.coursera.org/getdata-008) Course Project
## -------------------------------------------------------------------------------
##
## Instructions:
## -------------
##
## 1. Set your working directory 
##    I'm fine with: setwd("~/coursera/getting_data/course_project")
##
## 2. Download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##    and unzip it in your working directory (resulting in a 'UCI HAR Dataset' subdirectory)
##    Please note that a full description is available here:
##    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## 3. Load this file into R. Please note that the package 'reshape2' will be
##    installed immediately if it is not found on your computer.
##
## 4. Type 'df <- compute_averages()' to call the main function.
##    - Several files of the 'UCI HAR Dataset' are merged and processed resulting in a tidy data
##      set 1 which is written as 'tidy_data.csv' into the working directory.
##    - An aggregated tidy data set 2 with the average of each variable for each activity
##      and each subject is created using tidy data set 1 and written as 'result_data.txt'
##      into the working directory
##
#####

#
# Make sure that the reshape2 package is installed because
# the functions melt and dcast will be used.
#
if(!is.element("reshape2", installed.packages()[,1])) {
    install.packages("reshape2")
}
library(reshape2)

#
# Helper function 'tidyfy_data':
#
# Returns a tidy data frame using data given in
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# which needs to be extracted in the working directory resulting in a
# "UCI HAR Dataset" subdirectory.
#
# The 68 columns are:
#   - subject id
#   - activity label
#   - 66 std and mean variables.
# Each of the 10299 rows describes one observation.
#
tidyfy_data <- function() {
	#
	# Folders and file (name) stuff for acessing the original data:
	#
	fname_folder          <- "./UCI HAR Dataset"   # Folder relative to the working directory
                                                   # containing the original data.
    fname_separator       <- "/"                   # Directory separator (the same for Unix-like, Windows and Mac).
    params_test           <- list(name = "test", nrows = 2947)
    params_training       <- list(name = "train", nrows = 7352)

    #
    # 2947 and 7352 activity ids (values ranging from 1 to 6) are contained in
    # "./UCI HAR Dataset/test/y_test.txt" and "./UCI HAR Dataset/train/y_train.txt".
    # Each file contains only one single column.
    #
    # read_activity_ids expects as parameter
    #   params: a list with name ("test" or "train") and nrows (number of rows)
    # and returns
    #   a data frame with one column ("activity_id") containing integer values.
    #
	read_activity_ids <- function(params) {
      	read.table(
			paste(
				fname_folder, 
				params$name, 
				paste("y_", params$name, ".txt", sep = ""),
				sep = fname_separator
			),
			col.names = c("activity_id"), 
			colClasses = c("integer"),
			nrows = params$nrows 
		)
	}

	#
	# 2947 and 7352 subject ids (values ranging from 1 to 30) are contained in
	# "./UCI HAR Dataset/test/subject_test.txt" and "./UCI HAR Dataset/train/subject_train.txt".
	# Each file contains only one single column.
	#
	# read_subject_ids expects as parameter
	#   params: a list with name ("test" or "train") and nrows (number of rows)
	# and returns
	#   a data frame with one column ("subject_id") containing integer values.
	#
	read_subject_ids <- function(params) {
	    read.table(
	        paste(
	            fname_folder, 
	            params$name, 
	            paste("subject_", params$name, ".txt", sep = ""),
	            sep = fname_separator
	        ),
	        col.names = c("subject_id"), 
	        colClasses = c("integer"),
	        nrows = params$nrows 
	    )
	}
    
	#
	# 2947 and 7352 observations (time and frequency domain variables based on accelerometer
    # and gyroscope sensor signals are contained in
	# "./UCI HAR Dataset/test/X_test.txt" and "./UCI HAR Dataset/train/X_train.txt".
	# Each file contains 561 columns, i.e. variables.
	#
	# read_matrix expects as parameter
	#   name: "test" or "train"
	# and returns
	#   a matrix with 561 columns containing numeric values.
	#
	read_matrix <- function(name) {
	    #
	    # full_name is either
	    #   "./UCI HAR Dataset/test/X_test.txt"
	    # or
	    #   "./UCI HAR Dataset/train/X_train.txt"
	    #
	    full_name=paste(
	        fname_folder, 
	        name, 
	        paste("X_", name, ".txt", sep = ""),
	        sep = fname_separator
	    );
        
        #
        # Return the matrix found in the file given by full_name
        #
	    matrix(
	        scan(full_name),
	        ncol=561,
	        byrow=TRUE
	    )
	}
    
    #
    # 1. Read 6 lines mapping activity ids 1-6 to a label each from
    #    "./UCI HAR Dataset/activity_labels.txt"
    #
	activities_df <- read.table(
		paste(fname_folder, "activity_labels.txt", sep = fname_separator),
		sep = " ", 
		col.names = c("activity_id", "activity_label"), 
		colClasses = c("integer", "character"), 
            stringsAsFactors = FALSE
	)

	#
	# 2. Read 561 lines mapping feature ids 1-561 to a label each and therefore
    #    describing each variable from
	#    "./UCI HAR Dataset/features.txt"
	#
	all_features_df <- read.table(
		paste(fname_folder, "features.txt", sep = fname_separator),
		sep = " ", 
		col.names = c("feature_id", "feature_label"), 
		colClasses = c("integer", "character"), 
            stringsAsFactors = FALSE
	)

    #
    # 3. Compute a subset of all features (i.e. variables) that contains
    #    mean and standard deviation features only as a data frame
    #    with ids and labels as columns.
    #
    # grep is called with 'fixed = TRUE' to avoid '-meanFreq()' being a hit.
    #
    is_feature_wanted <- sapply(
        all_features_df$feature_label, 
        function(s) isTRUE((grep("-mean()", s, fixed = TRUE) > 0) || 
                           (grep("-std()", s, fixed = TRUE) > 0))
    )
    my_features_df <- data.frame(
        all_features_df$feature_id[is_feature_wanted], 
        all_features_df$feature_label[is_feature_wanted], 
        stringsAsFactors = FALSE
    )
    
	#
	# 4. Read activity ids by merging 7352 training set lines with 2947 test set lines
	#    (each containing an activity id out of 1-6).
	#
    activity_ids <- rbind(read_activity_ids(params_training), read_activity_ids(params_test))

    #
	# 5. Read subject ids by merging 7352 training set lines with 2947 test set lines
	#    (each containing one subject id).
	#
	subject_ids <- rbind(read_subject_ids(params_training), read_subject_ids(params_test))
	
	#
	# 6. Read the data set by merging 7352 training set lines with 2947 test set lines
	#    (each consisting of 561 variables).
	#
    full_matrix <- rbind(read_matrix(params_training$name), read_matrix(params_test$name))
    
    #
    # 7. Reduce the full matrix with 561 columns to one with 66 columns (33 mean and std
    #    variables each) because we are interested in mean and standard deviation variables
    #    only:
    #
    feature_id_vector <- my_features_df[[1]] # 1-6, 41-46, ..., 542, 543.
	my_matrix <- subset(full_matrix, select = feature_id_vector)
    
    #
	# 8. Turn the matrix into a data frame providing human-readable variable (i.e.
    #    column) names.
	#
	matrix_df <- data.frame(my_matrix)
    colnames(matrix_df) <- my_features_df[[2]]
    
    #
    # 9. The activity ids are translated into activity labels and a proper column
    #    name is provided.
    #
    activity_labels <- activities_df[[2]]
    activity_col <- sapply(activity_ids, function(x) activity_labels[x])
	colnames(activity_col) = c("activity") 

	#
	# 10. Create a data frame with 10299 subject ids followed by the same number
    #     of activity labels as the first two columns and the (10299*66)-matrix as 
    #     remaining columns:
	#
	tidy_df <- cbind(subject_ids, activity_col, matrix_df)

    #
    # 11. Write the tidy data set to check the result of the steps above
    #
    write.csv(tidy_df, "./tidy_data.csv")
 
    #
    # 12. Return the tidy data set for further use
    #
	tidy_df
}

#
# Main function 'compute_averages':
#
# First calls tidyfy_data() to merge several files into a tidy data set (which
# is reduced to those columns which are required and has human-readable column
# names as well as labels instead of id values where appropriate).
# Afterwards creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject 
#
compute_averages <- function() {
    #
    # 1. Transform the tidy data set into the so-called 'long-format'
    #    (see http://seananderson.ca/2013/10/19/reshape.html for details)
    #    with both subject_id and activity as ID variables.
    #
    #    The resulting data frame has the following columns:
    #    - subject_id
    #    - activity
    #    - variable
    #    - value
    #
    df_melt <- melt(tidyfy_data(), c("subject_id", "activity"))
    
    #
    # 2. Transform the melted data set in to the so called 'wide-format'
    #    (see http://seananderson.ca/2013/10/19/reshape.html for details)
    #    while using subject_id and activity as ID variables and
    #    aggregating each measurement variable with the function mean
    #    to compute the average value for each measurement variable
    #    for each activity and subject.
    #
    df_cast <- dcast(df_melt, subject_id + activity ~ variable, fun.aggregate = mean)
    
    #
    # 3. Below we just follow the course project's instructions to create a "data set 
    #     as a txt file created with write.table() using row.name=FALSE"
    #
    write.table(df_cast, "./result_data.txt", row.name = FALSE)
    
    #
    # 4. Return the aggregated tidy data set for further use
    #
    df_cast
}

