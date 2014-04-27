

# getDataSetFor function produces a complete dataframe for "set=" subset of data with reduced set of 
# measurements (78 out of 561) AND subjectID and activityID columns added
getDataSetFor <- function(set="test"){
  fileFeatures <- "UCI HAR Dataset/features.txt"
  DFfeatures <- read.table(fileFeatures,col.names = c("measureID","measureName"))
  
  fileX <- sprintf("UCI HAR Dataset/%s/X_%s.txt",set,set)
  fileY <- sprintf("UCI HAR Dataset/%s/Y_%s.txt",set,set)
  fileSubject <- sprintf("UCI HAR Dataset/%s/subject_%s.txt",set,set) 
  
  DFx <- read.table(fileX,col.names=DFfeatures$measureName)
  shortenDFx <- DFx[grep(pattern="mean|std",names(DFx))]
  
  DFy <- read.table(fileY,col.names = c("activityID"))
  
  DFsubject <- read.table(fileSubject, col.names = c("subjectID"))
  
  res <- cbind(subjectID = as.factor(DFsubject$subjectID), activityID = as.factor(DFy$activityID) , shortenDFx)
  
  res
}

# reads UCI HAR Dataset folder, produces one combined dataset of train & test data,
# aggregates mean and std measurements per each subject per activity 
# and saves the result into tidy.txt file
run_analysis <- function () {
  
  print("...generating TEST dataset...")
  testDataSet <- getDataSetFor(set="test")
  #print(dim(testDataSet)) yields: [1] 2947   81
  
  print("...generating TRAIN dataset...")
  trainDataSet <- getDataSetFor(set="train")
  #print(dim(trainDataSet)) yields: [1] 7352    81
  
  print("...combining two datasets into one...")
  result <- rbind(testDataSet,trainDataSet)
  #print(dim(result)) yields: [1] 10299    81
  
  print("...reading activity descriptions...")
  fileLabels <- "UCI HAR Dataset/activity_labels.txt"
  activity_labels <- read.table(fileLabels,col.names=c("activityID","activityName"))
  
  print("...adding activityNames to the dataset...")
  # merge on activityID column to produce 10299x82 dataset with activityName
  result <- merge(result,activity_labels)
  
  print("...aggregate measurements by subject and for each activity...")
  # melt the dataset by 3 ids
  id_vars <- c("subjectID","activityID","activityName")
  meltedSet <- melt(result,id.vars=id_vars)
  
  # reconstruct dataframe grouping by subjectID + activityName group
  tidy_dataset <- dcast(meltedSet, subjectID + activityName ~ variable, mean)
  
  #str(tidy_dataset)
  # 'data.frame':  180 obs. of  81 variables:
  #   $ subjectID                      : Factor w/ 30 levels "2","4","9","10",..: 1 1 1 1 1 1 2 2 2 2 ...
  #   $ activityName                   : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
  #   $ tBodyAcc.mean...X              : num  0.281 0.277 0.278 0.276 0.278 ...
  
  print("...Saving result into tidy.txt....")
  write.table(tidy_dataset,"tidy.txt",sep=",",col.names=TRUE,row.names=FALSE)
}

print("The script assumes UCI HAR Dataset folder is placed into working directory.")
print("Please refer to CodeBook.md for description")
print("Running analysis....")
run_analysis()
print("Done. Please check tidy.txt file for results")