# GettingAndCleaning
Coursera submission for the "Getting and Cleaning Data" course project

This repo includes the R program and Code Book for the Coursera "Getting and Cleaning" course project.

The objective of the project is to produce tidy data sets from a set of source data.  The source data represents experimental data obtained from wearable body sensors.

## Attribution

The source data was taken from the following publication:  
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Working Directory

In order to run the R program, you will need the Working Directory to contain the following files:
* The program **run_analysis.R**
* The source data. Unzip the downloaded source data and arrange it so that the root folder **UCI HAR Dataset** is in your working directory.

## The Code

### Source files

All the R code is in a single file, **run_analysis.R**.

### Libraries used

The program uses two libraries, **reshape** and **plyr**.  It's assumed that these libraries are already installed, but the code to install these is included (commented out) at the top of the program.  If you need to install either package, just uncomment the appropriate line(s).

### Explanation of the code

The data is split into two files, one for test data and the other for training data.  The program reads each of these files in turn.  The subject (i.e. the person being observed) and the activity (i.e. what they are doing during the obseervation) are actually stored in different files from the observations, so in each case the subject and activity for the observation has to be combined with the readings taken from the monitoring device.  This is done using the cbind function.

Once the test and training data have both been read in and tagged with "ubject" and "activity" columns, the two sets are concatenated to produce a single data frame, using the rbind function.

The next step is for the program to tidy up the columns by removing unwanted observations, and renaming the columns from the generic names ("V1", "V2", "V3" etc) to something more readable - generally improving the tidyness of the data.

Rather than hardcode this step, I made use of the features.txt file that is provided with the source data.  This lists the names of all the observations, and can be used to (a) filter out the columns that are required and (b) derive sensible column names.

The fields required are those that represent means and standard deviations.  My interpretation of the source data is that these are the 
