# TikTok-project-2026-Team6
Tilburg University
Data Preparation & Programming

Project Owners: 
- Alex Hendrikx
- Nanyun Zhang


## Project Goal
The goal of this project is to create a reproducible workflow for downloading and summarizing TikTok video view data using R, Quarto, Git, and GitHub.

## Folder structure
The project contains three main folders:
- `data/` contains locally downloaded raw and processed data. The folder is ignored by Git and is created automatically when needed.
- `src/` contains the R scripts and Quarto analysis files.
- `documentation/` contains project documentation, including the AI usage documentation.

The main files used in the project are:
- `src/downloading_videodata_script.R` — downloads the TikTok video view dataset.
- `src/Summary_videos.qmd` — contains the Quarto analysis and summary of the dataset.
- `documentation/AI.md` — documents how AI tools were used and validated.
- `.gitignore` — prevents local data files from being tracked by Git.

## Data

The project uses `video_view.csv`, which is downloaded automatically from the course project repository and saved locally in `data/raw/`.

## Requirements
The following software and R packages are required:
- R
- Quarto
- tidyverse
- here

The required R packages can be installed using:

```r
install.packages("tidyverse")
install.packages("here")
```

## Reproducing the Analysis

Run the following commands from the root folder of the repository.

First, download the dataset:

```bash
Rscript src/downloading_videodata_script.R
```

Then render the Quarto analysis:

```bash
quarto render src/Summary_videos.qmd
```

Expected output: `src/Summary_videos.html`

The Quarto document reads the downloaded data from `data/raw/` and produces an HTML summary containing descriptive statistics and additional analyses of the TikTok video view data.

## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If the dataset cannot be found, run the data download script before rendering the Quarto document.
- If Quarto cannot locate R, run `quarto check` to verify the R installation.

## Group Members and Contributions

- Alex — Took primary responsibility for the initial project setup, folder structure, data download workflow, `.gitignore`, and AI documentation, while also contributing to debugging and the Quarto workflow.
- Nanyun — Contributed to the Quarto summary, README, data workflow, debugging, testing, and AI documentation.

Most project tasks were discussed and completed collaboratively. Final review, reproducibility testing, and quality checks were completed jointly by Alex and Nanyun.

## AI Usage
AI usage during the project is documented in `documentation/AI.md`.