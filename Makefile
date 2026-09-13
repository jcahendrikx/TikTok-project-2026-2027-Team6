# Convenience target so "make" runs all downstream outputs rather than only the first line of the Makefile
all: src/Session_analysis_alex/Tiktok_Sessions_Analysis_Alex.html

# Download raw data if it doesn't exist
# Only runs if the CSV is missing or the script changes
data/data_session/raw/sessions.csv: src/Session_analysis_alex/data_session_download.R
	Rscript src/Session_analysis_alex/data_session_download.R

# Clean raw data to produce processed CSV
# Requires the raw data AND the cleaning script; runs only if either changes
data/data_session/processed/cleaned_sessions.csv: src/Session_analysis_alex/data_session_cleaning.R data/data_session/raw/sessions.csv
	Rscript src/Session_analysis_alex/data_session_cleaning.R

# Render the Quarto analysis report
# Only runs if the source .qmd or processed data changes
src/Session_analysis_alex/Tiktok_Sessions_Analysis_Alex.html: src/Session_analysis_alex/Tiktok_Sessions_Analysis_Alex.qmd data/data_session/processed/cleaned_sessions.csv
	quarto render src/Session_analysis_alex/Tiktok_Sessions_Analysis_Alex.qmd

.PHONY: all