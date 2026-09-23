# ============================================================================
# Data Cleaning Script: TikTok Watch Events
# ============================================================================
# Purpose: Load raw data, handle mixed timestamp formats, validate data 
#          quality, and save cleaned dataset
#
# Output: data/processed/watch_events_cleaned.csv
# ============================================================================

library(tidyverse)
library(here)
library(RSQLite)

# 1. LOAD DATA 


#2. Loading The Data
con <- dbConnect(SQLite(), dbname = "data/raw/tiktok_students.sqlite")
print(dbListTables(con))
watch_events <- dbGetQuery(con, "SELECT * FROM watch_logs")
dbDisconnect(con)



watch_events <- read_csv(
  here("data", "watch_events", "raw", "watch_events.csv"),
  show_col_types = FALSE
)

# 2. INSPECT DATA STRUCTURE

cat("\n--- Initial Data Structure ---\n")
head(watch_events)
glimpse(watch_events)

# 3. ASSESS AND HANDLE MISSING VALUES 

# Overall missing values by column
missing_values <- watch_events %>%
  summarise(
    across(
      everything(),
      ~ sum(is.na(.))
    )
  )

cat("\n--- Missing Values by Column ---\n")
print(missing_values)

# Missing watch_seconds by action
missing_watch_time <- watch_events %>%
  group_by(action) %>%
  summarise(
    number_of_events = n(),
    missing_watch_seconds = sum(is.na(watch_seconds)),
    missing_percentage = mean(is.na(watch_seconds)) * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(missing_percentage))

cat("\n--- Missing watch_seconds by Action ---\n")
print(missing_watch_time)

cat("\n Observation: ~7% missing uniformly across actions.\n")

# As immediate skips are always equal to 0 watch seconds, change all missing values where action = skip_immediate to 0
watch_events <- watch_events %>%
  mutate(
    watch_seconds = case_when(
      action == "skip_immediate" & is.na(watch_seconds) ~ 0,
      TRUE ~ watch_seconds
    )
  )

# Checking Missing Watch Time per Action Again 
missing_watch_time <- watch_events %>%
  group_by(action) %>%
  summarise(
    number_of_events = n(),
    missing_watch_seconds = sum(is.na(watch_seconds)),
    missing_percentage = mean(is.na(watch_seconds)) * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(missing_percentage))

cat("\n--- Missing watch_seconds by Action After Changing Skip Immediate NA's to 0's---\n")
print(missing_watch_time)

# All Rows with Missing Data in Any Variable Will be Removed, As They Are All Key to the Analysis
cat("\n--- Delete Rows with Missing Values for Any Variable---\n")

n_before <- nrow(watch_events)

watch_events <- watch_events %>% drop_na()

n_after <- nrow(watch_events)

cat(sprintf("Rows removed: %d (%.2f%% of original data)\n", 
            n_before - n_after, 
            (n_before - n_after) / n_before * 100))

# 4. INVESTIGATE MIXED TIMESTAMP FORMATS

# Identify timestamp formats in raw data
timestamp_formats <- watch_events %>%
  mutate(
    timestamp_format = case_when(
      str_detect(started_at_raw, "^\\d{8} \\d{6}$") ~ "YYYYMMDD HHMMSS",
      str_detect(started_at_raw, "^\\d{4}-\\d{2}-\\d{2}T") ~ "ISO 8601",
      TRUE ~ "Other"
    )
  ) %>%
  count(timestamp_format, sort = TRUE)

cat("\n--- Timestamp Format Distribution ---\n")
print(timestamp_formats)

# Inspect "Other" timestamps
other_timestamps <- watch_events %>%
  filter(
    !str_detect(started_at_raw, "^\\d{8} \\d{6}$"),
    !str_detect(started_at_raw, "^\\d{4}-\\d{2}-\\d{2}T")
  ) %>%
  distinct(started_at_raw) %>%
  head(20)

cat("\n--- Sample of 'Other' Timestamp Formats ---\n")
print(other_timestamps)

# Analyze character lengths of remaining timestamps
other_length_dist <- watch_events %>%
  filter(
    !str_detect(started_at_raw, "^\\d{8} \\d{6}$"),
    !str_detect(started_at_raw, "^\\d{4}-\\d{2}-\\d{2}T")
  ) %>%
  mutate(character_length = str_length(started_at_raw)) %>%
  count(character_length, sort = TRUE)

cat("\n--- Character Length Distribution of 'Other' Timestamps ---\n")
print(other_length_dist)

cat("\nInterpretation: All remaining values are 10-digit numeric strings.\n")
cat("These are interpreted as UNIX timestamps (seconds since 1970-01-01).\n")

# 5. NORMALIZE MIXED TIMESTAMP FORMATS

watch_events <- watch_events %>%
  mutate(
    
# Separate timestamp strings by format
    text_timestamp = if_else(
      str_detect(started_at_raw, "^\\d{4}-\\d{2}-\\d{2}T") |
        str_detect(started_at_raw, "^\\d{8} \\d{6}$"),
      started_at_raw,
      NA_character_
    ),
    
    unix_timestamp = if_else(
      str_detect(started_at_raw, "^\\d{10}$"),
      started_at_raw,
      NA_character_
    ),
    
    
# Parse both formats and coalesce to single datetime
    started_at_normalized = coalesce(
      ymd_hms(text_timestamp, tz = "UTC"),
      as.POSIXct(
        as.numeric(unix_timestamp),
        origin = "1970-01-01",
        tz = "UTC"
      )
    )
  ) %>%
  
# Remove temporary columns
  select(-text_timestamp, -unix_timestamp)

cat("\n--- Timestamp Normalization Complete ---\n")

# 6. VALIDATE TIMESTAMP NORMALIZATION 

# Check for successful conversion
timestamp_check <- watch_events %>%
  summarise(
    total_observations = n(),
    missing_raw = sum(is.na(started_at_raw)),
    missing_normalized = sum(is.na(started_at_normalized))
  )

cat("\nTimestamp normalization check:\n")
print(timestamp_check)

# Verify normalized timestamps match existing parsed timestamps
timestamp_comparison <- watch_events %>%
  summarise(
    matching_timestamps = sum(
      started_at == started_at_normalized,
      na.rm = TRUE
    ),
    non_matching_timestamps = sum(
      started_at != started_at_normalized,
      na.rm = TRUE
    )
  )

cat("\nComparison with existing started_at variable:\n")
print(timestamp_comparison)

if (timestamp_comparison$non_matching_timestamps[1] == 0) {
  cat("\n✓ All normalized timestamps match the existing started_at variable.\n")
} else {
  warning("Normalized timestamps do NOT match started_at. Review conversion logic.")
}

# 7. CHECK FOR AND REMOVE DUPLICATE ENTRIES 

cat("\n--- Checking for Duplicate Entries ---\n")

# Count rows before duplicate removal
total_rows_before <- nrow(watch_events)

# Create a duplicate check dataset excluding watch_events_id and impression_id (as they are unique for each entry)
watch_events <- watch_events %>%
  distinct(
    across(-c(watch_event_id, impression_id)),
    .keep_all = TRUE
  )

# Count rows after duplicate removal
total_rows_after <- nrow(watch_events)
duplicate_count <- total_rows_before - total_rows_after

cat(glue::glue("\nTotal observations before duplicate removal: {total_rows_before}\n"))
cat(glue::glue("Total observations after duplicate removal: {total_rows_after}\n"))
cat(glue::glue("Duplicate observations removed: {duplicate_count}\n"))

if (duplicate_count > 0) {
  cat(glue::glue("\n✓ Removed {duplicate_count} duplicate entries (excluding watch_events_id and impression_id).\n"))
} else {
  cat("\n✓ No duplicate entries found (excluding watch_events_id and impression_id).\n")
}


# 8. SAVE CLEANED DATASET

output_dir <- here("data", "processed")

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write_csv(
  watch_events,
  here(output_dir, "watch_events_cleaned.csv")
)