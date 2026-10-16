# Installation and Setup Instructions

This document provides step-by-step instructions for setting up and building the gaapitches R package.

## Prerequisites

You need R (>= 3.5.0) installed on your system. The package also requires several dependencies that will be automatically installed.

## Quick Setup

The easiest way to set up the package is to run the provided setup script:

```r
source("setup-package.R")
```

This will:
1. Install required dependencies
2. Download and prepare the GAA pitch data
3. Generate documentation
4. Build and install the package
5. Run tests
6. Run R CMD check

## Manual Setup

If you prefer to set up the package manually, follow these steps:

### Step 1: Install Dependencies

```r
install.packages(c("devtools", "roxygen2", "usethis", "sf", "dplyr", "ggplot2", "testthat", "knitr", "rmarkdown"))
```

### Step 2: Prepare the Data

The package needs to download and process the GAA pitch data from GitHub:

```r
source("data-raw/prepare_data.R")
```

This will:
- Download the raw CSV data from https://github.com/ryanmcg2203/gaapitchfinder
- Process it into an sf object with proper coordinate system
- Save it as gaa_pitches.rda in the data/ directory

### Step 3: Generate Documentation

Generate the package documentation from roxygen2 comments:

```r
devtools::document()
```

This creates:
- Help files in man/
- NAMESPACE file with exports and imports

### Step 4: Install the Package

Install the package locally:

```r
devtools::install()
```

### Step 5: Run Tests

Run the test suite to verify everything works:

```r
devtools::test()
```

### Step 6: Run R CMD Check

Run comprehensive package checks:

```r
devtools::check()
```

The package should pass with no errors, warnings, or notes.

## Building the Package

### Build Binary Package

```r
devtools::build()
```

### Build Source Tarball

```r
devtools::build(binary = FALSE)
```

This creates a `.tar.gz` file that can be submitted to CRAN or shared with others.

## Loading and Using the Package

After installation:

```r
library(gaapitches)

# Access the dataset
data(gaa_pitches)
head(gaa_pitches)

# Use the functions
find_pitch("Dublin")
nearest_pitch(lat = 53.3498, lon = -6.2603)
county_summary()
```

## Viewing Documentation

```r
# Package overview
?gaapitches

# Dataset documentation
?gaa_pitches

# Function documentation
?find_pitch
?nearest_pitch
?pitches_within_radius
?county_summary
?plot_pitches

# Vignette
vignette("getting-started", package = "gaapitches")
```

## Troubleshooting

### sf Package Installation Issues

The sf package requires system dependencies (GDAL, GEOS, PROJ). If you encounter installation errors:

**Ubuntu/Debian:**
```bash
sudo apt-get install libgdal-dev libgeos-dev libproj-dev
```

**macOS (with Homebrew):**
```bash
brew install gdal geos proj
```

**Windows:**
The sf package typically installs without issues on Windows. If you encounter problems, try installing from source or using RTools.

### Data Download Issues

If the data download fails, you can manually download the CSV:

1. Go to https://raw.githubusercontent.com/ryanmcg2203/gaapitchfinder/main/gaapitchfinder_data.csv
2. Save it as `data-raw/gaapitchfinder_data.csv`
3. Run `source("data-raw/prepare_data.R")` again

### Test Failures

If tests fail, ensure:
- The data has been prepared (gaa_pitches.rda exists in data/)
- All dependencies are installed
- You're using R >= 3.5.0

## Development Workflow

For package development:

```r
# Make changes to R files...

# Update documentation
devtools::document()

# Run tests
devtools::test()

# Check package
devtools::check()

# Install updated version
devtools::install()
```

## Submitting to CRAN

Before CRAN submission:

1. Ensure `R CMD check` passes with no errors, warnings, or notes
2. Update version number in DESCRIPTION
3. Update NEWS.md with changes
4. Build the source tarball: `devtools::build()`
5. Test on multiple platforms (Windows, macOS, Linux)
6. Submit via https://cran.r-project.org/submit.html

## Getting Help

- View package documentation: `?gaapitches`
- Read the vignette: `vignette("getting-started")`
- Check GitHub issues: https://github.com/ryanmcg2203/gaapitchfinder/issues
