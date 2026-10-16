# Quick Start Guide for gaapitches R Package

Welcome! This guide will help you get the gaapitches R package up and running in just a few minutes.

## What You'll Need

- R (version 3.5.0 or higher) installed on your computer
- RStudio (recommended but not required)
- Internet connection for initial setup (to download dependencies and data)

## Step-by-Step Setup

### Option 1: Automated Setup (Easiest)

1. **Open R or RStudio** and set your working directory to the package folder:
   ```r
   setwd("c:/Users/vinny/OneDrive/Documents/Data Science Work/gaapitches")
   ```

2. **Run the automated setup script**:
   ```r
   source("setup-package.R")
   ```

   This will automatically:
   - Install all required packages
   - Download the GAA pitch data from GitHub
   - Build the package
   - Run tests
   - Install the package locally

3. **Wait for completion** - this may take 5-10 minutes depending on your system and internet speed.

### Option 2: Manual Setup (More Control)

1. **Install required packages**:
   ```r
   install.packages(c("devtools", "roxygen2", "usethis", "sf", "dplyr", 
                      "ggplot2", "testthat", "knitr", "rmarkdown"))
   ```

2. **Set working directory**:
   ```r
   setwd("c:/Users/vinny/OneDrive/Documents/Data Science Work/gaapitches")
   ```

3. **Download and prepare the data**:
   ```r
   source("data-raw/prepare_data.R")
   ```

4. **Build package documentation**:
   ```r
   library(devtools)
   document()
   ```

5. **Install the package**:
   ```r
   install()
   ```

6. **Run tests** (optional):
   ```r
   test()
   ```

## Verify Installation

After setup is complete, verify everything works:

```r
# Load the package
library(gaapitches)

# Load the dataset
data(gaa_pitches)

# Check how many pitches we have
nrow(gaa_pitches)
# Should show 1900+ pitches

# View the first few rows
head(gaa_pitches)
```

## Your First Analysis

Try these simple examples:

### 1. Search for Pitches

```r
# Find Croke Park
croke <- find_pitch("Croke Park")
print(croke)

# Find all pitches in Cork
cork <- find_pitch("Cork")
nrow(cork)
```

### 2. Find Nearest Pitches

```r
# Find nearest pitch to Dublin city center (53.3498°N, 6.2603°W)
nearest <- nearest_pitch(lat = 53.3498, lon = -6.2603)
print(nearest)
```

### 3. Find Pitches Within a Radius

```r
# Find pitches within 10km of Dublin
nearby <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 10)
nrow(nearby)
```

### 4. Get County Statistics

```r
# Get pitch counts by county
summary <- county_summary()
head(summary)

# Get counts for Munster only
munster <- county_summary(province = "Munster")
print(munster)
```

### 5. Create a Visualization

```r
# Plot all Dublin pitches
dublin <- find_pitch("Dublin")
plot_pitches(dublin, color = "county")
```

## Next Steps

### Learn More

1. **Read the vignette** for detailed examples:
   ```r
   vignette("getting-started", package = "gaapitches")
   ```

2. **Check function documentation**:
   ```r
   ?find_pitch
   ?nearest_pitch
   ?pitches_within_radius
   ?county_summary
   ?plot_pitches
   ```

3. **Explore the dataset**:
   ```r
   ?gaa_pitches
   str(gaa_pitches)
   summary(gaa_pitches)
   ```

### Try a Complete Workflow

```r
library(gaapitches)

# 1. Find your area of interest
galway_pitches <- find_pitch("Galway")

# 2. Find nearest pitches to Galway city
nearest_to_galway <- nearest_pitch(lat = 53.2707, lon = -9.0568, n = 5)

# 3. Find all pitches within 20km
area_pitches <- pitches_within_radius(lat = 53.2707, lon = -9.0568, radius = 20)

# 4. Visualize the results
plot_pitches(area_pitches, color = "county") +
  ggplot2::labs(title = "GAA Pitches near Galway")

# 5. Get statistics
galway_stats <- county_summary() %>%
  dplyr::filter(county == "Galway")
print(galway_stats)
```

## Common Issues & Solutions

### Issue: sf package won't install

**Solution**: The sf package requires system dependencies. 

- On Windows: Usually works out of the box
- On macOS: `brew install gdal geos proj`
- On Ubuntu/Debian: `sudo apt-get install libgdal-dev libgeos-dev libproj-dev`

### Issue: Can't download the data

**Solution**: If the automatic download fails:

1. Go to: https://raw.githubusercontent.com/ryanmcg2203/gaapitchfinder/main/gaapitchfinder_data.csv
2. Save the file as `data-raw/gaapitchfinder_data.csv`
3. Run `source("data-raw/prepare_data.R")` again

### Issue: Tests fail

**Solution**: Make sure:
- The data file exists: `file.exists("data/gaa_pitches.rda")`
- All dependencies are installed
- You're using R >= 3.5.0

## Getting Help

- **Package documentation**: `?gaapitches`
- **Function help**: `?function_name`
- **Vignette**: `vignette("getting-started")`
- **GitHub issues**: https://github.com/ryanmcg2203/gaapitchfinder/issues
- **Detailed install guide**: See `INSTALL.md`
- **Package summary**: See `PACKAGE_SUMMARY.md`

## What's Next?

Now that you have the package working, you can:

1. Use it for your own GAA pitch analysis
2. Integrate it into your research or reporting workflows
3. Combine it with other spatial datasets
4. Create custom visualizations and maps
5. Contribute improvements via GitHub

## Data Attribution

Remember to credit the data source when using this package:

"GAA Pitch Finder by Ryan McGuinness" - https://gaapitchfinder.com

The dataset is licensed under CC BY 4.0.

---

**Package Version**: 0.1.0  
**Last Updated**: October 2026  
**License**: MIT (code) + CC BY 4.0 (data)
