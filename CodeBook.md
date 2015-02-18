# Codebook for processing the “Human Activity Recognition Using Smartphones” data set
##A.  Introduction

The data set was obtained from the project of “Human Activity Recognition Using Smartphones”.  The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured using embedded accelerometer and gyroscope. (Refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
The raw dataset was randomly partitioned into two sets, where 21 of the volunteers were selected for generating the training data and 9 of the test data.  The raw data can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##B.  Data Processing

A R scrip called “run_analysis.R” contains the program code to produce the processed data file named “tidy_data.txt” for data analysis.   Here shows the steps/code applied for processing the raw data to produce the “tidy_data.txt” data file.
 	
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
       
###C. Data Information

Tidy_data data set contains 68 variables including Subject, Activity and other 66 average measures as shown in the following table:

  |R Variable Names           |Description                 |Values                |
  |---------------------------|:--------------------------:|---------------------:|
   | Subject                   |Subject ID                 |1 to 30               |
  |Activity                    |Activity                   |1. WALKING            |
                                                           |2. WALKING_UPSTAIRS   |
                                                           |3. WALKING_DOWNSTAIRS | 
                                                           |4. SITTING            |
                                                           |5. STANDING            |  

    





       
       

       
       



