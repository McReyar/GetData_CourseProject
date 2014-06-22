##############################################
##                                          ##
## Getting and Cleaning Data                ##
## https://class.coursera.org/getdata-004   ##
##                                          ##
## Course Project                           ##   
##                                          ##
## author: McReyar                          ##
##                                          ##
##############################################
library(reshape2)
library(stringr)

## Download files if necessary
if(!file.exists("UCI HAR Dataset")) {
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
    unzip(temp)
unlink(temp); rm(temp)   
}

## import features
features <- read.table("UCI HAR Dataset/features.txt", comment.char = ""
                      ,colClasses = c("NULL","character"), col.names  = c(NA,"name"))
features$class <- ifelse(grepl("\\-(mean|std)\\(\\)",features$name),"numeric","NULL")
features$name  <- gsub("\\W|_","",features$name)

##  (1) Merge the training and the test sets
signals <- rbind(
    ## (2) Read only the measurements on the mean and standard deviation
    read.table("UCI HAR Dataset/train/X_train.txt", comment.char = ""
               ,colClasses = features$class, col.names  = features$name)
   ,read.table("UCI HAR Dataset/test/X_test.txt"  , comment.char = ""
               ,colClasses = features$class, col.names  = features$name)
)
signalsSubject <- rbind(
    read.table("UCI HAR Dataset/train/subject_train.txt", comment.char = ""
              ,colClasses = "integer", col.names  = "subject")
   ,read.table("UCI HAR Dataset/test/subject_test.txt"  , comment.char = ""
              ,colClasses = "integer", col.names  = "subject")
)
signalsActivity <- rbind(
    read.table("UCI HAR Dataset/train/y_train.txt", comment.char = ""
              ,colClasses = "integer", col.names  = "activity")
   ,read.table("UCI HAR Dataset/test/y_test.txt"  , comment.char = ""
              ,colClasses = "integer", col.names  = "activity")
)
signals <- cbind(signalsSubject, signalsActivity, signals)

## (3) Use descriptive activity names (factor labels)
activities <- read.table("UCI HAR Dataset/activity_labels.txt"
                        ,colClasses = c("integer","character")
                        ,col.names  = c("code","name")
                        ,comment.char = ""
)
signals$activity <- factor(signals$activity
                          ,levels = activities$code
                          ,labels = tolower(activities$name)
                          )
narrow <- melt(signals, id = c("subject", "activity"))
rm(list = c("signalsActivity", "signalsSubject", "features", "activities", "signals"))

## (4) label the data set with descriptive variable names
narrow$domain    <- as.factor(ifelse(grepl("^t",   narrow$variable), "Time", "Frequency"))
narrow$source    <- as.factor(ifelse(grepl("Body", narrow$variable), "Body", "Gravity"))
narrow$sensor    <- as.factor(ifelse(grepl("Acc",  narrow$variable), "Accelerometer", "Gyroscope"))
narrow$jerk      <- as.factor(ifelse(grepl("Jerk", narrow$variable), "yes", "no"))
narrow$axis      <- str_extract(narrow$variable,"(X|Y|Z)$|Mag")
narrow$axis      <- factor(narrow$axis, levels = c("X","Y","Z","Mag")
                           ,labels = c("X","Y","Z","Magnitude"))
narrow$statistic <- str_extract(narrow$variable,"(mean|std)")
narrow$statistic <- factor(narrow$statistic, levels = c("mean","std")
                           ,labels = c("mean","standarddeviation"))
narrow$variable <- NULL

# (5) Create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
tidy <- dcast(narrow, ... ~ statistic, mean)
write.table(tidy, file="meanHARUSD.txt", sep = "\t", row.names = FALSE, quote = FALSE)