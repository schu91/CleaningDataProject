# Codebook for processing the “Human Activity Recognition Using Smartphones” data set
##A.  Introduction

The data set was obtained from the project of “Human Activity Recognition Using Smartphones”.  The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured using embedded accelerometer and gyroscope. (Refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
The raw dataset was randomly partitioned into two sets, where 21 of the volunteers were selected for generating the training data and 9 of the test data.  The raw data can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##B.  Data Processing
###R scrip called “run_analysis.R” contains the program code to produce the processed data file named “tidy_data.txt” for data analysis.   Here shows the steps/code applied for processing the raw data to produce the “tidy_data.txt” data file.
 	###Step 1 - Use R to download and unzip the compressed folder:   
	   
	   > url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
       > download.file(data_url, "rundata.zip")
       > unzip("rundata.zip")
       > list <- list.files("UCI HAR Dataset", recursive = TRUE, full.names = TRUE)
       
      	A list of folders and files is displayed as follows:
		[1] "UCI HAR Dataset/activity_labels.txt"                         
 		[2] "UCI HAR Dataset/features.txt"                                
 		[3] "UCI HAR Dataset/features_info.txt"                           
 		[4] "UCI HAR Dataset/README.txt"                                  
 		[5] "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
 		[6] "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
 		[7] "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
 		[8] "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
 		[9] "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
		[10] "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
		[11] "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
		[12] "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
		[13] "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
		[14] "UCI HAR Dataset/test/subject_test.txt"                       
		[15] "UCI HAR Dataset/test/X_test.txt"                             
		[16] "UCI HAR Dataset/test/y_test.txt"                             
		[17] "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
		[18] "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
		[19] "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
		[20] "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
		[21] "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
		[22] "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
		[23] "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
		[24] "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
		[25] "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
       		[26] "UCI HAR Dataset/train/subject_train.txt"                     
		[27] "UCI HAR Dataset/train/X_train.txt"                           
        [28] "UCI HAR Dataset/train/y_train.txt"  
		
###Step 2 - Merge the training set (“x_train.txt”) and the test set (“x_test.txt”) to create one data set with subject ID number displayed in “subject_train.txt” and “subject_test.txt” files
       
	   >test_data <- read.table(list[[15]])
       >train_data <- read.table(list[[27]])
       >measure_data1 <- rbind(test_data, train_data)
       >subject_test <- read.table(list[[14]])
       >subject_train <- read.table(list[[26]])
       >subject_data <- rbind(subject_test, subject_train)
       >colnames(subject_data) <- "Subject"
       
       Step 3 - label the data set with descriptive variable names in features.txt.
       >var_name <- read.table(list[[2]])[,2]
       >colnames(measure_data1)<- var_name
       >measure_data <- data.frame(subject_data, measure_data1)
       
###Step 4 - Extract only the measurements on the mean and standard deviation for each measurement. 
       
	   >index_mean <- grep("mean()", var_name, fixed = TRUE)
       >index_std <- grep("std()", var_name, fixed = TRUE)
       >index <- sort(c(index_mean, index_std))
       >measure_data_new <- measure_data[, index]
       
###Step 5 - Use descriptive activity names in “y_train.txt” and “y-test.txt” files to name the activities in the data set called “run_data”.
       
	   >activity_test <- read.table(list[[16]])
       >activity_train <- read.table(list[[28]])
       >activity_data <- rbind(activity_test, activity_train)
       >activity_label <- read.table(list[[1]])[,2]
       >colnames(activity_data) <- "Activity"
       >activity_data$Activity <- factor(activity_data$Activity)
       >levels(activity_data$Activity) <- activity_label
       >run_data = cbind(activity_data, measure_data_new)
       
###Step 6 - From the data set in step 5, create a second, independent tidy data set named “tidy_data.txt” with the average of each variable for each activity and each subject.
       
	   >tidy_data1 <- aggregate(run_data[,-c(1:2)], 
       >list(run_data$Activity,run_data$Subject), mean, na.rm =TRUE)
       >names(tidy_data1)[names(tidy_data1) == "Group.1"] <- "Activity"
       >names(tidy_data1)[names(tidy_data1) == "Group.2"] <- "Subject"
       >tidy_data <- tidy_data1[,c(2, 1, 3:67)]
       >write.table(tidy_data, "tidy_data.txt", sep="\t", row.names = F) 
       
##C. Data Information

Tidy_data data set contains 68 variables including Subject, Activity and other 66 average measures as shown in the following table:

  |R Variable Names           |Description                 |Values                |
  |---------------------------|:--------------------------:|---------------------:|
   | Subject                   |Subject ID                 |1 to 30               |
  |Activity                    |Activity                   |1. WALKING            |
                                                           |2. WALKING_UPSTAIRS   |
                                                           |3. WALKING_DOWNSTAIRS | 
                                                           |4. SITTING            |
                                                           |5. STANDING            |  |tBodyAcc.mean...X           |Average of tBodyAcc-mean()-X |numeric  |tBodyAcc.mean...Y           |Average of tBodyAcc-mean()-Y |numeric |tBodyAcc.mean...Z     |Average of tBodyAcc-mean()-Z     |    numeric  |tBodyAcc.std...X      | Average of tBodyAcc-std()-X        |   numerictBodyAcc.std...YAverage of tBodyAcc-std()-YnumerictBodyAcc.std...ZAverage of tBodyAcc-std()-ZnumerictGravityAcc.mean...XAverage of tGravityAcc-mean()-XnumerictGravityAcc.mean...YAverage of tGravityAcc-mean()-YnumerictGravityAcc.mean...ZAverage of tGravityAcc-mean()-ZnumerictGravityAcc.std...XAverage of tGravityAcc-std()-XnumerictGravityAcc.std...YAverage of tGravityAcc-std()-YnumerictGravityAcc.std...ZAverage of tGravityAcc-std()-ZnumerictBodyAccJerk.mean...XAverage of tBodyAccJerk-mean()-XnumerictBodyAccJerk.mean...YAverage of tBodyAccJerk-mean()-YnumerictBodyAccJerk.mean...ZAverage of tBodyAccJerk-mean()-ZnumerictBodyAccJerk.std...XAverage of tBodyAccJerk-std()-XnumerictBodyAccJerk.std...YAverage of tBodyAccJerk-std()-YnumerictBodyAccJerk.std...ZAverage of tBodyAccJerk-std()-ZnumerictBodyGyro.mean...XAverage of tBodyGyro-mean()-XnumerictBodyGyro.mean...YAverage of tBodyGyro-mean()-YnumerictBodyGyro.mean...ZAverage of tBodyGyro-mean()-ZnumerictBodyGyro.std...XAverage of tBodyGyro-std()-XnumerictBodyGyro.std...YAverage of tBodyGyro-std()-YnumerictBodyGyro.std...ZAverage of tBodyGyro-std()-ZnumerictBodyGyroJerk.mean...XAverage of tBodyGyroJerk-mean()-XnumerictBodyGyroJerk.mean...YAverage of tBodyGyroJerk-mean()-YnumerictBodyGyroJerk.mean...ZAverage of tBodyGyroJerk-mean()-ZnumerictBodyGyroJerk.std...XAverage of tBodyGyroJerk-std()-XnumerictBodyGyroJerk.std...YAverage of tBodyGyroJerk-std()-YnumerictBodyGyroJerk.std...ZAverage of tBodyGyroJerk-std()-ZnumerictBodyAccMag.mean..Average of tBodyAccMag-mean()numerictBodyAccMag.std..Average of tBodyAccMag-std()numerictGravityAccMag.mean..tGravityAccMag-mean()numerictGravityAccMag.std..tGravityAccMag-std()numerictBodyAccJerkMag.mean..Average of tBodyAccJerkMag-mean()numerictBodyAccJerkMag.std..Average of tBodyAccJerkMag-std()numerictBodyGyroMag.mean..Average of tBodyGyroMag-mean()numerictBodyGyroMag.std..Average of tBodyGyroMag-std()numerictBodyGyroJerkMag.mean..Average of tBodyGyroJerkMag-mean()numerictBodyGyroJerkMag.std..Average of tBodyGyroJerkMag-std()numericfBodyAcc.mean...XAverage of fBodyAcc-mean()-XnumericfBodyAcc.mean...YAverage of fBodyAcc-mean()-YnumericfBodyAcc.mean...ZAverage of fBodyAcc-mean()-ZnumericfBodyAcc.std...XAverage of fBodyAcc-std()-XnumericfBodyAcc.std...YAverage of fBodyAcc-std()-YnumericfBodyAcc.std...ZAverage of fBodyAcc-std()-ZnumericfBodyAccJerk.mean...XAverage of fBodyAccJerk-mean()-XnumericfBodyAccJerk.mean...YAverage of fBodyAccJerk-mean()-YnumericfBodyAccJerk.mean...ZAverage of fBodyAccJerk-mean()-ZnumericfBodyAccJerk.std...XAverage of fBodyAccJerk-std()-XnumericfBodyAccJerk.std...YAverage of fBodyAccJerk-std()-YnumericfBodyAccJerk.std...ZAverage of fBodyAccJerk-std()-ZnumericfBodyGyro.mean...XAverage of fBodyGyro-mean()-XnumericfBodyGyro.mean...YAverage of fBodyGyro-mean()-YnumericfBodyGyro.mean...ZAverage of fBodyGyro-mean()-ZnumericfBodyGyro.std...XAverage of fBodyGyro-std()-XnumericfBodyGyro.std...YAverage of fBodyGyro-std()-YnumericfBodyGyro.std...ZAverage of fBodyGyro-std()-ZnumericfBodyAccMag.mean..Average of fBodyAccMag-mean()numericfBodyAccMag.std..Average of fBodyAccMag-std()numericfBodyBodyAccJerkMag.mean..Average of fBodyBodyAccJerkMag-mean()numericfBodyBodyAccJerkMag.std..Average of fBodyBodyAccJerkMag-std()numericfBodyBodyGyroMag.mean..Average of fBodyBodyGyroMag-mean()numericfBodyBodyGyroMag.std..Average of fBodyBodyGyroMag-std()numericfBodyBodyGyroJerkMag.mean..Average of fBodyBodyGyroJerkMag-mean()numericfBodyBodyGyroJerkMag.std..Average of fBodyBodyGyroJerkMag-std()numeric	

       





       
       

       
       



