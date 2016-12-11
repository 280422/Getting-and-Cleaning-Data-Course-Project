library(plyr)

# Read measurements, activity labels, and subject labels for test & train observations
testData <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses = "numeric")
testLables <- read.table("UCI HAR Dataset/test/y_test.txt", colClasses = "integer")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", colClasses = "integer")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric")
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt", colClasses = "integer")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", colClasses = "integer")

# Read descriptive names for activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
featureLables <- read.table("UCI HAR Dataset/features.txt")

# Replace variable names with feature labels
names(testData) <- featureLables$V2
names(trainData) <- featureLables$V2

# Add activity labels and subject id as new variables to datasets
testData$Activity <- factor(testLables$V1, levels=activityLabels$V1, labels=activityLabels$V2)
testData$Subject <- testSubjects$V1
trainData$Activity <- factor(trainLabels$V1, levels=activityLabels$V1, labels=activityLabels$V2)
trainData$Subject <- trainSubjects$V1

# Merge datasets
mergedData <- rbind(trainData, testData)

# Find which columns in the data frame have "std()" or "mean()" in their variable names
# (produces integer vector). Also spare Activity and Subject columns that we added before.
columnsFilter <- grep("std\\()|mean\\()|^Activity$|^Subject$", names(mergedData))

# Keep only wanted columns
CleanData <- mergedData[, columnsFilter]

# Create tidy data set with only means (data grouped by Subject and Activity)
meanData <- ddply(CleanData, c("Subject", "Activity"), numcolwise(mean))

# Write data file
write.table(meanData, "tidyData.txt", row.names=FALSE)