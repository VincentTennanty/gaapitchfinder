#!/usr/bin/env Rscript
# Manual setup script for gaapitches R package
# Use this if the automated setup has permission issues

cat("===============================================\n")
cat("Manual Setup for gaapitches R package\n")
cat("===============================================\n\n")

cat("IMPORTANT: Close all R sessions except this one before proceeding!\n\n")
cat("Press Enter to continue or Ctrl+C to cancel...")
readline()

# Step 1: Check required packages
cat("\n1. Checking required packages...\n")
required_packages <- c("sf", "dplyr", "ggplot2", "testthat", "knitr", "rmarkdown")

missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(missing_packages) > 0) {
  cat("   Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, repos = "https://cloud.r-project.org/")
} else {
  cat("   All required packages are installed.\n")
}

# Step 2: Download and prepare data
cat("\n2. Downloading and preparing GAA pitch data...\n")
cat("   This may take a few minutes...\n")
source("data-raw/prepare_data.R")

cat("\n===============================================\n")
cat("Basic setup complete!\n")
cat("===============================================\n\n")

cat("Next steps:\n\n")
cat("1. Close this R session completely\n")
cat("2. Open a fresh R session\n")
cat("3. Install devtools: install.packages('devtools')\n")
cat("4. Run: devtools::document()\n")
cat("5. Run: devtools::install()\n")
cat("6. Run: devtools::test()\n\n")

cat("Or run the commands in build-commands.R\n")
