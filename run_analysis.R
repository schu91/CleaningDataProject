# Here are the data for the project:

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following. 

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
########################################
# 1. Merge the training and the test sets to create one data set with the subject ID attached.
data_url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url, "rundata.zip")
unzip("rundata.zip")
list <- list.files("UCI HAR Dataset", recursive = TRUE, full.names = TRUE)
test_data <- read.table(list[[15]])
train_data <- read.table(list[[27]])
measure_data1 <- rbind(test_data, train_data)
subject_test <- read.table(list[[14]])
subject_train <- read.table(list[[26]])
subject_data <- rbind(subject_test, subject_train)
colnames(subject_data) <- "Subject"
# 2. Appropriately label the data set with descriptive variable names. 
var_name <- read.table(list[[2]])[,2]
colnames(measure_data1)<- var_name
measure_data <- data.frame(subject_data, measure_data1)
# 3. Extract only the measurements on the mean and standard deviation for each measurement. 
index_mean <- grep("mean()", var_name, fixed = TRUE)
index_std <- grep("std()", var_name, fixed = TRUE)
index <- sort(c(index_mean, index_std))
measure_data_new <- measure_data[, c(1,index+1)]
# 4. Use descriptive activity names to name the activities in the data set 
activity_test <- read.table(list[[16]])
activity_train <- read.table(list[[28]])
activity_data <- rbind(activity_test, activity_train)
activity_label <- read.table(list[[1]])[,2]
colnames(activity_data) <- "Activity"
activity_data$Activity <- factor(activity_data$Activity)
levels(activity_data$Activity) <- activity_label
run_data = cbind(activity_data, measure_data_new)
# 5. From the data set in step 4, create a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
tidy_data1 <- aggregate(run_data[,-c(1:2)], 
            list(run_data$Activity,run_data$Subject), 
                 mean, na.rm =TRUE)
names(tidy_data1)[names(tidy_data1) == "Group.1"] <- "Activity"
names(tidy_data1)[names(tidy_data1) == "Group.2"] <- "Subject"
tidy_data <- tidy_data1[,c(2, 1, 3:68)]
write.table(tidy_data, "tidy_data.txt", sep="\t", row.names = F) 
###################################################


dim(test_data)
dim(train_data)
dim (measure_data)
head(measure_data_new[1:9])
names(measure_data_new)[1:10]
names(measure_data_new)[550:562]
head(measure_data[Group == "train", 1:9])
head(measure_data_new[Group == "test", 1:9])
head(measure_data[Group == "train", 1:9])
head(run_data[Group == "test", 1:9])
head(run_data[Group == "train", 1:9])
tidy_data[1:12,1:9]
names(measure_data_new)[7]
