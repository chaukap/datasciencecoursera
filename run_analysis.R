train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names <- tolower(feature_names[,2])

names(test_data) <- feature_names
names(train_data) <- feature_names

combined_data <- rbind(test_data, train_data)

mean_and_std_columns <- grep("(std)|(-mean\\()", names(combined_data), value = TRUE)

combined_data <- combined_data[,mean_and_std_columns]
