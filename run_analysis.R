# The purpose of the R script is to generate tidy data set from folder 
# "UCI HAR Dataset" during the "Data Science: Getting and Cleaning Data" 
# on Coursera.

# Following criteria are reuired: 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
# measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.


# 1. Merge files
# read features.txt 
feat <- read.table("UCI\ HAR\ Dataset/features.txt", header = F)
feat <- as.character(feat[,2])

# 2. get features with mean() or std() from feature table
ms_grep <- grep(c("(mean\\(\\)|std\\(\\))"), feat)
# extract names with mean() or std()
feat_ms <- feat[ms_grep]

# read in training and test data sets
ts_x <- read.table("UCI\ HAR\ Dataset/test/X_test.txt", header = F)
ts_y <- read.table("UCI\ HAR\ Dataset/test/y_test.txt", header = F)
ts_sbj <-  read.table("UCI\ HAR\ Dataset/test/subject_test.txt", header = F)
tr_x <- read.table("UCI\ HAR\ Dataset/train/X_train.txt", header = F)
tr_y <- read.table("UCI\ HAR\ Dataset/train/y_train.txt", header = F)
tr_sbj <-  read.table("UCI\ HAR\ Dataset/train/subject_train.txt", header = F)

# 3. Uses descriptive activity names
# assign feastures to column names
colnames(ts_x) <- feat
colnames(tr_x) <- feat
colnames(ts_sbj) <- "subject"
colnames(tr_sbj) <- "subject"
colnames(ts_y) <- "activities"
colnames(tr_y) <- "activities"
ts_x_ms <- ts_x[, feat_ms]
tr_x_ms <- tr_x[, feat_ms]

# add variable for test or train
type <- rep("test", nrow(ts_x))
ts_x2 <- cbind(ts_sbj, type, ts_y, ts_x_ms)
type <- rep("train", nrow(tr_x))
tr_x2 <- cbind(tr_sbj, type, tr_y, tr_x_ms)
data_merge <- rbind(ts_x2, tr_x2)

# convert type column from factor to character
data_merge$type <- as.character(data_merge$type)

# save data frame
# dput(data_merge, file = "data_merge.R")
# data_merge <- dget("data_merge.R")

# Uses descriptive activity names to name the activities in the data set
dact <- read.table("UCI\ HAR\ Dataset/activity_labels.txt", header = F)
dact <- as.character(dact[,2])
act <- data_merge$activities

# create a act2 vector for descriptive activity names
act2 <- vector()
for(i in act){
        act2 <- c(act2, dact[i])
}

# replace the numeric names of activitiesa
data_merge$activities <- act2
head(data_merge)

# Create the data set with the average of each variable for each activity and each subject
library(data.table)
DT <- data.table(data_merge)
data <- DT[, lapply(.SD[, 1:66, with=F], mean), by=list(type, subject, activities)]
data[1:20]

# Convert the data table back to the data frame
data <- as.data.frame(data)

# 4. Appropriately labels the data set with descriptive variable names.
n <- names(data[4:length(names(data))])
n <- gsub("BodyBody", "body", n)
n <- gsub("Body", "body", n)
n <- gsub("tb", "time_b", n)
n <- gsub("tg", "time_g", n)
n <- gsub("fb", "fast_fourier_transform_b", n)
n <- gsub("Acc", "_acceleration", n)
n <- gsub("-", "_", n)
n <- gsub("\\(\\)", "", n)
n <- gsub("bodyGyro", "body_gyroscope", n)
n <- gsub("Mag", "_magnitude", n)
n <- gsub("Jerk", "_Jerk", n)
n <- gsub("std", "standard_deviation", n)

n <- c(names(data)[1:3], n)
names(data) <- n

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library("dplyr")
data_f <- group_by(data[, -2], subject, activities)
data_s <- summarise_each(data_f, funs(mean))

# Export to .txt file 
write.table(data_s, "tidy_data_set.txt", row.name=FALSE)

