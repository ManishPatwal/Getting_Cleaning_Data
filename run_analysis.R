# Merge the dataset
#Training and Test dataset to create new dataset
#Extract only the measurements on the mean and standard deviation for each measurement.
#Use descriptive activity name to name the activites in the dataset
#Appropiately labels the data set with descriptive variable name
# From the dataset in step 4. 
#Create a second, independent tidy set with the average of each variable for each acgivity and each subject.

# Setworking directory

setwd("C:/Users/manis/Desktop/Coursera/03_Getting_and_Cleaning_Data")
getwd()

# Download the file and create folder in current directory.
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile ="./data/Dataset.zip")
list.files()
#Unzip the file
zipF<- "C:/Users/manis/Desktop/Coursera/03_Getting_and_Cleaning_Data/data/Dataset.zip"
outDir<-"C:/Users/manis/Desktop/Coursera/03_Getting_and_Cleaning_Data/data"
unzip(zipF,exdir=outDir)
# Read the training dataset
#View the files in dataset folder
list.files("C:/Users/manis/Desktop/Coursera/03_Getting_and_Cleaning_Data/UCI HAR Dataset")

#Read the training datasets
x_train<-read.table("data/Dataset/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("data/Dataset/UCI HAR Dataset/train/Y_train.txt")
View(head(Y_train))
subject_train<-read.table("data/Dataset/UCI HAR Dataset/train/subject_train.txt")
#Read Test Dataset
x_test<-read.table("data/Dataset/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("data/Dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test<-read.table("data/Dataset/UCI HAR Dataset/test/subject_test.txt")
View(head(Subject_test))

# Reading and viewing the feature vectors
features<-read.table("data/Dataset/UCI HAR Dataset/features.txt")
View(head(features,10))

# Reading and Viewing Activity Labels
activityLabels=read.table("data/Dataset/UCI HAR Dataset/activity_labels.txt")
View(head(activityLabels))

#Assigning Colnames
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(subject_train) <-"subjectId"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_test) <-"subjectId"

# Assigning Acitvity Labels
colnames(activityLabels) <-c('activityId','activityType')
View(activityLabels)

# Merge the training and test dataset to create one dataset
merged_train<-cbind(y_train,subject_train,x_train)
View(merged_train)
colnames(merged_train)
merged_test<-cbind(y_test,subject_test,x_test)
colnames(merged_test)
MasterData<-rbind(merged_train,merged_test)
View(head(MasterData))
# Read all the values that are available 
col_names=colnames(MasterData)

#Get subset of all the mean and standard deviation and the corresponding activityID and subjectID
#Extracts only the measurements on the mean and standard deviation for each measurement.
columnswithMeanSTD<-(grepl("activityId",col_names) |
                    grepl("subjectId",col_names) |
                    grepl("mean..",col_names) |
                    grepl("std..",col_names))

View(columnswithMeanSTD)
#subset for Mean and Std
set_Mean_Std<-MasterData[ ,columnswithMeanSTD==TRUE]
View(set_Mean_Std)

# 3. Uses Descriptive activity name to name the activites in the data set.
desc_activity_name<- merge(set_Mean_Std,activityLabels,
                            by='activityId',
                             all.x =TRUE)
View(desc_activity_name)
#4Appropriately labels the data set with descriptive variable names.
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Secondary_Tidy_Dataset<-aggregate(.~subjectId+activityId,desc_activity_name,mean)
Secondary_Tidy_Dataset<-Secondary_Tidy_Dataset[order(Secondary_Tidy_Dataset$subjectId,
                                                     Secondary_Tidy_Dataset$activityId),]
write.table(Secondary_Tidy_Dataset,"Secondary_Tidy.Dataset.txt",row.names = FALSE)
View(Secondary_Tidy_Dataset)
