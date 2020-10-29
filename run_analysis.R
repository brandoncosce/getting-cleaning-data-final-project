library(dplyr)

X_test <- read.table("X_test.txt", stringsAsFactors = FALSE)
y_test <- read.table("y_test.txt", stringsAsFactors = FALSE)
y_train <- read.table("y_train.txt", stringsAsFactors = FALSE)
X_train <- read.table("X_train.txt", stringsAsFactors = FALSE)
features <- read.table("features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

onedatasetx <- bind_rows(X_test,X_train)
onedatasety <- bind_rows(y_test,y_train)
colnames(onedatasetx) <- features$V2
colnames(onedatasety) <- "train"
onedataset <- bind_cols(onedatasety,onedatasetx)
m.std.colnames <- grep("mean|std|train",colnames(onedataset))
m.std <- onedataset[,m.std.colnames]
colnames(activity_labels) <- c("train","activity")
m.std.act_names <- merge(m.std,activity_labels, by.x = "train",by.y = "train")
tidy_data <- m.std.act_names %>% select(activity,train,everything())
tidy_data_grp <- tidy_data %>% group_by(activity)
new_tidy_data <- as.data.frame(unique(activity_labels))

m <-  tidy_data_grp %>% summarise(across(everything(), mean))
m <- m[-c(2)]


write.table(m,"final-tidy-data.txt",row.names = FALSE)
