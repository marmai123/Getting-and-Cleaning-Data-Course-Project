# CodeBook

# The run_analysis.R script collects mean and standrad deviation from an experiment where activity data has been collected using smartphones.
# The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

# The data has been collected from this link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# The data has been downloaded and unzipped to the folder 'UCI HAR Dataset' and is divided to 'test' and 'train' data. See all details in the README.txt fiule in the folder 'UCI HAR Dataset'.

# The data is downloaded and stored in variables (step 0) and then proceesed in five steps:

####################################################
### Step 0. Download data and store in variables ###
####################################################

# The data is downloaded from  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, stoed in folder 'data' and unzipped to folder 'UCI HAR Dataset'
if(!file.exists("data")){
        dir.create("data")
}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./data/mydata.zip")
unzip("mydata.zip")

# Variable names (features) are downloaded from the features.txt file. Column 1 is removed containing numbering.
features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
features <- features[,2]

# test data is downloaded from 'test' folder:
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
# test labels including type of activity performed is downloaded for test data:
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
# test subject indicating the person involved in the experiment is downloaed for test data:
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# train data is downloaded from 'train' folder:
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
# train labels including type of activity performed is downloaded for train data:
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
# test subject indicating the person involved in the experiment is downloaed for train data:
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Variable names are added to test and train data
names(test_data) = features
names(train_data) = features

# Labels and subject ia appended to test and train data, heading is removed.
test_data$activity <- test_labels[,1]
test_data$subject <- test_subject[,1]
train_data$activity <- train_labels[,1]
train_data$subject <- train_subject[,1]

############################################################################
### Step 1. Merge the training and the test sets to create one data set. ###
############################################################################
# test and train data is merged to table data
data <- rbind(test_data,train_data)

######################################################################################################
### Step 2. Extract only the measurements on the mean and standard deviation for each measurement. ###
######################################################################################################
# On top of subject and activity, only varaibles calculating mean and standard deviation (std) are selected from data table. Data is stored in data_new table.
data_new <- select(data,c(subject,activity,contains("mean"),contains("std")))
# Remove Angle variables
data_new <- select(data_new, !contains("angle"))

######################################################################################
### step 3. Use descriptive activity names to name the activities in the data set. ###
######################################################################################
# Replace activity coding with activity names in data_new table
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- activities[,2]
data_new$activity <- activities[data_new$activity]

##################################################################################
### Step 4. Appropriately labels the data set with descriptive variable names. ###
##################################################################################
# Variable names are changed to clear understandable names. Shortenings are spelled with full name.
names_new <- names(data_new)
names_new <- gsub("Freq","Frequency",names_new)
names_new <- gsub("Acc","Acceleration",names_new)
names_new <- gsub("std","StandardDeviation",names_new)
names_new <- gsub("^t","TimeDomain_",names_new)
names_new <- gsub("^f","FrequencyDomain_",names_new)
names(data_new) <- names_new

#############################################################################################################
### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ###
#############################################################################################################
# data is aggregated over subject and activity and mean is claculated. THe data is sored in tidy_data table. 
tidy_data <- aggregate(data_new[,3:81], by = list(subject = data_new$subject, activity = data_new$activity), FUN = mean)
# tidy_data table is exported as 'TidyData.txt'
write.table(tidy_data,"TidyData.txt")
