# TikTok-project-2026-Team6

Tilburg University  
Data Preparation & Programming

Project Owners:

- Alex Hendrikx
- Nanyun Zhang

## Project Goal

The goal of this project is to create reproducible workflows for downloading, cleaning, analyzing, and summarizing TikTok data using R, Quarto, Git, GitHub, and Make.

The repository currently contains analyses of:

- TikTok video-view data;
- TikTok session data;
- TikTok watch-events data.

## Folder Structure

The project contains three main folders:

- `data/` — contains locally downloaded raw and processed datasets. This folder is ignored by Git and is created automatically when required.
- `src/` — contains the R scripts, Quarto analysis files, and analysis-specific documentation.
- `documentation/` — contains project documentation, including AI usage documentation.

The main analysis files include:

- `src/downloading_videodata_script.R` — downloads the video-view dataset.
- `src/Summary_videos.qmd` — contains the video-view analysis.
- `src/Session_analysis_alex/data_session_download.R` — downloads the session dataset.
- `src/Session_analysis_alex/data_session_cleaning.R` — cleans the session dataset.
- `src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd` — contains the session analysis.
- `src/watch_events_analysis/download_watch_events.R` — downloads the watch-events dataset.
- `src/watch_events_analysis/cleaning_watch_events.R` — cleans the watch-events dataset.
- `src/watch_events_analysis/Summary_watch_events.qmd` — contains the watch-events analysis.
- `Makefile` — integrated workflow that coordinates the project analyses and their dependencies.
- `documentation/AI.md` — documents how AI tools were used and validated.

## Data

The datasets are downloaded automatically by the relevant R scripts and stored locally inside the `data/` folder.

The project currently uses:

```text
data/raw/video_view.csv
data/data_session/raw/sessions.csv
data/data_session/processed/cleaned_sessions.csv
data/watch_events/raw/watch_events.csv
data/watch_events/processed/watch_events_cleaned.csv
```

The `data/` folder is ignored by Git, so datasets are not committed to the repository.

## Requirements

The following software is required:

- R
- Quarto
- GNU Make

The R packages used across the workflows include:

- tidyverse
- here
- janitor
- RSQLite
- DBI
- fixest

The required R packages can be installed using:

```r
install.packages("tidyverse")
install.packages("here")
install.packages("janitor")
install.packages("RSQLite")
install.packages("fixest")
```

## Reproducing the Project

The repository contains an integrated Makefile in the project root. It coordinates the video, session, and watch-events analysis workflows.

For a complete reproducibility check, run the following commands from the root of the repository:

```bash
make clean
make
```

The `make clean` command removes generated data and analysis outputs. Running `make` afterwards rebuilds the complete workflow, including downloading required datasets, cleaning the data, and rendering the analysis reports.

For normal use, when a complete rebuild is not required, run:

```bash
make
```

Make will only rebuild outputs whose source files or dependencies have changed.

The main generated HTML outputs are:

```text
src/Summary_videos.html
src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html
src/watch_events_analysis/Summary_watch_events.html
```

After a successful build, running:

```bash
make
```

again should not unnecessarily rebuild outputs that are already up to date.

## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If `make` is not recognized, check that GNU Make is installed and available on the system PATH.
- If a dataset is missing, run `make`; the relevant download script will be called automatically.
- If required R packages are missing, install `tidyverse`, `here`, and `janitor`.
- If Quarto cannot locate R, run `quarto check` to verify the installation.

## Group Members and Contributions

- Alex — contributed to the project setup, session-data workflow, reproducibility improvements, Makefile development, debugging, review, and documentation.
- Nanyun — contributed to the video analysis, watch-events workflow, data cleaning and analysis, reproducibility testing, Makefile integration, debugging, review, and documentation.

Project changes were reviewed collaboratively. Both team members reviewed and modified each other's work before integration into the main branch.

## AI Usage

AI usage during the project is documented in `documentation/AI.md`.
