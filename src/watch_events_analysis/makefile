.PHONY: all clean

all: Summary_watch_events.html

../../data/watch_events/watch_events.csv:
	Rscript download_watch_events.R

Summary_watch_events.html: Summary_watch_events.qmd ../../data/watch_events/watch_events.csv
	quarto render Summary_watch_events.qmd

clean:
	Rscript -e "unlink('Summary_watch_events.html'); unlink('../../output/watch_events', recursive = TRUE)"