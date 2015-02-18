# README 

## “Human Activity Recognition Using Smartphones” data set

The program is created to clean the raw data for further data analysis.  The compressed raw data was downloaded at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

I first merged the measurements from the raw training set data (“x_train.txt”) and from the raw test set data (“x_test.txt”) to create one data set with the subject ID number and type of the activity attached.  There are 561 measurements.
Then, I extracted only the 66 measurements that were the mean and standard deviation measurements.  Finally, from this data set, I generated a second data set named “tidy_data.txt” by averaging each of the 66 measurements for each activity and each subject.  
Refer to the file "CodeBook.md" for the step-by-step processing of the raw data in detail.

Here is a portion of the tidy_data.txt file:

```
Subject	Activity	tBodyAcc.mean...X	tBodyAcc.mean...Y	tBodyAcc.mean...Z	tBodyAcc.std...X	tBodyAcc.std...Y
1	WALKING	0.277330759	-0.017383819	-0.111148104	-0.283740259	0.114461337
1	WALKING_UPSTAIRS	0.25546169	-0.023953149	-0.097302002	-0.354708025	-0.002320265
1	WALKING_DOWNSTAIRS	0.28918832	-0.009918505	-0.107566191	0.030035338	-0.031935943
1	SITTING	0.261237565	-0.001308288	-0.104544182	-0.977229008	-0.922618642
1	STANDING	0.278917629	-0.01613759	-0.110601818	-0.995759902	-0.973190056
1	LAYING	0.221598244	-0.040513953	-0.113203554	-0.928056469	-0.836827406
2	WALKING	0.276426586	-0.01859492	-0.105500358	-0.423642838	-0.078091253
2	WALKING_UPSTAIRS	0.24716479	-0.021412113	-0.1525139	-0.304376406	0.10802728

```
