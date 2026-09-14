# Watch Events Analysis

This folder contains the individual analysis for Issue #10: **Inspect and analyze the TikTok watch events dataset**.

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
- `Summary_watch_events.qmd` — contains the data inspection, cleaning, analysis, and visualizations.
- `Summary_watch_events.html` — rendered HTML report generated from the Quarto document.
- `makefile` — automates data downloading and report generation based on file dependencies.
- `README.md` — provides instructions for reproducing the analysis.

The downloaded dataset is stored in:

```text
data/watch_events/watch_events.csv
```

Generated figures are stored in:

```text
output/watch_events/
```

The figures currently include:

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

The analysis includes checks for missing values and timestamp formats.

Missing `watch_seconds` values are retained when the analysis does not require watch duration and are excluded only from calculations that directly use `watch_seconds`.

The raw start timestamps contain multiple formats, including ISO 8601 timestamps, compact date-time strings, and UNIX timestamps. These values are normalized into a consistent datetime variable and validated against the existing parsed timestamp.

## Analysis

The Quarto report contains four main behavioral analyses:

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

From the root folder of the repository, move to the watch-events analysis directory:

```bash
cd src/watch_events_analysis
```

Run the complete workflow with:

```bash
make
```

The Makefile automatically downloads `watch_events.csv` if the dataset is not already available and renders the Quarto analysis when the required inputs have changed.

The expected HTML output is:

```text
Summary_watch_events.html
```

The generated PNG figures are saved in:

```text
../../output/watch_events/
```

To remove the generated HTML report and figures, run:

```bash
make clean
```

The downloaded raw dataset is retained when running `make clean`.

To rebuild the analysis from the generated-output stage, run:

```bash
make clean
make
```

## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If the dataset is missing, run `make`; the Makefile will call the download script automatically.
- If required R packages are missing, install `tidyverse` and `here`.
- If Quarto cannot locate R, run `quarto check` to verify the installation.
- The time-of-day analysis uses UTC timestamps. Hours 22 and 23 are not represented consistently across all 60 dates and are therefore excluded from the main hourly comparison.
- If `make` is not recognized, check that GNU Make is installed and available on the system PATH.

## AI Usage

AI assistance used during the individual analysis is documented in `../../documentation/AI.md`.