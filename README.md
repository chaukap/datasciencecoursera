# datasciencecoursera

This repository contains 3 items:
1) The original UCI HAR data set 
2) The script used to clean the data set
3) The cleaned data sets.

## Original data
The original data comes from an experiment conducted with a group of 30 individuals between the ages of 19 and 48. Each subject performed six actions, walking, walking upstairs, walking downstairs, sitting, standing and laying, while wearing a Samsung Galaxy S II smartphone on their waste. Data was 
collected using the embedded accelerometer and gyroscope. 

## Cleaning script
The cleaning script performs 5 tasks:
1) Merges the test and training sets back into a single data set.
2) Extracts only the measurements on mean and standard deviation.
3) Replaces the activity numbers with descriptive strings.
4) Labels the data set columns with descriptive names.
5) Creates a separate data set containing the columns means for the data grouped by activity and subject.

See CodeBook.md for a full description of the code.

## Cleaned datasets
`clean_dataset.csv` contains the cleaned data set created by running steps 1-4 of the cleaning script.

`averages_for_each_subject_and_activity.csv` contains the column averages for each column grouped by activity and subject.

See CodeBook.md for a full description of the cleaned data.


