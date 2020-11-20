train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

combined_train <- cbind(train_data, train_labels, train_subjects)
combined_test <- cbind(test_data, test_labels, test_subjects)

combined_data <- rbind(combined_test, combined_train)

feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names <- tolower(feature_names[,2])

names(combined_data) <- c(feature_names, "Activity", "Subject")

mean_and_std_columns <- grep("(std)|(-mean\\()|(Activity)|(Subject)", 
                             names(combined_data),
                             value = TRUE)

combined_data <- combined_data[,mean_and_std_columns]

activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
combined_data$Activity <- activity_names[combined_data$Activity, 2]

