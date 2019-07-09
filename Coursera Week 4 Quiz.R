library(dplyr)
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileUrl, destfile = "./SmartphoneSourceData.zip")
unzip("./SmartphoneSourceData.zip")
features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("ActivityID", "Activity")
Training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
Training_ActivityLabels<- read.table("./UCI HAR Dataset/train/y_train.txt")
Training_subjects <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
Test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
Test_Activitylabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
Test_subjects <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
MergeData <- rbind(Training_set, Test_set)
MergeActivity <- rbind(Training_ActivityLabels, Test_Activitylabels)
MergeSubjects <- rbind(Training_subjects, Test_subjects)
colnames(MergeData) <- features[,2]
colnames(MergeActivity) <- "ActivityID"
colnames(MergeSubjects) <- "SubjectID"
Merged_set_wlabels <- cbind(MergeSubjects, MergeActivity, MergeData)
SelectedColumns <- grepl("*mean\\(\\)|*std\\(\\)|ActivityID|SubjectID", names(Merged_set_wlabels))
SelectedData <- Merged_set_wlabels[ , SelectedColumns]
LabelledData <- merge(SelectedData, activity, by="ActivityID") 
LabelledData <- LabelledData[, c(2,ncol(LabelledData), 3:(ncol(LabelledData)-1))]
TidyData <- aggregate(.~SubjectID+Activity, LabelledData, mean)
TidyData <- arrange(TidyData, SubjectID)
write.table(TidyData, "TidyData.txt", row.names = FALSE, quote = FALSE)
str(TidyData)
