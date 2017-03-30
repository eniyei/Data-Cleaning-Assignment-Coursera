# The script run_analysis.R does the following:
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




# ====================================================================================================================



# Download and unzip the file:
urlzip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlzip, destfile = "./Dataset.zip" )
dir.create("./CourseraAP")
unzip("./Dataset.zip", exdir = "./CourseraAP" )




# ====================================================================================================================




# Load test data:
x_test <- read.table("./CourseraAP/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./CourseraAP/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./CourseraAP/UCI HAR Dataset/test/subject_test.txt")



# Load train data:
x_train <- read.table("./CourseraAP/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./CourseraAP/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./CourseraAP/UCI HAR Dataset/train/subject_train.txt")



# Load feature data:
features <- read.table('./CourseraAP/UCI HAR Dataset/features.txt')



# Load activity labels:
activityLabels <-  read.table('./CourseraAP/UCI HAR Dataset/activity_labels.txt')




# ====================================================================================================================




# Set column names for test data:

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"



# Set column names for train data:

colnames(x_train) <- features[,2] 
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"



# Set column names for activityLabels data:

colnames(activityLabels) <- c('activityId','activityType')




# ====================================================================================================================




# Merge data sets:

testDT <- cbind(y_test, subject_test, x_test)
trainDT <- cbind(y_train, subject_train, x_train)
mergedDT <- rbind(testDT, trainDT)




# ====================================================================================================================




# Get all column names:

columnNames <- colnames(mergedDT)



# Extracts the measurements on the mean and standard deviation from the columnNames vector:

extr_mean_std <- (grepl(".[Mm]ean.", columnNames) | grepl(".[Ss]td.", columnNames) | grepl("activityId", columnNames) | grepl("subjectId", columnNames))



# Create data frame with mean and sd columns:

mean_stdDT <- mergedDT[ , extr_mean_std == TRUE]



# Set/merge/ data frame with activity labels:

DTlabeled <- merge(mean_stdDT, activityLabels, by = "activityId")




# ====================================================================================================================




# Creates a second, independent tidy data set with the average of each variable for each activity and each subject:

tidyDT <- aggregate(. ~subjectId + activityId, DTlabeled, mean)
tidyDT <- tidyDT[order(tidyDT$subjectId, tidyDT$activityId),]

write.table(tidyDT, "./CourseraAP/tidyDT.txt", row.name = FALSE)

