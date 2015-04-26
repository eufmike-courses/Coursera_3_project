##Data Science: Getting and Cleaning Data

The run_analysis.R is designed for the course project in Getting and Cleaning Data(Coursera). In the course, students are asked to clean the data set downloaded from the following url. 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

In the file, I performed the data set processing according to the following requirement: <br /> 

The R script called run_analysis.R that does the following.<br /> 
1. Merges the training and the test sets to create one data set.<br /> 
2. Extracts only the measurements on the mean and standard deviation for each measurement.<br />  
3. Uses descriptive activity names to name the activities in the data set.<br /> 
4. Appropriately labels the data set with descriptive variable names.<br /> 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. <br /> 

The results can be export to .txt file if the data set is properly saved in the working directory.  <br /> 

1. This file does not include downloading and unzip process. They need to be performed separately. <br /> 
2. Two packages, "data.table" and "dplyr", are required.  