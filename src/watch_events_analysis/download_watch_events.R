# Download the TikTok watch events dataset

data_dir <- "../../data/watch_events"

dir.create(
  data_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

data_url <- paste0(
  "https://raw.githubusercontent.com/hannesdatta/",
  "course-dprep/refs/heads/main/material/project/",
  "coaching_2_data/watch_events.csv"
)

data_file <- file.path(
  data_dir,
  "watch_events.csv"
)

if (!file.exists(data_file)) {

  download.file(
    data_url,
    data_file,
    mode = "wb"
  )

  message("Dataset downloaded to: ", data_file)

} else {

  message("Dataset already exists: ", data_file)

}
