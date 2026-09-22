# Watch Events Analysis

This folder contains the individual analysis for Issue #10: **Inspect and analyze the TikTok watch events dataset**.

Analysis performed by: Nanyun Zhang  
Feedback given and changes made by: Alex Hendrikx

The analysis examines user watch behavior, watch duration, session-level engagement, and time-of-day activity. It also checks and normalizes the mixed timestamp formats present in the raw data.

## Project Goal

The goal of this analysis is to create a reproducible workflow for downloading, cleaning, analyzing, and visualizing the TikTok watch events dataset using R, Quarto, ggplot2, and Git.

The analysis focuses on:

- the distribution of different watch actions;
- watch duration across user actions;
- engagement at the session level;
- watch activity across different hours of the day;
- missing values and mixed timestamp formats.

## Folder Structure

The main files used for this analysis are:

- `download_watch_events.R` — downloads the watch events dataset into the project data folder.
- `cleaning_watch_events.R` — contains the data inspection and cleaning workflow.
- `Summary_watch_events.qmd` — contains the data analysis and visualizations.
- `Summary_watch_events.html` — rendered HTML report generated from the Quarto document.
- `Makefile` (repository root) — integrated Makefile that coordinates the team analysis workflows and rebuilds outputs based on file dependencies.
- `README.md` — provides instructions for reproducing the analysis.

The downloaded raw dataset is stored in:

```text
data/watch_events/raw/watch_events.csv
```

The cleaned dataset is stored in:

```text
data/watch_events/processed/watch_events_cleaned.csv
```

Generated figures are stored in:

```text
output/watch_events/
```

The figures include:

```text
action_distribution.png
watch_time_by_action.png
events_per_session.png
hourly_watch_activity.png
```

## Data

The analysis uses the TikTok `watch_events.csv` dataset provided for Issue #10.

Each row represents a watch event and contains information such as the user, session, video, creator, action taken, watch duration, and timestamps.

The dataset is downloaded automatically by `download_watch_events.R`. The local `data/` folder is ignored by Git, so the raw dataset is not committed to the repository.

## Data Preparation

The data cleaning is performed in `cleaning_watch_events.R` and checks for missing values, duplicate entries, and timestamp formats.

Missing values are found in the raw dataset for `watch_seconds`. For rows with the action `skip_immediate` and a missing value for `watch_seconds`, the missing value is replaced with `0`, because an immediate skip implies no observed watch duration. For the remaining missing values, rows are removed during the cleaning process. This changes the number of observations from 98,702 to 93,211.

The raw start timestamps contain multiple formats, including ISO 8601 timestamps, compact date-time strings, and UNIX timestamps. These values are normalized into a consistent datetime variable and validated against the existing parsed timestamp.

After datetime normalization, the data is checked for duplicate entries while excluding `impression_id` and `watch_event_id`, because these variables uniquely identify individual entries. Any duplicate observations are automatically removed, and the script reports how many rows were removed.

The cleaned dataset is saved as `watch_events_cleaned.csv` and serves as the input for the analysis document.

## Analysis

The Quarto report (`Summary_watch_events.qmd`) contains four main behavioral analyses:

1. **Distribution of Watch Actions** — compares how frequently the four user actions occur.
2. **Watch Time by Action** — compares watch duration across different user actions.
3. **Session-Level Engagement** — examines the number of watch events and observed watch time within user sessions.
4. **Time-of-Day Behavior** — examines watch activity across hours with complete date coverage.

All visualizations are created using `ggplot2` and saved as PNG files using `ggsave()`.

## Requirements

The following software and R packages are required:

- R
- Quarto
- GNU Make
- tidyverse
- here

The required R packages can be installed using:

```r
install.packages("tidyverse")
install.packages("here")
```

## Reproducing the Analysis

The project uses an integrated Makefile located in the root of the repository. The root Makefile coordinates the video analysis, session analysis, and watch-events analysis workflows.

For a complete reproducibility check, run the following commands from the root of the repository:

```bash
make clean
make
```

The `make clean` command removes generated data and analysis outputs. The following `make` command then rebuilds the complete project workflow, including downloading required datasets, cleaning the data, and rendering the analysis reports.

For normal use, when a complete rebuild is not required, run:

```bash
make
```

Make will only rebuild outputs whose source files or dependencies have changed.

For the watch-events analysis, the expected HTML output is:

```text
src/watch_events_analysis/Summary_watch_events.html
```

The generated figures are stored in:

```text
output/watch_events/
```

After a successful build, running `make` again should not unnecessarily rebuild outputs whose dependencies have not changed.

## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If a dataset is missing, run `make`; the integrated Makefile will call the required download script automatically.
- If required R packages are missing, install `tidyverse` and `here`.
- If Quarto cannot locate R, run `quarto check` to verify the installation.
- The time-of-day analysis uses UTC timestamps. Hours 22 and 23 are not represented consistently across all 60 dates and are therefore excluded from the main hourly comparison.
- If `make` is not recognized, check that GNU Make is installed and available on the system PATH.

## AI Usage

AI assistance used during the individual analysis is documented in `../../documentation/AI.md`.