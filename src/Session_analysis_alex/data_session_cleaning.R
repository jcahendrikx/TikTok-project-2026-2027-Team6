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

#5. Check for exact duplicate rows and duplicated session IDs
exact_duplicates <- sessions %>%
  janitor::get_dupes()

duplicate_session_ids <- sessions %>%
  count(session_id, name = "session_id_count") %>%
  filter(session_id_count > 1)

exact_duplicates
duplicate_session_ids

#6. Remove only exact duplicate rows and missing data
sessions_after_duplicates <- sessions %>%
  distinct()

duplicates_removed <- nrow(sessions) - nrow(sessions_after_duplicates)

sessions_clean <- sessions_after_duplicates %>%
  drop_na(session_duration_sec, videos_viewed, watch_seconds) #Actually Removes the missing data if they occur when the dataset changes in the future

missing_removed <- nrow(sessions_after_duplicates) - nrow(sessions_clean) #Storing the difference to show how many rows were removed because of missing values

cat("Duplicate rows deleted:", duplicates_removed, "\n")
cat("Rows deleted due to missing values:", missing_removed, "\n")

#7. Convert login and logout timestamps after duplicate removal
sessions_clean <- sessions_clean %>%
  mutate(
    login_at = as.POSIXct(
      login_at,
      format = "%Y-%m-%dT%H:%M:%SZ",
      tz = "UTC"
    ),
    logout_at = as.POSIXct(
      logout_at,
      format = "%Y-%m-%dT%H:%M:%SZ",
      tz = "UTC"
    )
  )

head(sessions_clean)

#7.1 Check data classes again
sessions_clean %>%
  summarise(across(everything(), ~list(class(.))))

#8. Save the cleaned file to Processed Folder
#8.1 Create Processed Folder if Needed
if (!dir.exists("data/data_session/processed")) {
  dir.create("data/data_session/processed", recursive = TRUE)
}

#8.2 Download the Cleaned Csv File
write_csv(sessions_clean, "data/data_session/processed/cleaned_sessions.csv")
