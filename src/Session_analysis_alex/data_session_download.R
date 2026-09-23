library(tidyverse)

# 1. Create data_session folder (only if needed)
if (!dir.exists("data/raw")) {
  dir.create("data/raw", recursive = TRUE)
}
# 2. Download the data csv file (only if needed)
if (!file.exists("data/raw/sessions.csv")) {

  data_url <- paste0("https://raw.githubusercontent.com/hannesdatta/course-dprep/refs/heads/main/material/project/coaching_2_data/sessions.csv"
  )

  download.file(
    data_url,
    "data/raw/sessions.csv"
  )

  print("Download successful: sessions.csv saved to data/raw.")

} else {

  print("File already exists: download skipped.")

}

