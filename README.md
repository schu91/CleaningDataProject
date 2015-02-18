# README 

## “Human Activity Recognition Using Smartphones” data set

The compressed raw data was downloaded at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

I first merged the measurements from the raw training set data (“x_train.txt”) and from the raw test set data (“x_test.txt”) to create one data set with the subject ID number and type of the activity attached.  There are 561 measurements.
Then, I extracted only the 66 measurements that were the mean and standard deviation measurements.  Finally, from this data set, I generated a second data set named “tidy_data.txt” by averaging each of the 66 measurements for each activity and each subject.  The detail steps for processing the data can be found in the Codebook.


