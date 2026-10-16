# gaapitches R Package - Build Checklist

Use this checklist to build, test, and validate the package before distribution or CRAN submission.

## Pre-Build Setup

- [ ] R (>= 3.5.0) is installed
- [ ] RStudio is installed (recommended)
- [ ] Internet connection available for initial setup

## Initial Setup

### Automated Setup (Recommended)

- [ ] Open R/RStudio
- [ ] Set working directory to package folder
- [ ] Run `source("setup-package.R")`
- [ ] Wait for completion (5-10 minutes)
- [ ] Check console output for any errors

### Manual Setup (Alternative)

- [ ] Install devtools: `install.packages("devtools")`
- [ ] Install dependencies: `install.packages(c("roxygen2", "usethis", "sf", "dplyr", "ggplot2", "testthat", "knitr", "rmarkdown"))`
- [ ] Run data preparation: `source("data-raw/prepare_data.R")`
- [ ] Generate documentation: `devtools::document()`
- [ ] Install package: `devtools::install()`

## Verification

### Check Data Preparation

```r
# Data file should exist
file.exists("data/gaa_pitches.rda")
# Should return TRUE

# Load and check the data
load("data/gaa_pitches.rda")
nrow(gaa_pitches)
# Should show 1900+ rows

# Check structure
class(gaa_pitches)
# Should be c("sf", "data.frame")

sf::st_crs(gaa_pitches)$epsg
# Should be 4326
```

- [ ] gaa_pitches.rda file exists in data/ directory
- [ ] Dataset has 1900+ rows
- [ ] Dataset is an sf object
- [ ] CRS is EPSG:4326 (WGS84)

### Check Documentation

```r
# Check that help files exist
?gaapitches
?gaa_pitches
?find_pitch
?nearest_pitch
?pitches_within_radius
?county_summary
?plot_pitches
```

- [ ] Package help file loads
- [ ] Dataset help file loads
- [ ] All function help files load
- [ ] Examples in help files are runnable

### Check Package Installation

```r
library(gaapitches)

# Check package loads without errors
# Check that dataset is available
data(gaa_pitches)
head(gaa_pitches)
```

- [ ] Package loads without errors
- [ ] No warning messages
- [ ] Dataset is accessible

### Test Functions

```r
library(gaapitches)

# Test find_pitch
result1 <- find_pitch("Dublin")
nrow(result1) > 0  # Should be TRUE

# Test nearest_pitch
result2 <- nearest_pitch(lat = 53.3498, lon = -6.2603)
nrow(result2) == 1  # Should be TRUE

# Test pitches_within_radius
result3 <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 10)
nrow(result3) > 0  # Should be TRUE
all(result3$distance_km <= 10)  # Should be TRUE

# Test county_summary
result4 <- county_summary()
nrow(result4) > 0  # Should be TRUE

# Test plot_pitches
result5 <- plot_pitches(result1)
class(result5)[1] == "gg"  # Should be TRUE
```

- [ ] find_pitch() works
- [ ] nearest_pitch() works
- [ ] pitches_within_radius() works
- [ ] county_summary() works
- [ ] plot_pitches() works

### Run Test Suite

```r
devtools::test()
```

- [ ] All tests pass
- [ ] No test failures
- [ ] No unexpected warnings

Expected output: All tests should show "✓" (checkmark) or "PASS"

## Package Validation

### Run R CMD Check

```r
devtools::check()
```

**Target**: 0 errors, 0 warnings, 0 notes

- [ ] 0 errors
- [ ] 0 warnings  
- [ ] 0 notes (or acceptable notes only)

Common acceptable notes:
- "New submission" (for first CRAN submission)
- Size of tarball (if <5MB, usually okay)

### Check Vignette

```r
# Build vignettes
devtools::build_vignettes()

# View vignette
vignette("getting-started", package = "gaapitches")
```

- [ ] Vignette builds without errors
- [ ] Vignette displays correctly
- [ ] All code examples in vignette run
- [ ] Plots render properly

### Cross-Platform Testing (Optional but Recommended)

For CRAN submission, test on multiple platforms:

#### Windows
```r
devtools::check()
```
- [ ] Check passes on Windows

#### macOS (if available)
```r
devtools::check()
```
- [ ] Check passes on macOS

#### Linux (if available)
```r
devtools::check()
```
- [ ] Check passes on Linux

#### Online Services (Alternative)
- [ ] Test on R-hub: `devtools::check_rhub()`
- [ ] Test on win-builder: `devtools::check_win_devel()`

## Documentation Quality

### README.md
- [ ] Contains clear package description
- [ ] Installation instructions are accurate
- [ ] Quick start examples work
- [ ] Links to documentation

### DESCRIPTION File
- [ ] Package name is correct
- [ ] Version number is correct
- [ ] Authors are listed
- [ ] License is specified
- [ ] Dependencies are complete
- [ ] URLs are correct

### NEWS.md
- [ ] Version 0.1.0 is documented
- [ ] Features are listed
- [ ] Initial release is noted

### LICENSE
- [ ] MIT License text is present
- [ ] Copyright holder is correct
- [ ] Year is correct

### Function Documentation
- [ ] All exported functions have @export tag
- [ ] All functions have @param documentation
- [ ] All functions have @return documentation
- [ ] All functions have @examples
- [ ] Examples are runnable
- [ ] Examples don't require external data

## Code Quality

### Style and Consistency
- [ ] Code follows consistent style
- [ ] Variable names are clear
- [ ] Functions have clear purpose
- [ ] Comments explain complex logic

### Error Handling
- [ ] Functions validate inputs
- [ ] Error messages are clear and helpful
- [ ] Edge cases are handled

### Performance
- [ ] No unnecessary computations
- [ ] Spatial operations are efficient
- [ ] Functions return quickly for typical use cases

## Build Package for Distribution

### Source Package
```r
devtools::build()
```

- [ ] Build completes without errors
- [ ] .tar.gz file is created
- [ ] File size is reasonable (<5MB preferred)

### Binary Package (Optional)
```r
devtools::build(binary = TRUE)
```

- [ ] Binary build completes
- [ ] Platform-specific package created

## Pre-CRAN Submission (If Applicable)

### Final Checks
- [ ] Package name is available on CRAN: `available::available("gaapitches")`
- [ ] All examples run in <5 seconds each
- [ ] No absolute paths in code or examples
- [ ] No \dontrun{} in examples (or justified)
- [ ] All URLs are reachable
- [ ] Data is documented with @source
- [ ] Data attribution is clear

### CRAN Policy Compliance
- [ ] Package description >65 characters
- [ ] No "This package..." in description
- [ ] No package name in description start
- [ ] License is acceptable to CRAN
- [ ] Imports are all used
- [ ] No unnecessary dependencies
- [ ] Examples don't write to home directory
- [ ] No system commands without safeguards

### Documentation Files
- [ ] DESCRIPTION is complete
- [ ] NEWS.md exists
- [ ] README.md exists  
- [ ] LICENSE file exists
- [ ] All .Rd files are valid

### Build CRAN Release
```r
# Final check
devtools::check(cran = TRUE)

# Build source tarball
pkg_file <- devtools::build()
```

- [ ] CRAN check passes completely
- [ ] Source tarball builds successfully
- [ ] Ready for submission

## Post-Build

### Local Testing
- [ ] Install from built package
- [ ] Test in clean R session
- [ ] Verify all functions work
- [ ] Check vignette displays

### Version Control
- [ ] All files are committed to git
- [ ] .gitignore excludes build files
- [ ] .Rbuildignore is correct
- [ ] Push to GitHub

### Distribution
- [ ] Package is on GitHub
- [ ] README displays on GitHub
- [ ] Installation instructions tested
- [ ] Users can install with `devtools::install_github()`

## CRAN Submission Process (When Ready)

1. **Pre-submission**
   - [ ] All above checks complete
   - [ ] Package passes `check(cran = TRUE)`
   - [ ] Test results available for multiple platforms

2. **Submission**
   - [ ] Go to https://cran.r-project.org/submit.html
   - [ ] Upload .tar.gz file
   - [ ] Fill in submission form
   - [ ] Confirm email verification

3. **Post-submission**
   - [ ] Respond to automated checks
   - [ ] Address any CRAN maintainer feedback
   - [ ] Wait for acceptance (typically 1-2 weeks)

## Troubleshooting

### Common Issues

**Data file not found**
- Check `data/gaa_pitches.rda` exists
- Re-run `source("data-raw/prepare_data.R")`

**Documentation missing**
- Run `devtools::document()`
- Check roxygen2 comments are correct

**Tests fail**
- Check all dependencies installed
- Verify data is loaded
- Run individual tests to isolate issue

**Check fails with warnings**
- Review warning messages
- Fix issues one at a time
- Re-run check after each fix

**sf package issues**
- Install system dependencies (GDAL, GEOS, PROJ)
- See INSTALL.md for platform-specific instructions

## Success Criteria

✅ **Package is ready when:**

- [ ] `devtools::check()` shows 0 errors, 0 warnings, 0 notes
- [ ] All tests pass
- [ ] Vignette builds and displays correctly
- [ ] Documentation is complete
- [ ] Examples all run successfully
- [ ] Package installs and loads without issues
- [ ] All exported functions work as expected
- [ ] Data is accessible and properly formatted

---

**Date Completed**: __________  
**Built By**: __________  
**Version**: 0.1.0  
**Ready for**: ☐ Local Use | ☐ GitHub | ☐ CRAN
