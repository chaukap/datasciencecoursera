# Codebook

## Description

This code book describes the `run_analysis.R` script in this repository. It requires that the `UCI HAR Dataset` and `cleaned_datasets` directories be 
be presents in the working directory. The script performs the following tasks as described in the assignment (but not necessarily in the same order):


1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Dependencies

`run_analysis.R` requires the dplyr R package and all of it's dependencies.

## Load the data

`run_analysis.R` first loads the data, subjects, and labels
```
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
```

## Combine the data (step 1)

Next, it binds the subjects and labels to the data:
```
combined_train <- cbind(train_labels, train_subjects, train_data)
combined_test <- cbind(test_labels, test_subjects, test_data)
```
Then it binds the test set and the training sets.
```
combined_data <- rbind(combined_test, combined_train)
```

## Name the columns (step 4)

Feature names are stored in a separate table. Read that table and ensure everything is lowercase, for consistency.
```
feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names <- tolower(feature_names[,2])
```
Add the Activity and Subject column headers, then remove any strange characters.
```
names(combined_data) <- c("Activity", "Subject", feature_names)
names(combined_data) <- gsub("-", "_", names(combined_data))
names(combined_data) <- gsub("\\(\\)", "", names(combined_data))
```

## Keep only the mean and std measurements (step 2)

Select the columns using their naming conventions. In this case, grab ony the columns that contain "std", end in "_mean", contain "_mean_", or are the Activity or Subject columns.
```
mean_and_std_columns <- grep("(std)|((_mean$)|(_mean_))|(Activity)|(Subject)",
                             names(combined_data),
                             value = TRUE)
combined_data <- combined_data[,mean_and_std_columns]
```

## Use descriptive activity names (step 3)

The `activity_labels.txt` table contains a mapping from numbers to activity strings. We'll use that to give our data descriptive values.
```
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_names[,2] <- tolower(activity_names[,2])
combined_data$Activity <- activity_names[combined_data$Activity, 2]
```

## Create a separate table of means grouped by activity and subject (step 5)

Finally, group the data and use the dplyr function summarize_each to get the column means for each activity and subject.
```
grouped_data <- group_by(combined_data, Activity, Subject)
averaged_by_groups <- summarize_each(grouped_data, mean)
```

## Print the data to CSVs.

```
setwd("cleaned_datasets/")
write.csv(combined_data, "clean_dataset.csv", row.names = FALSE)
write.csv(averaged_by_groups,
          "averages_for_each_subject_and_activity.csv",
          row.names = FALSE)
setwd("../")
```
