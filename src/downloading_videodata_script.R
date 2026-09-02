library(tidyverse)

if (!file.exists("data/raw/video_view.csv")) {
  data_url <- paste0(
    "https://raw.githubusercontent.com/hannesdatta/course-dprep/refs/heads/main/material/tutorials/r-bootcamp-rev/video_view.csv"
  )
  download.file(data_url, "data/raw/video_view.csv")
} 
videos <- read_csv("data/raw/video_view.csv")
