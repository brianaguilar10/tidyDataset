## LOADING THE DATASETS

features_list <- read.table('features.txt')
features_list <- features_list[,2]
subject_test <- read.table('subject_test.txt', col.names = 'Subject')
x_test <- read.table('X_test.txt', col.names = features_list)
y_test <- read.table('Y_test.txt', col.names = 'Label')
subject_train <- read.table('subject_train.txt', col.names = 'Subject')
x_train <- read.table('X_train.txt', col.names = features_list)
y_train <- read.table('Y_train.txt', col.names = 'Label')

## COMBINING TRAINING AND TEST DATA

x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)

## EXTRACTING MEAN AND STD FEATURES OF DATASET

x_mean <- x[colnames(x)[grepl("mean.", colnames(x), fixed = TRUE)]]
x_std <- x[colnames(x)[grepl("std.", colnames(x), fixed = TRUE)]]
x_mean_std <- cbind(subject,x_mean,x_std)

## ADDING DESCRIPTIVE ACTIVITY LABEL TO THE DATASET

activity_labels <- read.table('activity_labels.txt', col.names = c("Label", "Activity"))
y_labels <- merge(y, activity_labels, by = "Label", sort = FALSE)
y_labels <- subset(y_labels, select = c('Activity'))
data <- cbind(y_labels,x_mean_std)

## AVERAGE THE FEATURES PER ACTIVITY AND PER SUBJECT

data = transform(data, Activity = factor(Activity))
tidy <- aggregate(data[,-1:-2], by = list(data$Activity,data$Subject), FUN = 'mean')
colnames(tidy)[1:2] <- c('Activity', 'Subjects')

## CREATE A TXT FILE OF THE TIDY DATASET

write.table(tidy, file = 'tidy.txt', row.names = FALSE)
