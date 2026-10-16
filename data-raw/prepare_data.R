# Data preparation script for gaa_pitches dataset
# This script downloads the GAA pitch data from GitHub and processes it into an sf object

library(sf)
library(dplyr)

# Download the data from GitHub
url <- "https://raw.githubusercontent.com/ryanmcg2203/gaapitchfinder/main/gaapitchfinder_data.csv"
data_file <- "data-raw/gaapitchfinder_data.csv"

# Download if not already present
if (!file.exists(data_file)) {
  download.file(url, data_file, mode = "wb")
}

# Read the CSV data
pitch_data <- read.csv(data_file, stringsAsFactors = FALSE)

# Select and rename columns according to package requirements
gaa_pitches <- pitch_data %>%
  select(
    club = Club,
    pitch = Pitch,
    county = County,
    province = Province,
    latitude = Latitude,
    longitude = Longitude,
    country = Country,
    elevation = Elevation,
    annual_rainfall,
    rain_days,
    directions = Directions,
    twitter = Twitter,
    wikipedia = Wikipedia
  ) %>%
  # Filter out rows with missing coordinates
  filter(!is.na(latitude) & !is.na(longitude)) %>%
  # Convert to sf object with WGS84 coordinate system (EPSG:4326)
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)

# Reorder columns to have geometry last
gaa_pitches <- gaa_pitches %>%
  select(club, pitch, county, province, country, latitude, longitude, 
         elevation, annual_rainfall, rain_days, directions, twitter, 
         wikipedia, geometry)

# Save as RData file
usethis::use_data(gaa_pitches, overwrite = TRUE)

# Print summary
cat("GAA Pitches dataset prepared successfully!\n")
cat("Total pitches:", nrow(gaa_pitches), "\n")
cat("Counties:", length(unique(gaa_pitches$county)), "\n")
cat("Provinces:", length(unique(gaa_pitches$province[!is.na(gaa_pitches$province)])), "\n")
