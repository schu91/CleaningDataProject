# Codebook for processing the �Human Activity Recognition Using Smartphones� data set
##A.  Introduction

The data set was obtained from the project of �Human Activity Recognition Using Smartphones�.  The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured using embedded accelerometer and gyroscope. (Refer to http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
The raw dataset was randomly partitioned into two sets, where 21 of the volunteers were selected for generating the training data and 9 of the test data.  The raw data can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##B.  Data Processing

A R scrip called �run_analysis.R� contains the program code to produce the processed data file named �tidy_data.txt� for data analysis.   Here shows the steps/code applied for processing the raw data to produce the �tidy_data.txt� data file.
 	
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
		
###Step 2 - Merge the training set (�x_train.txt�) and the test set (�x_test.txt�) to create one data set with subject ID number displayed in �subject_train.txt� and �subject_test.txt� files
       
	   >test_data <- read.table(list[[15]])
       >train_data <- read.table(list[[27]])
       >measure_data1 <- rbind(test_data, train_data)
       >subject_test <- read.table(list[[14]])
       >subject_train <- read.table(list[[26]])
       >subject_data <- rbind(subject_test, subject_train)
       >colnames(subject_data) <- "Subject"
       
###Step 3 - label the data set with descriptive variable names in features.txt.
       >var_name <- read.table(list[[2]])[,2]
       >colnames(measure_data1)<- var_name
       >measure_data <- data.frame(subject_data, measure_data1)
       
###Step 4 - Extract only the measurements on the mean and standard deviation for each measurement. 
       
	   >index_mean <- grep("mean()", var_name, fixed = TRUE)
       >index_std <- grep("std()", var_name, fixed = TRUE)
       >index <- sort(c(index_mean, index_std))
       >measure_data_new <- measure_data[, index]
       
###Step 5 - Use descriptive activity names in �y_train.txt� and �y-test.txt� files to name the activities in the data set called �run_data�.
       
	   >activity_test <- read.table(list[[16]])
       >activity_train <- read.table(list[[28]])
       >activity_data <- rbind(activity_test, activity_train)
       >activity_label <- read.table(list[[1]])[,2]
       >colnames(activity_data) <- "Activity"
       >activity_data$Activity <- factor(activity_data$Activity)
       >levels(activity_data$Activity) <- activity_label
       >run_data = cbind(activity_data, measure_data_new)
       
###Step 6 - From the data set in step 5, create a second, independent tidy data set named �tidy_data.txt� with the average of each variable for each activity and each subject.
       
	   >tidy_data1 <- aggregate(run_data[,-c(1:2)], 
       >list(run_data$Activity,run_data$Subject), mean, na.rm =TRUE)
       >names(tidy_data1)[names(tidy_data1) == "Group.1"] <- "Activity"
       >names(tidy_data1)[names(tidy_data1) == "Group.2"] <- "Subject"
       >tidy_data <- tidy_data1[,c(2, 1, 3:67)]
       >write.table(tidy_data, "tidy_data.txt", sep="\t", row.names = F) 
       
###C. Data Information

The "tidy_data.txt" data set contains 180 observations of 68 variables including Subject, Activity and other 66 average measures as listed below:
```
 	  VARIABLES                                  VALUES
1	  Subject                    : integer  1 1 1 1 1 1 2 2 2 2 ...
2	  Activity                   : Factor with 6 levels: 
                   1."WALKING",2."WALKING_UPSTAIRS",3."WALKING_DOWNSTAIRS, 4."SITTING",5."STANDIND",6."LAYING": 
				      1 2 3 4 5 6 1 2 3 4 �
3	  tBodyAcc.mean...X          : num  0.277 0.255 0.289 0.261 0.279 ...
4	  tBodyAcc.mean...Y          : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
5	  tBodyAcc.mean...Z          : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
6	  tBodyAcc.std...X           : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
7	  tBodyAcc.std...Y           : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
8	  tBodyAcc.std...Z           : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
9	  tGravityAcc.mean...X       : num  0.935 0.893 0.932 0.832 0.943 ...
10	  tGravityAcc.mean...Y       : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
11	  tGravityAcc.mean...Z       : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
12	  tGravityAcc.std...X        : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
13	  tGravityAcc.std...Y        : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
14	  tGravityAcc.std...Z        : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
15	  tBodyAccJerk.mean...X      : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
16	  tBodyAccJerk.mean...Y      : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
17	  tBodyAccJerk.mean...Z      : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
18	  tBodyAccJerk.std...X       : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
19	  tBodyAccJerk.std...Y       : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
20	  tBodyAccJerk.std...Z       : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
21	  tBodyGyro.mean...X         : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
22	  tBodyGyro.mean...Y         : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
23	  tBodyGyro.mean...Z         : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
24	  tBodyGyro.std...X          : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
25	  tBodyGyro.std...Y          : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
26	  tBodyGyro.std...Z          : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
27	  tBodyGyroJerk.mean...X     : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
28	  tBodyGyroJerk.mean...Y     : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
29	  tBodyGyroJerk.mean...Z     : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
30	  tBodyGyroJerk.std...X      : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
31	  tBodyGyroJerk.std...Y      : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
32	  tBodyGyroJerk.std...Z      : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
33	  tBodyAccMag.mean..         : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
34	  tBodyAccMag.std..          : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
35	  tGravityAccMag.mean..      : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
36	  tGravityAccMag.std..       : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
37	  tBodyAccJerkMag.mean..     : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
38	  tBodyAccJerkMag.std..      : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
39	  tBodyGyroMag.mean..        : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
40	  tBodyGyroMag.std..         : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
41	  tBodyGyroJerkMag.mean..    : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
42	  tBodyGyroJerkMag.std..     : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
43	  fBodyAcc.mean...X          : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
44	  fBodyAcc.mean...Y          : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
45	  fBodyAcc.mean...Z          : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
46	  fBodyAcc.std...X           : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
47	  fBodyAcc.std...Y           : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
48	  fBodyAcc.std...Z           : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
49	  fBodyAccJerk.mean...X      : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
50	  fBodyAccJerk.mean...Y      : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
51	  fBodyAccJerk.mean...Z      : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
52	  fBodyAccJerk.std...X       : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
53	  fBodyAccJerk.std...Y       : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
54	  fBodyAccJerk.std...Z       : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
55	  fBodyGyro.mean...X         : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
56	  fBodyGyro.mean...Y         : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
57	  fBodyGyro.mean...Z         : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
58	  fBodyGyro.std...X          : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
59	  fBodyGyro.std...Y          : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
60	  fBodyGyro.std...Z          : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
61	  fBodyAccMag.mean..         : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
62	  fBodyAccMag.std..          : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
63	  fBodyBodyAccJerkMag.mean.. : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
64	  fBodyBodyAccJerkMag.std..  : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
65	  fBodyBodyGyroMag.mean..    : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
66	  fBodyBodyGyroMag.std..     : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
67	  fBodyBodyGyroJerkMag.mean..: num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
68	  fBodyBodyGyroJerkMag.std.. : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
```






       
       

       
       



