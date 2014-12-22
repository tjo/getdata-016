library(reshape2)

load_and_bind <- function(fileNameA, fileNameB, col.names) {
  a <- read.table(fileNameA, col.names = col.names)
  b <- read.table(fileNameB, col.names = col.names)
  rbind(a, b)
}

clean_data <- function() {
  column_names <- c("timeBodyAcc-mean-X", "timeBodyAcc-mean-Y", "timeBodyAcc-mean-Z",
                    "timeBodyAcc-std-X", "timeBodyAcc-std-Y", "timeBodyAcc-std-Z",
                    "timeGravityAcc-mean-X", "timeGravityAcc-mean-Y", "timeGravityAcc-mean-Z",
                    "timeGravityAcc-std-X", "timeGravityAcc-std-Y", "timeGravityAcc-std-Z",
                    "timeBodyAccJerk-mean-X", "timeBodyAccJerk-mean-Y", "timeBodyAccJerk-mean-Z",
                    "timeBodyAccJerk-std-X", "timeBodyAccJerk-std-Y", "timeBodyAccJerk-std-Z",
                    "timeBodyGyro-mean-X", "timeBodyGyro-mean-Y", "timeBodyGyro-mean-Z",
                    "timeBodyGyro-std-X", "timeBodyGyro-std-Y", "timeBodyGyro-std-Z",
                    "timeBodyGyroJerk-mean-X", "timeBodyGyroJerk-mean-Y", "timeBodyGyroJerk-mean-Z",
                    "timeBodyGyroJerk-std-X", "timeBodyGyroJerk-std-Y", "timeBodyGyroJerk-std-Z",
                    "timeBodyAccMag-mean", "timeBodyAccMag-std", 
                    "timeGravityAccMag-mean", "timeGravityAccMag-std", 
                    "timeBodyAccJerkMag-mean", "timeBodyAccJerkMag-std",
                    "timeBodyGyroMag-mean", "timeBodyGyroMag-std",
                    "timeBodyGyroJerkMag-mean", "timeBodyGyroJerkMag-std",
                    "freqBodyAcc-mean-X", "freqBodyAcc-mean-Y", "freqBodyAcc-mean-Z",
                    "freqBodyAcc-std-X", "freqBodyAcc-std-Y", "freqBodyAcc-std-Z",
                    "freqBodyAccJerk-mean-X","freqBodyAccJerk-mean-Y","freqBodyAccJerk-mean-Z",
                    "freqBodyAccJerk-std-X","freqBodyAccJerk-std-Y","freqBodyAccJerk-std-Z",
                    "freqBodyGyro-mean-X", "freqBodyGyro-mean-Y", "freqBodyGyro-mean-Z",
                    "freqBodyGyro-std-X", "freqBodyGyro-std-Y", "freqBodyGyro-std-Z",
                    "freqBodyAccMag-mean", "freqBodyAccMag-std",
                    "freqBodyAccJerkMag-mean", "freqBodyAccJerkMag-std", 
                    "freqBodyGyroMag-mean", "freqBodyGyroMag-std",
                    "freqBodyGyroJerkMag-mean", "freqBodyGyroJerkMag-std")
  
  ## Reading initial data files
  features <- read.table("UCI HAR Dataset/features.txt", col.names = c("colNum", "name"), as.is = TRUE)
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity"))
  
  ## Loading and binding test and training data
  X_set <- load_and_bind("UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/test/X_test.txt")
  subjects <- load_and_bind("UCI HAR Dataset/train/subject_train.txt", "UCI HAR Dataset/test/subject_test.txt", col.names = c("subject_id"))
  activities <- load_and_bind("UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/test/y_test.txt", col.names = c("activity_id"))
  
  ## Filtering column numbers to only find std and mean columns
  ## In this case the column name must meet the following criteria - must contain std or mean followed directly by ()
  ## The criteria can be expressed as the following regex: (std|mean)\\(\\)
  mean_and_std_features <- features[(grep("(std|mean)\\(\\)", features$name)),]
  
  ## Selecting from the X_set only the columns we're interested in
  std_and_mean_X_set <- X_set[,mean_and_std_features$colNum]
  
  ## Setting column names to readable values
  ## Naming the variables explicitely here, could have cleaned up the "features" data table, however this forced
  ## slightly better understanding of the actual data being processed
  names(std_and_mean_X_set) <- column_names
  
  ## Appending all rows from training and test sets
  std_and_mean_all_data <- cbind(subjects, activities, std_and_mean_X_set)
  
  ## Merging with activity labels
  std_and_mean_all_data_with_activity_labels <- merge(activity_labels, std_and_mean_all_data)
  
  # Calculating averages for each activity and each subject_id
  melted_all_data <- melt(std_and_mean_all_data_with_activity_labels, id = c("activity_id", "activity", "subject_id"))
  means <- dcast(melted_all_data, activity + subject_id ~ variable, mean)  
  
  # Returning the final data set
  means
}