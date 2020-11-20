library(dplyr)
stopifnot(grepl("(datasciencecoursera)$", getwd()))

train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

combined_train <- cbind(train_labels, train_subjects, train_data)
combined_test <- cbind(test_labels, test_subjects, test_data)

combined_data <- rbind(combined_test, combined_train)

feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names <- tolower(feature_names[,2])

names(combined_data) <- c("Activity", "Subject", feature_names)
names(combined_data) <- gsub("-", "_", names(combined_data))
names(combined_data) <- gsub("\\(\\)", "", names(combined_data))

mean_and_std_columns <- grep("(std)|((_mean$)|(_mean_))|(Activity)|(Subject)", 
                             names(combined_data),
                             value = TRUE)
combined_data <- combined_data[,mean_and_std_columns]

activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_names[,2] <- tolower(activity_names[,2])
combined_data$Activity <- activity_names[combined_data$Activity, 2]

setwd("cleaned_datasets/means_grouped_by_subject_and_activity/")
grouped_data <- group_by(combined_data, Activity, Subject)
summarize_each(grouped_data, mean)
write.csv(test, "test.csv")
