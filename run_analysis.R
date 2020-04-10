
library(dplyr)
library(tibble)
library(tidyr)

prepare_data_sets <- function(features, fileset) {
	train_dataset <- as_tibble(read.table(paste("data/UCI HAR Dataset/", fileset, "/X_", fileset, ".txt", sep = "") ))
	names(train_dataset) <- as.character(features$feature_name)

	# read subjects and merge to dataset
	train_subjects <- as_tibble(read.table(paste("data/UCI HAR Dataset/", fileset, "/subject_", fileset, ".txt", sep = "") ))
	names(train_subjects) <- c("subject_id")
	train_merged <- bind_cols(train_subjects, train_dataset)

	# read activities
	train_activities <- as_tibble(read.table(paste("data/UCI HAR Dataset/", fileset, "/y_", fileset, ".txt", sep = "") ))
	names(train_activities) <- c("activity_id")
	train_merged <- bind_cols(train_activities, train_merged)
	train_merged
}

# --- Preparation
# Download and extract files
if (!file.exists("./data")) { dir.create("./data/")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/UCI_HAR_Dataset.zip", method="curl")
unzip("./data/UCI_HAR_Dataset.zip", exdir = "./data/")
file.remove("./data/UCI_HAR_Dataset.zip")

features <- as_tibble(read.table("data/UCI HAR Dataset/features.txt"))
names(features) <- c("feature_id", "feature_name")

# Merges the TRAINING datasets to create one data set.
train_merged <- prepare_data_sets(features, "train")

# Merges the TEST datasets to create one data set.
test_merged <- prepare_data_sets(features, "test")

# --- ANALYSIS
# 1. Merges the TRAINING and TEST sets to create one data set.
single_dataset <- bind_rows(train_merged, test_merged)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std_data <- select(single_dataset, contains(c("subject_id", "activity_id", "mean", "std")))

# 3. Uses descriptive activity names to name the activities in the data set.
activity_names <- as_tibble(read.table("data/UCI HAR Dataset/activity_labels.txt"))
names(activity_names) <- c("activity_id", "activity_name")
mean_std_data <- mutate(mean_std_data, activity_name = as.character(activity_names[activity_id,]$activity_name))
# select(mean_std_data, contains("activity")) %>% distinct() %>% arrange(activity_id)

# 4.Appropriately labels the data set with descriptive variable names.
# It's already named since the beginning.
# names(mean_std_data)

columns_to_summarized <- grep("mean|std", names(mean_std_data), value = TRUE)
summarized_dataset <-
	mean_std_data %>%
		group_by(activity_name, subject_id) %>%
		summarise_at(columns_to_summarized, mean, na.rm = TRUE)

print(summarized_dataset)
write.table(summarized_dataset, file = "summarized_dataset.txt", row.names = FALSE)

