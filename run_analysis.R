library(data.table)
library(dplyr)

# Download data file and store it in "data" directory, unzip file
if(!file.exists("data")){
        dir.create("data")
}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./data/mydata.zip")
unzip("mydata.zip")

# Download variable names (features), remove numbering
features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
features <- features[,2]

# Store training and test data/labels in tables 
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Add variable names to test and training data
names(test_data) = features
names(train_data) = features

# Append labels and subject to test and training data
test_data$activity <- test_labels[,1]
test_data$subject <- test_subject[,1]
train_data$activity <- train_labels[,1]
train_data$subject <- train_subject[,1]

#### 1. Merge the training and the test sets to create one data set.
data <- rbind(test_data,train_data)

### 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# Select relevant variables, Put "subject" and "label" first in table.
data_new <- select(data,c(subject,activity,contains("mean"),contains("std")))
# Remove Angle variables
data_new <- select(data_new, !contains("angle"))

### 3. Use descriptive activity names to name the activities in the data set.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- activities[,2]
data_new$activity <- activities[data_new$activity]

### 4. Appropriately labels the data set with descriptive variable names. 
names_new <- names(data_new)
names_new <- gsub("Freq","Frequency",names_new)
names_new <- gsub("Acc","Acceleration",names_new)
names_new <- gsub("std","StandardDeviation",names_new)
names_new <- gsub("^t","TimeDomain_",names_new)
names_new <- gsub("^f","FrequencyDomain_",names_new)
names(data_new) <- names_new

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(data_new[,3:81], by = list(subject = data_new$subject, activity = data_new$activity), FUN = mean)
write.table(tidy_data,"TidyData.txt")

