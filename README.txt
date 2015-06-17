README
This is the README file for the program run_analysis.R.  The purpose of this program is to load, clean, select from and manipulate a more raw form of the data which is contained within the following files:

TEST DATA FILES:
subject_test.txt
X_test.txt
y_test.txt

TRAINING DATA FILES:
subject_train.txt
X_train.txt
y_train.txt

SPECIAL NOTE: Before discussing the process of creating a tidy data set from the more raw form of the data using the run_analysis.R program, please note that the read.table statements within the program reflect the fact that the data to be accessed with the run_analysis.R program are in subfolders of the folder containing the run_analysis.R program.  Namely, the aforementioned data files are located within the following subdirectories on the system of origin of the run_analysis.R program:

TEST DATA FILES:
subject_test.txt in subdirectory: /proj_data/UCIHARDataset/test/
X_test.txt in subdirectory: /test/
y_test.txt in subdirectory: /test/

TRAINING DATA FILES:
subject_train.txt in subdirectory: /train/
X_train.txt in subdirectory: /train/
y_train.txt in subdirectory: /train/

As a result, if you plan on running run_analysis.R on a different system, please be sure to adjust the paths to the files listed in the read.table commands before attempting to run the program.  


ALGORITHM:
Below are the steps taken in order to convert the data provided in the files listed above into a tidy data set which is stored in a file named "measurementMeansByActivitySubject.txt" in the working directory.  

1. Read the subject_test.txt data into a data frame named subjecttestdf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA" and set the column name to "subject".
2. Read the y_test.txt data into a data frame named activitylabelstestdf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA" and set the column name to "activitylabel".
3. Read the activity_labels.txt data into a data frame named labelsdf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA", colClasses to integer and character, respectively, and set the column names to "labelnumber" and "labelname", respectively.  The data in this data frame will be used to replace the numeric value for activity in the activitylabelstestdf and activitylabelstraindf dataframes to a character value with a descriptive name for the activity.
4. Process the labelnames column of the labelsdf data frame in order to eliminate underscores and change the letters from upper case to lower case.  
5. Use a for-loop in order to replace the number values within the activitylabelstestdf data frame with the correlating descriptive names just developed in the labelnames column of the labelsdf data frame.
6. Read the X_test.txt data into a data frame named measurementstestdf making sure to set the header attribute to FALSE and set any missing data or NA's to the value of "NA".
7. Read the features.txt data into a data frame named variablenamesdf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA", colClasses to integer and character, respectively, and set the column names to "columnnumber" and "columnname", respectively.  The data in this data frame will be used to determine which measurements to keep from the measurementstestdf dataframe.  
8. Search the columnname vector within the variablenamesdf data frame in order to determine which variables contain either the string "mean" and which contain the string "std" within them.  Concatenate the resulting vectors, sort the new vector and assign it to a vector named columnnumbers.
9. Extract only the columns listed in the new columnnumbers vector from the measurementstestdf data frame and reassign this new data frame to measurementstestdf.
10. Now, extract only the column names correlating to the column numbers in the columnnumbers vector from the columnname column of the variablenamesdf data frame and assign this vector of names to a new vector named columnnames.  Use the gsub function to eliminate dashes and parentheses within the column names within the columnnames vector. Use the tolower function to change the column names to all lower case letters.  Finally, use the colnames function to reset the column names of the measurementstestdf data frame to the new column names within the columnnames vector.
11. Use the cbind function to bind the subjecttestdf and activitylabelstestdf to the front of the measurementstestdf data frame.
12. Read the subject_train.txt data into a data frame named subjecttraindf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA" and set the column name to "subject".
13. Read the y_train.txt data into a data frame named activitylabelstraindf making sure to set the header attribute to FALSE, set any missing data or NA's to the value of "NA" and set the column name to "activitylabel".
14. Use a for-loop in order to replace the number values within the activitylabelstraindf data frame with the correlating descriptive names developed in the labelnames column of the labelsdf data frame.
15. Read the X_train.txt data into a data frame named measurementstraindf making sure to set the header attribute to FALSE and set any missing data or NA's to the value of "NA".
16. Extract only the columns listed in the columnnumbers vector from the measurementstraindf data frame and reassign this new data frame to measurementstraindf.
17. Use the colnames function to reset the column names of the measurementstraindf data frame to the column names within the columnnames vector.
18. Use the cbind function to bind the subjecttraindf and activitylabelstraindf to the front of the measurementstraindf data frame.
19. Use the rbind function to bind the measurementstestdf data frame to the measurementstraindf data frame.  This basically appends the measurementstraindf dataframe to the end of the measurementstestdf data frame in order to create a merged data frame named measurementsdf.  The reason we can use rbind for this task is that the data in measurementstestdf and measurementstraindf are mutually exclusive: there is not "foreign key", so to speak, so there is no efficient way to "merge" other than duplicated most (if not all) columns.  rbind was chosen because it creates a data set which is much more intuitive and friendly for the end user.
20. Now that we have selected, cleaned and manipulated the data, and have placed it in a new data frame called measurementsdf, we can remove all the intermediary data frames and vectors used in order to create this more amenable data frame.  Therefore, in this step, we use the rm function in order to remove the following data frames and vectors: subjecttestdf, subjecttraindf, activitylabelstestdf, activitylabelstraindf, measurementstestdf, measurementstraindf, variablenamesdf, meancolumnnumbers, stdcolumnnumbers, columnnumbers, columnnames, labelsdf.
21. Create a new independent, tidy data set with the average of each variable for each activity and eact subject.  For this step, we chose to use the dplyr package.  From the dplyr package,  the group_by function was used to group the measurementsdf data frame by first, activitylabel and then subject.  Next in the chain, the summarise_each function was used in order to calculate the mean of each variable according the the groupings set in the last step of the chain.  The result was then assigned to a new data frame named meansofmeasurementsbyactivitysubjectdf.
22. Lastly, the write.table function was used in order to write the meansofmeasurmentsbyactivitysubjectdf data frame to a new text file named "measurementMeansByActivitySubject.txt" within the working directory.








