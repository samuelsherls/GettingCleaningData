# Activity files
datest <- read.table("test/y_test.txt")
datrain <- read.table("train/y_train.txt")
 
#subject files
dstest <- read.table("test/subject_test.txt")
dstrain <- read.table("train/subject_train.txt")

#Features files
dftest <- read.table("test/X_test.txt")
dftrain <- read.table("train/X_train.txt")

#1.Merges the training and the test sets to create one data set.
ds <- rbind(dstrain, dstest)
da <- rbind(datrain, datest)
df <- rbind(dftrain, dftest)

names(ds) <- c("subject")
names(da) <- c("activity")
dfnames <- read.table("features.txt")
names(df) <- dfnames$V2


dc <- cbind(ds, da)
data <- cbind(df, dc)


#2.Extracts only the measurements on the mean and standard deviation for each measurement

sdataf <- dfnames$V2[grep("mean\\(\\)|std\\(\\)", dfnames$V2)]



selectN <- c(as.character(sdataf), "subject", "activity")
data <- subset(data, select = selectN)

#3.Uses descriptive activity names to name the activities in the data set

alabels <- read.table("activity_labels.txt")
data$activity <- alabels[data$activity,2]

#4.Appropriately labels the data set with descriptive variable names. 
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



library(plyr);
Data2<-aggregate(. ~subject + activity, data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
