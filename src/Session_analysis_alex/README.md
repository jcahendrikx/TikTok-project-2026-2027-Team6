# TikTok-project-2026-Team6
Tilburg University
Data Preparation & Programming

Project Owners: 
- Alex Hendrikx

Feedback Given by:
- Nanyun Zhang

## Project Goal
The goal of this part of the project is to create a visual overview of the TikTok session data file using ggplot2.

## Folder structure
The main files used in the project are:
- `src/Session_analysis_alex/data_session_download.R` — downloads the TikTok session dataset.
- `src/Session_analysis_alex/data_session_cleaning.R` — cleans the Tiktok session dataset.
- `src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd` — summarizes the Tiktok session dataset visually using multiple plots.
- `Makefile` - runs the script based on the existence of the outputs

## Data
The raw dataset is downloaded to `data/data_session/raw/sessions.csv`
The cleaned dataset is saved in `data/data_session/processed/cleaned_sessions.csv`

Note: All data and output files are stored outside the analysis folder (`src/Session_analysis_alex`) and referenced with paths relative to the root project (e.g., `data/data_session/...`, `output/week3/...`)


## Requirements
The following software and R packages are required:
- R
- Quarto
- GNU Make
- tidyverse
- here
- janitor

The required R packages can be installed using:

```r
install.packages("tidyverse")
install.packages("here")
install.packages("janitor")
```

## Reproducing the Analysis

### Manual Option
The first option to reproduce the analysis is to run each file manually one for one. To do that, run the following commands from the root folder of the repository.

First, download the dataset:

```bash
Rscript src/Session_analysis_alex/data_session_download.R
```

Then clean the Dataset

```bash
Rscript src/Session_analysis_alex/data_session_cleaning.R
```

Then render the Quarto analysis:

```bash
quarto render src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd
```
### Makefile

Another option is to run the Makefile from the root repository:

```bash
make
```

To remove generated processed data and plot outputs and rebuild the workflow from scratch, run:

```bash
make clean
make
```

The `clean` target keeps the raw downloaded dataset but removes the processed dataset and generated plot outputs so that they can be rebuilt.

The Quarto document reads the cleaned data from `data/data_session/processed` and produces an HTML summary containing summaries and visualizations. Additionally, these visualizations are stored in `output/session_analysis/`.


## Troubleshooting

- If `Rscript` is not recognized, check that R is installed and available on the system PATH.
- If the dataset cannot be found, run the data download script before rendering the Quarto document.
- If Quarto cannot locate R, run `quarto check` to verify the R installation.


## AI Usage
AI usage during the project is documented in `documentation/AI.md`.