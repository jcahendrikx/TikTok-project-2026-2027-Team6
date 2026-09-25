# TikTok-project-2026-Team6

Tilburg University  
Data Preparation & Programming Skills

Project Owners:

- Alex Hendrikx
- Nanyun Zhang

## Project Goal

The goal of this project is to create a reproducible workflow for downloading, cleaning, analyzing, and summarizing TikTok data using R, Quarto, Git, GitHub, SQLite, and Make.

The repository contains:

- a video-view analysis;
- a session analysis;
- a watch-events analysis;
- an SQLite-based summary analysis;
- a session-level regression analysis;
- a final PDF report combining the main analyses and conclusions.

## Folder Structure

The project contains four main folders:

- `data/` — contains locally downloaded raw and processed datasets and the SQLite database. It is created automatically when required.
- `src/` — contains the R scripts and Quarto analysis files.
- `output/` — contains generated analysis outputs, regression results, figures, and the final PDF report.
- `documentation/` — contains project documentation, including AI usage documentation.

The main project files include:

- `src/downloading_videodata_script.R` — downloads the video-view dataset.
- `src/Summary_videos.qmd` — contains the video-view analysis.
- `src/Session_analysis_alex/data_session_download.R` — downloads the session dataset.
- `src/Session_analysis_alex/data_session_cleaning.R` — cleans the session dataset.
- `src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd` — contains the session analysis.
- `src/watch_events_analysis/download_watch_events.R` — downloads the watch-events dataset.
- `src/watch_events_analysis/cleaning_watch_events.R` — cleans the watch-events dataset.
- `src/watch_events_analysis/Summary_watch_events.qmd` — contains the watch-events analysis.
- `src/SQLite/Downloading_SQLite_File.R` — downloads the SQLite database.
- `src/SQLite/SQL_Summary.qmd` — queries and summarizes selected tables from the SQLite database.
- `src/regression_analysis/regression_analysis.R` — runs the session-level regression analysis.
- `src/Final_Analysis_Summary.qmd` — combines the main analyses, regression results, conclusions, and caveats into the final report.
- `Makefile` — coordinates the complete reproducible workflow and its dependencies.
- `documentation/AI.md` — documents how AI tools were used and validated.

## Data

The required data are downloaded automatically by the Makefile and the corresponding R scripts.

The main local data files are:

```text
data/raw/video_view.csv
data/raw/sessions.csv
data/processed/cleaned_sessions.csv
data/raw/watch_events.csv
data/processed/watch_events_cleaned.csv
data/raw/tiktok_students.sqlite
```

The SQLite database is used for the SQL summary analysis. Some of the main analyses continue to use the CSV datasets because the tables required for those analyses are not available in the SQLite database.

The `data/` folder is ignored by Git, so downloaded datasets and the SQLite database are not committed to the repository.

## Regression Analysis

The regression analysis investigates whether longer TikTok sessions are associated with a higher number of videos viewed after accounting for time-of-day differences and persistent differences between users.

The analysis compares:

- a baseline model;
- a model with time-of-day controls;
- a model with time-of-day controls and user fixed effects.

The regression models are estimated using the `fixest` package, with standard errors clustered by user.

Regression outputs are saved in:

```text
output/regression/
```

## Requirements

The following software is required:

- R
- Quarto
- GNU Make
- a LaTeX installation for rendering the final PDF, such as TinyTeX

The R packages used across the workflows include:

- tidyverse
- here
- janitor
- RSQLite
- DBI
- knitr
- fixest
- tinytex

The required R packages can be installed using:

```r
install.packages("tidyverse")
install.packages("here")
install.packages("janitor")
install.packages("RSQLite")
install.packages("DBI")
install.packages("knitr")
install.packages("fixest")
install.packages("tinytex")
```

If a LaTeX installation is not already available, TinyTeX can be installed through Quarto using:

```bash
quarto install tinytex
```

## Reproducing the Project

The repository contains a single integrated Makefile in the project root.

For a complete reproducibility check, run the following commands from the root of the repository:

```bash
make clean
make
```

The `make clean` command removes generated data and analysis outputs. Running `make` afterwards rebuilds the complete workflow.

The Makefile automatically:

1. downloads the SQLite database and renders the SQL summary;
2. downloads the video, session, and watch-events datasets;
3. cleans the datasets where required;
4. renders the individual analysis summaries;
5. runs the regression analysis;
6. renders the final PDF report.

For normal use, run:

```bash
make
```

Make uses file dependencies, so outputs are only rebuilt when their inputs have changed.

The main generated outputs include:

```text
src/SQLite/SQL_Summary.html
src/Summary_videos.html
src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html
src/watch_events_analysis/Summary_watch_events.html
output/regression/
output/final_report/Final_Analysis_Summary.pdf
```

After a successful build, running `make` again without changing any inputs should not rerun the workflow.

## Final Report

The final combined analysis is defined in:

```text
src/Final_Analysis_Summary.qmd
```

The generated PDF is saved to:

```text
output/final_report/Final_Analysis_Summary.pdf
```

The final report combines data inspection, summary analyses, the regression analysis, conclusions, and relevant caveats.

## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If `make` is not recognized, check that GNU Make is installed and available on the system PATH.
- If a dataset is missing, run `make`; the relevant download script will be called automatically.
- If an R package is missing, install the required packages listed above.
- If Quarto cannot locate R, run `quarto check`.
- If PDF rendering fails because no TeX installation is detected, run `quarto install tinytex`.

## Group Members and Contributions

- Alex — contributed to project setup, the session-data workflow, SQLite integration, the final analysis report, reproducibility improvements, Makefile development, debugging, review, and documentation.
- Nanyun — contributed to the video analysis, watch-events workflow, regression analysis, data cleaning and analysis, reproducibility testing, Makefile integration, debugging, review, and documentation.

Project changes were reviewed collaboratively. Both team members reviewed and modified each other's work before integration into the main branch.

## AI Usage

AI usage during the project is documented in:

```text
documentation/AI.md
```
