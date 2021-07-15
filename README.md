This is the readme file for the peer graded assignment for Getting and Cleaning Data course project.

# Data
Data is collected from this link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
All details about the measurements are included in README.txt in downloaded data.

# Files
CodeBook.md
This file includes all steps taken from downloading the data to presenting a tidy data set written as a text file.

run_analysis.R
This script does the following:
- downloads and unzips the data.
- stores data in relevant variables.
- merges test and train data to same data table.
- extract omly mean and standard deviation measurements from collected data.
- changes activity coding to descriptive names.
- changes variable names to decsriptive names.
- creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- exports result as TidyData.txt


