#1. Download The Needed Packages
#For the data cleaning part of this project, the following packages are needed: 1. tidyverse, 2. here, 3. janitor
library(tidyverse)
library(here)
library(janitor)


#2. Loading The Data
sessions <- read.csv(here("data", "data_session", "raw", "sessions.csv"))
head(sessions)
dim(sessions) #It shows that the sessions datafile consists of only 7 columns, but almost 100,000 rows of data
summary(sessions)



#3. Checking Data Classes
sessions %>% 
  summarise(across(everything(), class)) #All variables are the class that they are expected to be

#4. Removing Rows with Missing Data for Critical Variables
missing_data <- sessions %>% 
    select(session_duration_sec, videos_viewed, watch_seconds) %>% 
    summarise(across(everything (),
    list(missing = ~sum(is.na(.)))
    ))

missing_data #So, according to this code, the three key numeric data columns do not have any missing data

#5. Check for Duplicate Rows
sessions %>%
  select(-session_id) %>%  #Is an unique identifier that needs to be removed first to check for duplicates
  janitor::get_dupes()     #Shows that there are no duplicate rows

#6. Remove Duplicate Rows and Missing Data
sessions_after_duplicates <- sessions %>% 
  distinct(pick(-session_id), .keep_all = TRUE) #Actually Removes the duplicates if they occur when the dataset changes in the future

duplicates_removed <- nrow(sessions) - nrow(sessions_after_duplicates) #Storing the difference to show how many rows were removed because of duplicates

sessions_clean <- sessions_after_duplicates %>%
  drop_na(session_duration_sec, videos_viewed, watch_seconds) #Actually Removes the missing data if they occur when the dataset changes in the future

missing_removed <- nrow(sessions_after_duplicates) - nrow(sessions_clean) #Storing the difference to show how many rows were removed because of missing values

cat("Duplicate rows deleted:", duplicates_removed, "\n")
cat("Rows deleted due to missing values:", missing_removed, "\n")

#7. Save the cleaned file to Processed Folder
#7.1 Create Processed Folder if Needed
if (!dir.exists("data/data_session/processed")) {
  dir.create("data/data_session/processed", recursive = TRUE)
}

#7.2 Download the Cleaned Csv File
write_csv(sessions_clean, "data/data_session/processed/cleaned_sessions.csv")
