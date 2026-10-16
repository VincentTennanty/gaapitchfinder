test_that("find_pitch returns matching results", {
  # Test successful search
  results <- find_pitch("Dublin")
  expect_s3_class(results, "sf")
  expect_true(nrow(results) > 0)
  
  # Test case insensitivity
  results_lower <- find_pitch("dublin")
  results_upper <- find_pitch("DUBLIN")
  expect_equal(nrow(results_lower), nrow(results_upper))
})

test_that("find_pitch returns empty sf object when no matches", {
  results <- find_pitch("xyznonexistent123")
  expect_s3_class(results, "sf")
  expect_equal(nrow(results), 0)
  expect_true("geometry" %in% names(results))
})

test_that("find_pitch validates input", {
  expect_error(find_pitch(123), "search_term must be a single character string")
  expect_error(find_pitch(c("test", "test2")), "search_term must be a single character string")
  expect_error(find_pitch(""), "search_term cannot be an empty string")
})

test_that("find_pitch searches across multiple columns", {
  # Should find matches in club, pitch, or county names
  results <- find_pitch("Cork")
  expect_true(nrow(results) > 0)
  
  # Check that results contain the search term in at least one column
  contains_term <- apply(results, 1, function(row) {
    grepl("cork", tolower(row["club"])) || 
    grepl("cork", tolower(row["pitch"])) || 
    grepl("cork", tolower(row["county"]))
  })
  expect_true(all(contains_term))
})
