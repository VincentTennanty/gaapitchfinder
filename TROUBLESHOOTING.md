# Troubleshooting Guide for gaapitches Package

## Common Installation Issues

### Issue 1: "Permission denied" or Package Lock Errors

**Symptoms:**
```
Warning: problem copying C:\...\00LOCK\cli\libs\x64\cli.dll
Error: there is no package called 'devtools'
```

**Cause:** Some R packages are in use by the current R session or another R process.

**Solution:**

1. **Close ALL R sessions** (RStudio, R GUI, R terminals)
2. **Open a fresh R session**
3. **Install packages one at a time:**

```r
# First, install the core packages
install.packages("sf")
install.packages("dplyr")
install.packages("ggplot2")

# Then install development tools
install.packages("devtools")
install.packages("roxygen2")

# Then testing/documentation
install.packages("testthat")
install.packages("knitr")
install.packages("rmarkdown")
```

4. **After installation, close R and open a fresh session**
5. **Continue with the manual setup**

### Issue 2: Cannot Install sf Package

**Symptoms:**
```
Error: installation of package 'sf' had non-zero exit status
```

**Cause:** The sf package requires system dependencies (GDAL, GEOS, PROJ).

**Solutions by Platform:**

#### Windows
Usually sf installs without issues on Windows. If you get errors:

1. Make sure you have the latest R version (>= 4.0.0)
2. Install Rtools from: https://cran.r-project.org/bin/windows/Rtools/
3. Try installing sf again:
   ```r
   install.packages("sf", type = "binary")
   ```

#### macOS
Install system dependencies with Homebrew:
```bash
brew install gdal geos proj
```

Then in R:
```r
install.packages("sf", type = "source")
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev
```

Then in R:
```r
install.packages("sf")
```

### Issue 3: Data Download Fails

**Symptoms:**
```
Error in download.file(...): cannot download file
```

**Solution - Manual Download:**

1. Go to: https://raw.githubusercontent.com/ryanmcg2203/gaapitchfinder/main/gaapitchfinder_data.csv
2. Right-click and "Save As..."
3. Save to: `data-raw/gaapitchfinder_data.csv` (in the package directory)
4. Run the data preparation script:
   ```r
   source("data-raw/prepare_data.R")
   ```

### Issue 4: "usethis" Package Errors

**Symptoms:**
```
Error in usethis::use_data(...): could not find function "use_data"
```

**Solution:**

The data preparation script uses `usethis::use_data()`. If you don't have usethis:

```r
# Install usethis
install.packages("usethis")
```

Or modify the `data-raw/prepare_data.R` file to use base R:

Replace the line:
```r
usethis::use_data(gaa_pitches, overwrite = TRUE)
```

With:
```r
save(gaa_pitches, file = "data/gaa_pitches.rda", compress = "bzip2")
```

## Step-by-Step Manual Setup (When Automated Fails)

### Step 1: Install Prerequisites

**Close all R sessions first!**

Open a fresh R session and run:

```r
# Install essential packages
install.packages(c("sf", "dplyr", "ggplot2"))

# Wait for these to complete, then install dev tools
install.packages(c("devtools", "roxygen2", "usethis"))

# Wait for these to complete, then install testing/docs
install.packages(c("testthat", "knitr", "rmarkdown"))
```

**Close R and open a fresh session after installation.**

### Step 2: Prepare the Data

```r
# Set working directory to package folder
setwd("c:/Users/vinny/OneDrive/Documents/Data Science Work/gaapitches")

# Download and process data
source("data-raw/prepare_data.R")
```

This should create `data/gaa_pitches.rda`.

**Verify:**
```r
file.exists("data/gaa_pitches.rda")
# Should return TRUE
```

### Step 3: Build Documentation

```r
library(devtools)
document()
```

This creates help files in `man/` and updates `NAMESPACE`.

### Step 4: Install the Package

```r
devtools::install()
```

### Step 5: Test the Package

```r
# Run tests
devtools::test()

# Try loading it
library(gaapitches)
data(gaa_pitches)
head(gaa_pitches)
```

### Step 6: Full Check (Optional)

```r
devtools::check()
```

## Quick Test After Installation

After installation, verify everything works:

```r
library(gaapitches)

# 1. Check dataset loads
data(gaa_pitches)
nrow(gaa_pitches)  # Should show 1900+

# 2. Test search
dublin <- find_pitch("Dublin")
nrow(dublin)  # Should show results

# 3. Test nearest
nearest <- nearest_pitch(lat = 53.3498, lon = -6.2603)
print(nearest)  # Should show nearest pitch

# 4. Test radius
nearby <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 10)
nrow(nearby)  # Should show pitches within 10km

# 5. Test summary
summary <- county_summary()
head(summary)  # Should show county counts

# 6. Test plot (this should create a plot)
plot_pitches(dublin)
```

If all these work, your package is installed correctly!

## Alternative: Use Pre-built Scripts

If the automated setup continues to fail, use these scripts in order:

1. **setup-manual.R** - Installs dependencies and prepares data
   ```r
   source("setup-manual.R")
   ```

2. **Close R completely and reopen**

3. **build-commands.R** - Builds and installs the package
   ```r
   source("build-commands.R")
   ```

## Still Having Issues?

### Check R Version
```r
R.version.string
```
Should be R >= 3.5.0, preferably R >= 4.0.0

### Check Package Installation Directory
```r
.libPaths()
```
Make sure you have write permissions to this directory.

### Run R as Administrator (Windows)
Right-click RStudio or R and select "Run as Administrator"

### Check for Conflicting R Processes
On Windows, open Task Manager and close any R.exe or Rsession.exe processes.

## Getting Help

If you're still stuck:

1. **Check what error you're getting** - the exact error message matters
2. **Verify prerequisites** - especially sf package installation
3. **Try the manual step-by-step** - go slowly through each step
4. **Check file permissions** - make sure you can write to the package directory

## Common R Session Commands

```r
# Check installed packages
installed.packages()[, "Package"]

# Check if a package is loaded
"devtools" %in% loadedNamespaces()

# Restart R session (in RStudio)
.rs.restartR()

# Clear workspace
rm(list = ls())

# Get working directory
getwd()

# Set working directory
setwd("path/to/gaapitches")
```

## Success Checklist

- [ ] All required packages installed
- [ ] data/gaa_pitches.rda exists
- [ ] devtools::document() runs without error
- [ ] devtools::install() completes
- [ ] library(gaapitches) loads without error
- [ ] data(gaa_pitches) works
- [ ] Test functions work (find_pitch, etc.)

When all these are checked, your package is ready!
