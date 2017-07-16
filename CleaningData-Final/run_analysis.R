library(data.table)
library(dplyr)

# Download file
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp)
unlink(temp)

# Read data
trainX <- fread("UCI HAR Dataset/train/X_train.txt")
trainY <- fread("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- fread("UCI HAR Dataset/train/subject_train.txt")

testX <- fread("UCI HAR Dataset/test/X_test.txt")
testY <- fread("UCI HAR Dataset/test/y_test.txt")
testSubjects <- fread("UCI HAR Dataset/test/subject_test.txt")

# Read activity labels
labels <- fread("UCI HAR Dataset/activity_labels.txt")
activityLabels <- as.list(as.factor(labels$V2))
names(activityLabels) <-labels$V1


# Bind data together
X = rbind(trainX, testX)
y = rbind(trainY, testY)
subjects <- as.factor(rbind(trainSubjects, testSubjects)$V1)

# Set feature names
featureNames <- fread("UCI HAR Dataset/features.txt")$V2
names(X) <- featureNames

# add subject and activity columns to data set
X$subject <- subjects
X$activity <- sapply(y$V1, function(x) {activityLabels[[x]]})

# subset columns to contain only subject, activity, and mean and std of measurements
columns <- c('subject', 'activity', featureNames[grepl('mean|std', featureNames)])
print(columns) 
X <- X[,..columns]


# Find final data set, with averages of measurements per subject per activity
result <- X %>% group_by(subject, activity) %>% summarise_all(funs("mean"))
