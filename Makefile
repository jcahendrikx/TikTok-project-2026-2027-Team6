# Convenience target - runs all downstream outputs
all: src/SQLite/SQL_Summary.html src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html src/watch_events_analysis/Summary_watch_events.html src/Summary_videos.html output/final_report/Final_Analysis_Summary.pdf
# ============================================================================
# SQLITE PIPELINE
# ============================================================================

# Download SQLite database
data/raw/tiktok_students.sqlite: src/SQLite/Downloading_SQLite_File.R
	Rscript src/SQLite/Downloading_SQLite_File.R

# Render SQLite summary
src/SQLite/SQL_Summary.html: src/SQLite/SQL_Summary.qmd data/raw/tiktok_students.sqlite
	quarto render src/SQLite/SQL_Summary.qmd

# ============================================================================
# VIDEO ANALYSIS PIPELINE
# ============================================================================

# Download raw video view data
data/raw/video_view.csv: src/downloading_videodata_script.R
	Rscript src/downloading_videodata_script.R

# Render video analysis report
src/Summary_videos.html: src/Summary_videos.qmd data/raw/video_view.csv
	quarto render src/Summary_videos.qmd

# ============================================================================
# SESSION ANALYSIS PIPELINE
# ============================================================================

# Download raw session data
data/raw/sessions.csv: src/Session_analysis_alex/data_session_download.R
	Rscript src/Session_analysis_alex/data_session_download.R

# Clean raw session data
data/processed/cleaned_sessions.csv: src/Session_analysis_alex/data_session_cleaning.R data/raw/sessions.csv
	Rscript src/Session_analysis_alex/data_session_cleaning.R

# Render session analysis report
src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html: src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd data/processed/cleaned_sessions.csv
	quarto render src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd

# ============================================================================
# WATCH EVENTS ANALYSIS PIPELINE
# ============================================================================

# Download raw watch events data
data/raw/watch_events.csv: src/watch_events_analysis/download_watch_events.R
	Rscript src/watch_events_analysis/download_watch_events.R

# Clean raw watch events data
data/processed/watch_events_cleaned.csv: src/watch_events_analysis/cleaning_watch_events.R data/raw/watch_events.csv
	Rscript src/watch_events_analysis/cleaning_watch_events.R

# Render watch events analysis report
src/watch_events_analysis/Summary_watch_events.html: src/watch_events_analysis/Summary_watch_events.qmd data/processed/watch_events_cleaned.csv
	quarto render src/watch_events_analysis/Summary_watch_events.qmd

# ============================================================================
# REGRESSION ANALYSIS PIPELINE
# ============================================================================

# Run session-level regression analysis
output/regression/model_comparison.csv: src/regression_analysis/regression_analysis.R data/processed/cleaned_sessions.csv
	Rscript src/regression_analysis/regression_analysis.R

# ============================================================================
# FINAL REPORT PIPELINE
# ============================================================================

# Render the final analysis report
output/final_report/Final_Analysis_Summary.pdf: src/Final_Analysis_Summary.qmd data/raw/video_view.csv data/processed/cleaned_sessions.csv data/processed/watch_events_cleaned.csv output/regression/model_comparison.csv
	quarto render src/Final_Analysis_Summary.qmd --to pdf --output-dir ../output/final_report

# ============================================================================
# CLEANUP
# ============================================================================

clean:
	Rscript -e "unlink('data', recursive = TRUE); unlink(c('src/Summary_videos.html', 'src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html', 'src/watch_events_analysis/Summary_watch_events.html', 'src/SQLite/SQL_Summary.html')); unlink(c('output/week3', 'output/watch_events', 'output/session_analysis', 'output/regression', 'output/final_report'), recursive = TRUE)"

.PHONY: all clean
