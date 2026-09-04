# TikTok-project-template-2026
This repository is a template for the Data preparation and programming skills in fall 2026. 

## Project Goal
The goal of this project is to create a reproducible workflow for downloading and summarizing TikTok video view data using R, Quarto, Git, and GitHub.

## Folder structure
The project contains three main folders:
- `data/` contains the raw and processed data.
- `src/` contains the R scripts and Quarto analysis files.
- `documentation/` contains project documentation, including the AI usage documentation.

The main files used in the project are:
- `src/downloading_videodata_script.R` — downloads the TikTok video view dataset.
- `src/Summary_videos.qmd` — contains the Quarto analysis and summary of the dataset.
- `documentation/AI.md` — documents how AI tools were used and validated.
- `.gitignore` — prevents local data files from being tracked by Git.

## Requirements
The following software and R packages are required:
- R
- Quarto
- tidyverse

The required R package can be installed using:

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

The Quarto document reads the downloaded data from `data/raw/` and produces an HTML summary containing descriptive statistics and additional analyses of the TikTok video view data.

## Group Members and Contributions
- [Alex] — Contributed to the project setup, data download workflow, Quarto analysis, debugging, testing, GitHub issue management, and documentation.
- [Nanyun] — Contributed to data download workflow, Quarto analysis, debugging, testing, GitHub issue management, and documentation.

Most project tasks were discussed, reviewed, and completed collaboratively. GitHub commits, comments, and issue closures indicate who performed the final GitHub action and do not necessarily represent sole ownership of a task.

## AI Usage
AI usage during the project is documented in `documentation/AI.md`.