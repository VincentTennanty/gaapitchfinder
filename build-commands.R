# Build Commands for gaapitches Package
# Run these commands in order in a FRESH R session

cat("===============================================\n")
cat("gaapitches Package Build Commands\n")
cat("===============================================\n\n")

cat("STEP 1: Install devtools (if not already installed)\n")
cat("Command: install.packages('devtools')\n\n")

# Check if devtools is available
if (!requireNamespace("devtools", quietly = TRUE)) {
  cat("Installing devtools...\n")
  install.packages("devtools", repos = "https://cloud.r-project.org/")
}

library(devtools)

cat("\nSTEP 2: Generate documentation\n")
cat("Command: devtools::document()\n\n")
devtools::document()

cat("\nSTEP 3: Install the package\n")
cat("Command: devtools::install()\n\n")
devtools::install()

cat("\nSTEP 4: Run tests\n")
cat("Command: devtools::test()\n\n")
devtools::test()

cat("\nSTEP 5 (Optional): Run R CMD check\n")
cat("Command: devtools::check()\n")
cat("Note: This may take several minutes\n\n")
response <- readline("Run full check now? (y/n): ")
if (tolower(response) == "y") {
  devtools::check()
}

cat("\n===============================================\n")
cat("Build complete!\n")
cat("===============================================\n\n")

cat("To use the package:\n")
cat("  library(gaapitches)\n")
cat("  data(gaa_pitches)\n")
cat("  ?gaapitches\n\n")
