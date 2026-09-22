# Convenience target - runs all downstream outputs
all: src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html src/watch_events_analysis/Summary_watch_events.html src/Summary_videos.html

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
data/data_session/raw/sessions.csv: src/Session_analysis_alex/data_session_download.R
	Rscript src/Session_analysis_alex/data_session_download.R

# Clean raw session data
data/data_session/processed/cleaned_sessions.csv: src/Session_analysis_alex/data_session_cleaning.R data/data_session/raw/sessions.csv
	Rscript src/Session_analysis_alex/data_session_cleaning.R

# Render session analysis report
src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html: src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd data/data_session/processed/cleaned_sessions.csv
	quarto render src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.qmd

# ============================================================================
# WATCH EVENTS ANALYSIS PIPELINE
# ============================================================================

# Download raw watch events data
data/watch_events/raw/watch_events.csv: src/watch_events_analysis/download_watch_events.R
	Rscript src/watch_events_analysis/download_watch_events.R

# Clean raw watch events data
data/watch_events/processed/watch_events_cleaned.csv: src/watch_events_analysis/cleaning_watch_events.R data/watch_events/raw/watch_events.csv
	Rscript src/watch_events_analysis/cleaning_watch_events.R

# Render watch events analysis report
src/watch_events_analysis/Summary_watch_events.html: src/watch_events_analysis/Summary_watch_events.qmd data/watch_events/processed/watch_events_cleaned.csv
	quarto render src/watch_events_analysis/Summary_watch_events.qmd

# ============================================================================
# CLEANUP
# ============================================================================

clean:
	Rscript -e "unlink('data', recursive = TRUE); unlink('src/Summary_videos.html'); unlink('src/Session_analysis_alex/TikTok_Sessions_Analysis_Alex.html'); unlink('src/watch_events_analysis/Summary_watch_events.html'); unlink('output/week3', recursive = TRUE); unlink('output/watch_events', recursive = TRUE)"

.PHONY: all clean
