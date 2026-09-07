# Load required package
library(tidyverse)

# Create the raw data folder if it does not exist
if (!dir.exists("data/raw")) {
  dir.create("data/raw", recursive = TRUE)
}

# Download the project dataset if it is not already available
if (!file.exists("data/raw/video_view.csv")) {

  data_url <- paste0(
    "https://raw.githubusercontent.com/hannesdatta/",
    "course-dprep/refs/heads/main/material/project/",
    "video_view.csv"
  )

  download.file(
    data_url,
    "data/raw/video_view.csv"
  )

  print("Download successful: video_view.csv saved to data/raw.")

} else {

  print("File already exists: download skipped.")

}

# Load the dataset into R
videos <- read_csv("data/raw/video_view.csv")
