Course Project [Getting and Cleaning Data](https://class.coursera.org/getdata-004)
=========

Author: McReyar  
Creation Date: 06/22/2014

Documentation:
---------
* README.md (this document)
* [Codebook.md](https://github.com/McReyar/GetData_CourseProject/blob/master/Codebook.md)
* [run_analyis.R](https://github.com/McReyar/GetData_CourseProject/blob/master/run_analysis.md): Program Code


Description [run_analyis.R](https://github.com/McReyar/GetData_CourseProject/blob/master/run_analysis.md)
---------
**Requirements**  
following packages have to be installed:
* reshape2 
* stringr  

```
install.packages("reshap2")
install.packages("stringr")
```
To clean the data, following steps are executed in [run_analyis.R](https://github.com/McReyar/GetData_CourseProject/blob/master/run_analysis.md)


1. Download and unzip the data, if they are not in the current folder
2. Read features.txt
  * add column class - numeric for all features with "-mean()"" or "-std()" in its name - NULL for all others
  * remove all non-alphanumeric characters from feature-names
3. Read relevant columns from X-train.txt and X-test.txt (by using the column class as described in step 2) and merge them
4. Read user (subject_train.txt and subject_test.txt) and activity (y_train.txt and y_test.txt) and add those columns.
5. Read activity_labels.txt and add descriptive factor levels to dataset
6. Melt the dataset, to get a narrow dataset and add columns domain, source, sensor, jerk, axis and statistic based on the original feature names
7. Summarize dataset to get the mean of the original mean and standard-deviation-features for each user, activity, domain, source, sensor, jerk and axis
8. write resulting tidy dataset to tab-separated text-file

The dataset can be read into r with following command:

```
harusd <- read.table("meanHARUSD.txt", header = TRUE, sep = "\t")
```