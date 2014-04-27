run_analysis.R for UCI HAR Dataset analysis
========================================================

**run_analysis.R** assumes "/UCI HAR Dataset/*" folder is placed into working directory. UCI HAR Dataset has been obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

**run_analysis.R** combines training and test dataset together producing one cobined dataset with 10299 rows by 82 columns. It appends subjectID, activityID, and activityName columns to the measurement dataset so that each measurement can be tracked per subjectID+activityName.
It also extracts a limited set of variables that are of interest(mean and std). For description of variables please refer to features_info.txt and features.txt of UCI HAR Dataset folder.

### Steps

1) Read testDataSet by combining X_test, Y_Test, and Subject_test files AND reduce the number of measurements by only selecting
mean and std columns thereby producing 
```
str(testDataSet)
'data.frame':  2947 obs. of  81 variables:
 $ subjectID                      : Factor w/ 9 levels "2","4","9","10",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ activityID                     : Factor w/ 6 levels "1","2","3","4",..: 5 5 5 5 5 5 5 5 5 5 ...
 $ tBodyAcc.mean...X              : num  0.257 0.286 0.275 0.27 0.275 ...
 $ tBodyAcc.mean...Y              : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
 $ tBodyAcc.mean...Z              : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
```

2) Repeat Step1 for train subset to produce
```
'data.frame':  7352 obs. of  81 variables:
 $ subjectID                      : Factor w/ 21 levels "1","3","5","6",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ activityID                     : Factor w/ 6 levels "1","2","3","4",..: 5 5 5 5 5 5 5 5 5 5 ...
 $ tBodyAcc.mean...X              : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc.mean...Y              : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
```

3) Combine train and test data AND append activityName

4) Melt the dataset based on following ids
```
id_vars <- c("subjectID","activityID","activityName")
```
5) Reconstruct dataframe from molten data and group by SubjectID and ActivityName
```
tidy_dataset <- dcast(meltedSet, subjectID + activityName ~ variable, mean)
```
6) Save results into tidy.txt file
### Output produced

**run_analysis.R** produces a dataset of the following dimensions
```
str(tidy_dataset)
'data.frame':  180 obs. of  81 variables:
  $ subjectID                      : Factor w/ 30 levels "2","4","9","10",..: 1 1 1 1 1 1 2 2 2 2 ...
  $ activityName                   : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
  $ tBodyAcc.mean...X              : num  0.281 0.277 0.278 0.276 0.278 ...
```
Please check *tidy.txt* file for data

