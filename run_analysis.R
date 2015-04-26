
# Program uses the reshape and plyr packages.  If these need to be installed,
# uncomment the following two lines

#install.packages("reshape")
#install.packages("plyr")
library(reshape)
library(plyr)

# Load the test observations
testdata <- read.table("UCI HAR Dataset/test/X_test.txt")

# Load the subject identifier for each row, and give it a suitable column name ("subject")
subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects <- rename(subjects,c("V1"="subject"))

# Load the activity identifier for each row, and give it a suitable column name ("activity")
activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
activities <- rename(activities,c("V1"="activity"))

# Combine the subject identifier, activity identifier and test observations into a
# single data frame called "testdata" 
testdata <- cbind(subjects,activities,testdata)

# Load the training observations
traindata <- read.table("UCI HAR Dataset/train/X_train.txt")

# Load the subject identifier for each row, and give it a suitable column name ("subject")
subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjects <- rename(subjects,c("V1"="subject"))

# Load the activity identifier for each row, and give it a suitable column name ("activity")
activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
activities <- rename(activities,c("V1"="activity"))

# Combine the subject identifier, activity identifier and training observations into a
# single data frame called "traindata" 
traindata <- cbind(subjects,activities,traindata)

# Put the training data and test data into a single data frame called "basedata"
basedata <- rbind(testdata,traindata)

# Load the variable descriptions from the file "features.txt"
variablenamesframe <- read.table("UCI HAR Dataset/features.txt")

# We're only interested in the "mean" and "standard deviation" observations, so reduce
# the data frame that contains the variable descriptions to only include those that contain
# "mean()" or "std()"
variablenamesframe <- subset(variablenamesframe,regexpr("mean\\(\\)",V2)>0 | regexpr("std\\(\\)",V2)>0,extended=F)

# Map the row numbers to variable names that start with a "V"
variablenamesframe$V1 <- paste("V",sep="",variablenamesframe$V1)

# Tidy up the names of the variable descriptions
# Remove occurrences of "()" - this is illegal in R variable names anyway
variablenamesframe$V2 <- gsub("\\(\\)","",variablenamesframe$V2)
# Remove dashes
variablenamesframe$V2 <- gsub("-","",variablenamesframe$V2)
# Convert "mean" into "Mean".  This makes the names a bit more readable
variablenamesframe$V2 <- gsub("mean","Mean",variablenamesframe$V2)
# Convert "std" into "Std".  This makes the names a bit more readable
variablenamesframe$V2 <- gsub("std","Std",variablenamesframe$V2)
# Some variable names are inconsistent and include the string "BodyBody" when they ought
# to be just "Body", so fix those too
variablenamesframe$V2 <- gsub("BodyBody","Body",variablenamesframe$V2)

# Reduce the data frame by only including the fields "subject", "activity", and the
# observations that correspond to means and standard deviations
basedatawithvariablenames <- basedata[c(c("subject","activity"),variablenamesframe[,1])]

# Change the column names to something meaningful
names(basedatawithvariablenames) <- c(c("subject","activity"),variablenamesframe[,2])

# Convert the activity codes to names with a merge
activitynames <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity","activityName"))
alldata <- merge(basedatawithvariablenames,activitynames)

# Reorder the columns to bring the activity description to the front, and drop the numeric activity identifier
alldata <- alldata[,c(ncol(alldata),2:(ncol(alldata)-1))]

# Calculate the means by activity name and subject
means <- aggregate(alldata[, 3:ncol(alldata)], list(activityname=alldata$activityName,subject=alldata$subject), mean)

# write out the table to a txt file
write.table(means,file="means.txt",row.names=F)
