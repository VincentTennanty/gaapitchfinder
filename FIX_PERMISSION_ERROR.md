# Fix: Permission Denied / Package Lock Error

## Your Current Error

You're seeing:
```
Warning: problem copying C:\...\00LOCK\cli\libs\x64\cli.dll
Error: there is no package called 'devtools'
```

## What's Happening

Some R packages (cli, rlang) are currently in use and locked. This prevents installation of new packages like devtools.

## ✅ Solution (Step-by-Step)

### Step 1: Close All R Sessions

1. **Close RStudio completely** (not just the window - actually quit)
2. **Open Task Manager** (Ctrl+Shift+Esc)
3. **Look for any R processes**:
   - R.exe
   - Rsession.exe
   - rstudio.exe
4. **End all R-related processes**
5. **Wait 10 seconds**

### Step 2: Open Fresh R Session

1. **Open RStudio as Administrator**:
   - Right-click RStudio icon
   - Select "Run as administrator"

2. **Set working directory**:
   ```r
   setwd("c:/Users/vinny/OneDrive/Documents/Data Science Work/gaapitches")
   ```

### Step 3: Install Packages Manually

**Copy and paste these commands ONE AT A TIME:**

```r
# Install core spatial packages
install.packages("sf")
```

Wait for this to complete, then:

```r
# Install tidyverse packages
install.packages("dplyr")
install.packages("ggplot2")
```

Wait for completion, then:

```r
# Install development tools
install.packages("devtools")
install.packages("roxygen2")
install.packages("usethis")
```

Wait for completion, then:

```r
# Install testing/documentation
install.packages("testthat")
install.packages("knitr")
install.packages("rmarkdown")
```

### Step 4: Verify Installation

```r
# Check that devtools installed
library(devtools)
# Should load without error
```

### Step 5: Prepare the Data

```r
# Make sure you're in the right directory
getwd()
# Should show: "c:/Users/vinny/OneDrive/Documents/Data Science Work/gaapitches"

# Run data preparation
source("data-raw/prepare_data.R")
```

This downloads the CSV and creates the .rda file.

**Verify:**
```r
file.exists("data/gaa_pitches.rda")
# Should return TRUE
```

### Step 6: Build the Package

```r
# Generate documentation
devtools::document()

# Install the package
devtools::install()
```

### Step 7: Test It Works

```r
# Load the package
library(gaapitches)

# Load the dataset
data(gaa_pitches)

# Check it
nrow(gaa_pitches)
# Should show 1900+ rows

# Try a function
dublin <- find_pitch("Dublin")
print(dublin)
```

## ✅ Success!

If the above works, your package is installed! You can now:

```r
# Run tests
devtools::test()

# Full validation
devtools::check()
```

## 🔄 Alternative: Use Manual Setup Script

If you still have issues, try:

```r
source("setup-manual.R")
```

Then **close R completely**, reopen, and run:

```r
source("build-commands.R")
```

## Still Not Working?

### Try This:

1. **Restart your computer** (to release all file locks)
2. **Open RStudio as Administrator**
3. **Run the manual steps above again**

### Or Use Pre-Downloaded Data:

If internet download is the issue:

1. Go to: https://raw.githubusercontent.com/ryanmcg2203/gaapitchfinder/main/gaapitchfinder_data.csv
2. Right-click → Save As
3. Save to: `data-raw/gaapitchfinder_data.csv`
4. Run: `source("data-raw/prepare_data.R")`

## Need More Help?

See **TROUBLESHOOTING.md** for:
- sf package installation issues
- System dependency problems
- Other common errors

---

**Quick Summary:**
1. Close ALL R sessions
2. Open R as Administrator
3. Install packages one by one
4. Run data preparation
5. Build package with devtools
6. Test it works
