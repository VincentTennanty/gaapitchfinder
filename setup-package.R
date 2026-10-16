#!/usr/bin/env Rscript
# Setup script for gaapitches R package
# Run this script to prepare the package for building and testing

cat("===============================================\n")
cat("Setting up gaapitches R package\n")
cat("===============================================\n\n")

# Check if required packages are installed
required_packages <- c("devtools", "roxygen2", "usethis", "sf", "dplyr", "ggplot2", "testthat")

cat("1. Checking required packages...\n")

# Update core dependencies first to avoid version conflicts
cat("   Updating core dependencies...\n")
options(pkgType = "binary", install.packages.compile.from.source = "never")
install.packages(c("rlang", "cli"), repos = "https://cloud.r-project.org/", type = "binary")

missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(missing_packages) > 0) {
  cat("   Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, repos = "https://cloud.r-project.org/", type = "binary")
} else {
  cat("   All required packages are installed.\n")
}

cat("\n2. Loading required packages...\n")
for (pkg in c("devtools", "roxygen2", "usethis")) {
  if (!requireNamespace(pkg, quietly = TRUE)) stop(paste("Failed to install:", pkg))
  library(pkg, character.only = TRUE)
}

cat("\n3. Downloading and preparing GAA pitch data...\n")
source("data-raw/prepare_data.R")

cat("\n4. Generating package documentation...\n")
devtools::document()

cat("\n5. Building and installing the package...\n")
devtools::install()

cat("\n6. Running tests...\n")
devtools::test()

cat("\n7. Running R CMD check...\n")
devtools::check()

cat("\n===============================================\n")
cat("Setup complete!\n")
cat("===============================================\n\n")
cat("You can now use the package:\n")
cat("  library(gaapitches)\n")
cat("  data(gaa_pitches)\n")
cat("  ?gaapitches\n\n")

cat("To build the package for distribution:\n")
cat("  devtools::build()\n\n")

cat("To create a source tarball:\n")
cat("  devtools::build(binary = FALSE)\n\n")
