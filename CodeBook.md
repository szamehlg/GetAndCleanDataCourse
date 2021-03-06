# Original Data

The original data is can be downloaded via https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The data was collected from the accelerometers from the Samsung Galaxy S smartphone. For a
full description refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Using the dataset in publications requires referencing the following publication:

> Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human
Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## The Files Used

The eight files used do not contain NAs.

### UCI HAR Dataset/activity_labels.txt

Dimensions: 6 rows, 2 columns.

|Column  |Type      |Notes
|------- |--------- |--------------------------
|id      |integer   |1 to 6
|label   |character |e.g. 'WALKING' or 'LAYING'

Maps activity_id to activity_label. 

Relation to the experiment: "Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist."

### UCI HAR Dataset/features.txt

Dimensions: 561 rows, 2 columns.

|Column  |Type      |Notes
|------- |-----     |------
|id      |integer   |1 to 561
|label   |character |e.g. 'tBodyAcc-mean()-X' or 'angle(Z,gravityMean)'

Maps feature_id to feature_label. 

Relation to the experiment: "feature vector with time and frequency domain variables" resulting
from the smartphone's "sensor signals (accelerometer and gyroscope)"

### UCI HAR Dataset/test/subject_test.txt

Dimensions: 2947 rows, 1 column.

|Column  |Type    |Notes
|------- |-----   |------
|id      |integer |Subset of 1 to 30

subject_id list. 

Relation to the experiment: "Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30." and "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years."

### UCI HAR Dataset/test/X_test.txt

Dimensions: 2947 rows, 561 columns.

|Column      |Type    |Notes
|-------     |-----   |------
|feature 1   |numeric |variable 1
|...         |...     |...
|feature 561 |numeric |variable 561

variables matrix = test data set (every feature is a measure)

Relation to the experiment: Each row is a "561-feature vector with time and frequency domain variables" and "The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

### UCI HAR Dataset/test/y_test.txt

Dimensions: 2947 rows, 1 column.

|Column  |Type    |Notes
|------- |-----   |------
|id      |integer |1 to 6

activity_id list. 

Relation to the experiment: Id of the "activity for each window sample".

### UCI HAR Dataset/train/subject_train.txt

Dimensions: 7352 rows, 1 column.

|Column  |Type    |Notes
|------- |-----   |------
|id      |integer |Subset of 1 to 30

subject_id list. 

Relation to the experiment: "Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30." and "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years."

### UCI HAR Dataset/train/X_train.txt

Dimensions: 7352 rows, 561 columns.

|Column      |Type    |Notes
|-------     |-----   |------
|feature 1   |numeric |variable 1
|...         |...     |...
|feature 561 |numeric |variable 561

variables matrix = training data set (every feature is a measure)

Relation to the experiment: Each row is a "561-feature vector with time and frequency domain variables" and "The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."

### UCI HAR Dataset/train/y_train.txt

Dimensions: 7352 rows, 1 column.

|Column  |Type    |Notes
|------- |------  |------
|id      |integer |1 to 6

activity_id list. 

Relation to the experiment: Id of the "activity for each window sample".

# Tidy Data Set No 1

## The Goal

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set.
4. Appropriately label the data set with descriptive variable names. 

## The Solution

### 1. Merge training and test sets

1. activity ids: 'UCI HAR Dataset/train/y_train.txt' and 'UCI HAR Dataset/test/y_test.txt' are merged with ```rbind``` resulting in a data frame with 7352 + 2947 = 10299 rows and 1 integer column (R script: Step 1).
2. subject ids: 'UCI HAR Dataset/train/subject_train.txt' and 'UCI HAR Dataset/test/subject_test.txt' are merged with ```rbind``` resulting in a data frame with 7352 + 2947 = 10299 rows and 1 integer column (R script: Step 2).
3. data sets: 'UCI HAR Dataset/train/X_train.txt' and 'UCI HAR Dataset/test/X_test.txt' are merged with ```rbind``` resulting in a matrix with 7352 + 2947 = 10299 rows and 561 numeric columns (R script: Step 3).

### 2. Mean and standard deviaton only

The file 'UCI HAR Dataset/features_info.txt' provides the following information:

+ mean(): Mean value
+ std(): Standard deviation
+ meanFreq(): Weighted average of the frequency components to obtain a mean frequency

They key idea is to select the desired columns via text matching against feature labels (which are contained in the file 'UCI HAR Dataset/features.txt') (R script: Step 4).

1. No other feature (i.e. variable) label matches 'mean' or 'std'.
2. The definition of 'meanFreq()' results in 'mean frequency', not 'mean'.
3. 'mean()' and 'std()' variables occur in 'features.txt' always in pairs.

With 1.-3. as arguments, I decided to use ```grep``` with parameters ```"-mean()"``` and ```fixed = TRUE``` resulting in 33 mean variables and ```grep``` with parameters ```"-std()"``` and ```fixed = TRUE``` resulting in 33 std variables combined in one vector (R script: Step 5).
Usage of ```fixed = TRUE``` results in exact matches only thus disregarding feature labels containing 'meanFreq()'.

Using this vector the matrix with 561 columns is reduced to one with 66 columns (33 mean and std variables each) (R script: Step 6).

### 3. Descriptive activity names

At first, 'UCI HAR Dataset/activity_labels.txt' is loaded into a data frame providing the activity ids 1 to 6 according with their corresponding activity labels (R script: Step 7).

After that all 10299 activity ids are translated into activity labels thus providing descriptive activity names (R script, Step 8).

### 4. Descriptive variable names

After converting the reduced matrix with 66 columns into a data frame, the feature labels obtained under '2. Mean and standard deviaton only' (those containing "-mean()" and "-std()") are used as descriptive variable names for this data frame (R script: Step 9).

Then ```cbind``` is used to create a data frame (the first tidy data set) with 10299 subject ids followed by the same number of activity labels as the first two columns and the (10299*66)-matrix as remaining columns (R script: Step 10), see below.

### Code book

Dimensions: 10299 rows, 1 + 1 + 66 = 68 columns.

|Column                       |Type        |Notes
|-------                      |-------     |--------
|subject_id                   |integer     |1 to 30
|activity                     |character   |e.g. 'WALKING' or 'LAYING'
|tBodyAcc-mean()-X            |numeric     |measure 01
|tBodyAcc-mean()-Y            |numeric     |measure 02
|tBodyAcc-mean()-Z            |numeric     |measure 03
|tBodyAcc-std()-X             |numeric     |measure 04
|tBodyAcc-std()-Y             |numeric     |measure 05
|tBodyAcc-std()-Z             |numeric     |measure 06
|tGravityAcc-mean()-X         |numeric     |measure 07
|tGravityAcc-mean()-Y         |numeric     |measure 08
|tGravityAcc-mean()-Z         |numeric     |measure 09
|tGravityAcc-std()-X          |numeric     |measure 10
|tGravityAcc-std()-Y          |numeric     |measure 11
|tGravityAcc-std()-Z          |numeric     |measure 12
|tBodyAccJerk-mean()-X        |numeric     |measure 13
|tBodyAccJerk-mean()-Y        |numeric     |measure 14
|tBodyAccJerk-mean()-Z        |numeric     |measure 15
|tBodyAccJerk-std()-X         |numeric     |measure 16
|tBodyAccJerk-std()-Y         |numeric     |measure 17
|tBodyAccJerk-std()-Z         |numeric     |measure 18
|tBodyGyro-mean()-X           |numeric     |measure 19
|tBodyGyro-mean()-Y           |numeric     |measure 20
|tBodyGyro-mean()-Z           |numeric     |measure 21
|tBodyGyro-std()-X            |numeric     |measure 22
|tBodyGyro-std()-Y            |numeric     |measure 23
|tBodyGyro-std()-Z            |numeric     |measure 24
|tBodyGyroJerk-mean()-X       |numeric     |measure 25
|tBodyGyroJerk-mean()-Y       |numeric     |measure 26
|tBodyGyroJerk-mean()-Z       |numeric     |measure 27
|tBodyGyroJerk-std()-X        |numeric     |measure 28
|tBodyGyroJerk-std()-Y        |numeric     |measure 29
|tBodyGyroJerk-std()-Z        |numeric     |measure 30
|tBodyAccMag-mean()           |numeric     |measure 31
|tBodyAccMag-std()            |numeric     |measure 32
|tGravityAccMag-mean()        |numeric     |measure 33
|tGravityAccMag-std()         |numeric     |measure 34
|tBodyAccJerkMag-mean()       |numeric     |measure 35
|tBodyAccJerkMag-std()        |numeric     |measure 36
|tBodyGyroMag-mean()          |numeric     |measure 37
|tBodyGyroMag-std()           |numeric     |measure 38
|tBodyGyroJerkMag-mean()      |numeric     |measure 39
|tBodyGyroJerkMag-std()       |numeric     |measure 40
|fBodyAcc-mean()-X            |numeric     |measure 41
|fBodyAcc-mean()-Y            |numeric     |measure 42
|fBodyAcc-mean()-Z            |numeric     |measure 43
|fBodyAcc-std()-X             |numeric     |measure 44
|fBodyAcc-std()-Y             |numeric     |measure 45
|fBodyAcc-std()-Z             |numeric     |measure 46
|fBodyAccJerk-mean()-X        |numeric     |measure 47
|fBodyAccJerk-mean()-Y        |numeric     |measure 48
|fBodyAccJerk-mean()-Z        |numeric     |measure 49
|fBodyAccJerk-std()-X         |numeric     |measure 50
|fBodyAccJerk-std()-Y         |numeric     |measure 51
|fBodyAccJerk-std()-Z         |numeric     |measure 52
|fBodyGyro-mean()-X           |numeric     |measure 53
|fBodyGyro-mean()-Y           |numeric     |measure 54
|fBodyGyro-mean()-Z           |numeric     |measure 55
|fBodyGyro-std()-X            |numeric     |measure 56
|fBodyGyro-std()-Y            |numeric     |measure 57
|fBodyGyro-std()-Z            |numeric     |measure 58
|fBodyAccMag-mean()           |numeric     |measure 59
|fBodyAccMag-std()            |numeric     |measure 60
|fBodyBodyAccJerkMag-mean()   |numeric     |measure 61
|fBodyBodyAccJerkMag-std()    |numeric     |measure 62
|fBodyBodyGyroMag-mean()      |numeric     |measure 63
|fBodyBodyGyroMag-std()       |numeric     |measure 64
|fBodyBodyGyroJerkMag-mean()  |numeric     |measure 65
|fBodyBodyGyroJerkMag-std()   |numeric     |measure 66

# Tidy Data Set No 2 - the Aggregated Data 

## The Goal

From the tidy data set no 1...<br>
...create an independant data set...<br>
...with the average of each variable...<br>
...for each activity and each subject.

## The solution

The key idea is to melt and cast the data set while performing aggregation during the cast.

1. Transform the tidy data no 1 set into the so-called 'long-format' (see http://seananderson.ca/2013/10/19/reshape.html for details) with both subject_id and activity as ID variables (R script: Step 13).<br>The resulting data frame has the following columns:<br>- subject_id<br>- activity<br>- variable<br>- value
2. Transform the melted data set in to the so called 'wide-format' (see http://seananderson.ca/2013/10/19/reshape.html for details) while using subject_id and activity as ID variables and aggregating each measurement variable with the function ```mean``` to compute the average value for each measurement variable for each activity and subject (R script: Step 14).

## Code book

Dimensions: 180 rows, 68 columns (they are the same as for the tiny data set no 1).

|Column                       |Type        |Notes
|-------                      |-------     |--------
|subject_id                   |integer     |1 to 30
|activity                     |character   |e.g. 'WALKING' or 'LAYING'
|tBodyAcc-mean()-X            |numeric     |measure 01
|...                          |...         |...
|fBodyBodyGyroJerkMag-std()   |numeric     |measure 66


