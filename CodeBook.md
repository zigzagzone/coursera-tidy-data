# Code Book
The file `run_analysis.R` will create the output file name `tidy_data.txt` which is the result from Getting and Cleaning data assignment. The code do the following step.

### Preparation
Before start make sure the library dplyr and downloader is loaded. When run the function `makeTidyData()` in `run_analysis.R` it will download a zipfile and extract to folder `UCI HAR Dataset` and contain necessary files below:

features.txt: uses the data features.
activity_labels.txt: an activities include 6 values : WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
subject_train.txt - uses the data train subjects. Values range from 1 - 30
X_train.txt - uses the data trainX.
y_train.txt - uses the data trainY.
subject_test.txt -uses the data test subjects. Values range from 1 - 30
X_test.txt - uses the data testX.
y_test.txt - uses the data testY.

### 1. Merges the training and the test sets to create one data set.
I read all data from test files "test/subject_test.txt", "test/X_test.txt", "test/y_test.txt"
and the train files "train/subject_train.txt", "train/X_train.txt", "train/y_train.txt"
and using `rbind` to create combined_subject, combined_label, combined_data
  
finally conbind subject, label, data together using `cbind`

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
I read features from file "features.txt" and then search for column contain only string '-mean()' and '-std()' using `grep` and filter that column.

### 3. Uses descriptive activity names to name the activities in the data set
I read activities from file "activity_labels.txt" to get factor from activity_labels and replace the value with the data from activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

### 4. Appropriately labels the data set with descriptive variable names.
I rename the 1st column to `subject` as it represent the subject to the data. Rename the 2nd column to activity to show the activity, then rename the rest of the column according to the features data from step #2.

### 5. Creates a tidy data set with the average of each variable for each activity and each subject.
I use `group_by` and `summarise_all` of dplyr library, 1st use `group_by` to group data according to subject and activity, the use `summarise_all` with the mean function to find the mean of each activity and each subject. Than use `write.table` to write the final tidy data output to file name `tidy_data.txt`, the script is completed.
