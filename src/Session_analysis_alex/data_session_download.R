library(tidyverse)

# 1. Create data_session folder (only if needed)
if (!dir.exists("data/data_session/raw")) {
  dir.create("data/data_session/raw", recursive = TRUE)
}
# 2. Download the data csv file (only if needed)
if (!file.exists("data/data_session/raw/sessions.csv")) {

  data_url <- paste0("https://raw.githubusercontent.com/hannesdatta/course-dprep/refs/heads/main/material/project/coaching_2_data/sessions.csv"
  )

  download.file(
    data_url,
    "data/data_session/raw/sessions.csv"
  )

  print("Download successful: sessions.csv saved to data/data_session/raw.")

} else {

  print("File already exists: download skipped.")

}

