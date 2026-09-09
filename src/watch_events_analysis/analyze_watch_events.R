library(tidyverse)

data_file <- "../../data/watch_events/watch_events.csv"

watch_events <- read_csv(
  data_file,
  show_col_types = FALSE
)

# 1. Show column names
print(names(watch_events))

# 2. Inspect rows, columns, and variable types
glimpse(watch_events)

# 3. Show the first rows
print(head(watch_events))

# 4. Basic descriptive summary
print(summary(watch_events))

# 5. Count missing values in each variable
missing_values <- watch_events %>%
  summarise(
    across(
      everything(),
      ~ sum(is.na(.))
    )
  )

print(missing_values)
