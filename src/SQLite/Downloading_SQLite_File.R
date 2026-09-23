# Download SQLite file from the provided URL
url <- "https://filesender.surf.nl/download.php??token=29803da2-2322-4844-aebf-7e0b95129957&files_ids=38390042"
destination_file <- "data/raw/tiktok_students.sqlite"


# Download the file
download.file(url, destfile = destination_file, mode = "wb")

cat("File downloaded successfully to:", destination_file, "\n")
