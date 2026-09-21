.PHONY: all clean

all: Summary_watch_events.html

# Downloading the Raw Dataset
../../data/watch_events/raw/watch_events.csv:
	Rscript download_watch_events.R

#Cleaning the Raw Dataset
../../data/watch_events/cleaned/watch_events_cleaned.csv:cleaning_watch_events.R ../../data/watch_events/raw/watch_events.csv
	Rscript cleaning_watch_events.R

#Analysis of the data
Summary_watch_events.html: Summary_watch_events.qmd ../../data/watch_events/cleaned/watch_events_cleaned.csv
	quarto render Summary_watch_events.qmd

clean:
	Rscript -e "unlink('Summary_watch_events.html'); unlink('../../output/watch_events', recursive = TRUE)"; unlink('../../data/watch_events/cleaned', recursive = TRUE)