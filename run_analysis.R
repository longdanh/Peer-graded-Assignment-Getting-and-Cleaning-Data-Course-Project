# Install and running "reshape2" package
## Step 1
# Reading and extract only feature data of mean or standard deviation (required data)
feat_name <- read.table("UCI HAR Dataset/features.txt")
feat_want <- grep("std|mean", feat_name$V2)

## Step 2
# Read and subset required data for training and test feature data then combine them into 1 
# dataset and then label it
feat_train <- read.table("UCI HAR Dataset/train/X_train.txt")
feat_train_want <- feat_train[,feat_want]
feat_test <- read.table("UCI HAR Dataset/test/X_test.txt")
feat_test_want <- feat_test[,feat_want]


feat_cbine <- rbind(feat_train_want, feat_test_want)

colnames(feat_cbine) <- feat_name[feat_want, 2]

# Step 3
# Read and combine the training and test activity codes
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
train_test <- rbind(Y_train, Y_test)

# Step 4
# Read activity label data and bind to  activity code
act_label <- read.table("UCI HAR Dataset/activity_labels.txt")
train_test$activity <- factor(train_test$V1, levels = act_label$V1, labels = act_label$V2)

# Step 5
# Read and combine training and test subject
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
sub_cbine <- rbind(sub_train, sub_test)

# Merge and label subject and activity 
sub_act <- cbind(sub_cbine, train_test$activity)
colnames(sub_act) <- c("subject", "activity")

# Step 6
# Combine dataset of step 2 and step 5 to get completed dataset
fin_data <- cbind(sub_act, feat_cbine)

# Calculate result, create independent tidy data set call "new_data.txt", report mean of
# all measurement

result <- aggregate(fin_data[,3:81], by = list(fin_data$subject, fin_data$activity), FUN = mean)
colnames(result)[1:2] <- c("subject", "activity")
write.table(result, file="new_data.txt", row.names = FALSE)
