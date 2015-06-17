## Author: Aimee Cardenas
## Class: Getting and Cleaning Data offered by Johns Hopkins University through Coursera
## Assignment: Course Project

## Note:  The data files are in subfolders underneath the folder in which the script is 
## located.  Because of this, if you plan on running this code on your system, you will
## need to adjust the paths below to reflect the correct paths to the data on your system.


## READ THE DATA INTO DATA FRAMES.
# TEST DATA: Read test subjects data.
subjecttestdf <- read.table("./test/subject_test.txt", 
                              header = FALSE, col.names = c("subject"), 
                              na.strings = "NA")
# Read test activity labels data.
activitylabelstestdf <- read.table("./test/y_test.txt", 
                              header = FALSE, col.names = c("activitylabel"), 
                              na.strings = "NA")

# Read data from "activity_labels.txt" so that we can replace the numbers
# in the activitylabelstestdf and activitylabelstraindf with descriptive names.
labelsdf <- read.table("activity_labels.txt", 
                              header = FALSE, na.strings = "NA", 
                              col.names = c("labelnumber", "labelname"), 
                              colClasses = c("integer", "character"))

# Process labelsdf$labelname to get rid of underscores.  Also, change the names to all 
# lower case.
labelsdf$labelname <- gsub("_", "", labelsdf$labelname)
labelsdf$labelname <- tolower(labelsdf$labelname)

# Replace the numbers in activitylabelstestdf with the descriptive names from labelsdf.
for(i in labelsdf$labelnumber) {
  activitylabelstestdf$activitylabel[activitylabelstestdf$activitylabel == i] <- labelsdf[i,2]
}

# Read the test measurements data.
measurementstestdf <- read.table("./test/x_test.txt", 
                                      header = FALSE, na.strings = "NA")

# Read data from "features.txt" in order to determine which measurement to keep from 
# measurementstestdf data frame, namely, only those which have a label containing the 
# strings "mean" or "std".
variablenamesdf <- read.table("features.txt", 
                              header = FALSE, na.strings = "NA", 
                              col.names = c("columnumber", "columnname"), 
                              colClasses = c("integer", "character"))

# Search variablenamesdf$columnname to see which ones contain either the string
# "mean" or the string "std".  Then, concatenate and sort these column numbers.
meancolumnnumbers <- grep("mean", variablenamesdf$columnname)
stdcolumnnumbers <- grep("std", variablenamesdf$columnname)
columnnumbers <- sort(c(meancolumnnumbers, stdcolumnnumbers))

# Extract just the columns from measurementstestdf that we want according to 
# columnnumbers.
measurementstestdf <- measurementstestdf[columnnumbers]

# Now, extract just the column names that you want according to the column numbers
# we just determined.  Then, process this vector to get rid of extraneous 
# characters such as the dash and parentheses.  Also, change all characters to 
# lower case characters.  Finally, rename the columns of the measurementstestdf
# with these new names.
columnnames <- variablenamesdf$columnname[columnnumbers]
columnnames <- gsub("-", "", columnnames)
columnnames <- gsub("\\(", "", columnnames)
columnnames <- gsub("\\)", "", columnnames)
columnnames <- tolower(columnnames)
colnames(measurementstestdf) <- columnnames

# Bind the subject and activity labels dfs to the front of measurementstestdf.
measurementstestdf <- cbind (subjecttestdf, activitylabelstestdf, measurementstestdf)



# TRAINING DATA: Read training subjects data.
subjecttraindf <- read.table("./train/subject_train.txt", 
                            header = FALSE, col.names = c("subject"), 
                            na.strings = "NA")
# Read train activity labels data.
activitylabelstraindf <- read.table("./train/y_train.txt", 
                                   header = FALSE, col.names = c("activitylabel"), 
                                   na.strings = "NA")

# Replace the numbers in activitylabelstraindf with the descriptive names from labelsdf.
for(i in labelsdf$labelnumber) {
  activitylabelstraindf$activitylabel[activitylabelstraindf$activitylabel == i] <- labelsdf[i,2]
}

# Read the test measurements data.
measurementstraindf <- read.table("./train/x_train.txt", 
                                 header = FALSE, na.strings = "NA")

# Extract just the columns from measurementstraindf that we want according to 
# columnnumbers.
measurementstraindf <- measurementstraindf[columnnumbers]

# Rename the columns of the measurementstraindf with these new names.
colnames(measurementstraindf) <- columnnames

# Bind the subject and activity labels dfs to the front of measurementstraindf.
measurementstraindf <- cbind (subjecttraindf, activitylabelstraindf, measurementstraindf)



## MERGE THE DATA.  Since the records of the data are all mutually exclusive, rbind is being
## used to "merge" the data.  
measurementsdf <- rbind(measurementstestdf, measurementstraindf)

# Remove old variables from workspace in order to operate more efficiently.
rm(subjecttestdf, subjecttraindf, activitylabelstestdf, activitylabelstraindf, 
   measurementstestdf, measurementstraindf, variablenamesdf, meancolumnnumbers,
   stdcolumnnumbers, columnnumbers, columnnames, labelsdf)



## Create a new independent, tidy data set with the average of each variable for
## each activity and each subject.
library(dplyr)
meansofmeasurementsbyactivitysubjectdf <- measurementsdf %>% 
  group_by(activitylabel, subject) %>% summarise_each(funs(mean))

# Write the new tidy data set to a file.
write.table(meansofmeasurementsbyactivitysubjectdf, 
            file = "measurementMeansByActivitySubject.txt",
            row.name = FALSE)