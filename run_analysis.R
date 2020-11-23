library(dplyr)

# Load the test and training sets.
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Read the subject values for both data sets.
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read the labels for both data sets.
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Bind the labels, subjects, and data.
combined_train <- cbind(train_labels, train_subjects, train_data)
combined_test <- cbind(test_labels, test_subjects, test_data)

# Bind the test and training sets.
combined_data <- rbind(combined_test, combined_train)

# Read in the feature names.
feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names <- tolower(feature_names[,2])

# Add the feature names to the data set, then sanitize the names.
names(combined_data) <- c("Activity", "Subject", feature_names)
names(combined_data) <- gsub("-", "_", names(combined_data))
names(combined_data) <- gsub("\\(\\)", "", names(combined_data))

# Filter down to the the mean and standard deviation columns 
# (and Activity and Subject of course).
mean_and_std_columns <- grep("(std)|((_mean$)|(_mean_))|(Activity)|(Subject)", 
                             names(combined_data),
                             value = TRUE)
combined_data <- combined_data[,mean_and_std_columns]

# Map the activity names (sitting, laying, etc.) to their numbers (1, 2 etc.)
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_names[,2] <- tolower(activity_names[,2])
combined_data$Activity <- activity_names[combined_data$Activity, 2]

# Group the data by Activity then Subject and get mean by column
grouped_data <- group_by(combined_data, Activity, Subject)
averaged_by_groups <- summarize_each(grouped_data, mean)

# write the clean data sets.
setwd("cleaned_datasets/")
write.csv(combined_data, "clean_dataset.csv", row.names = FALSE)
write.csv(averaged_by_groups,
          "averages_for_each_subject_and_activity.csv",
          row.names = FALSE)
setwd("../")