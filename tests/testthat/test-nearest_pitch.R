test_that("nearest_pitch returns correct structure", {
  # Dublin city center coordinates
  result <- nearest_pitch(lat = 53.3498, lon = -6.2603)
  
  expect_s3_class(result, "sf")
  expect_equal(nrow(result), 1)
  expect_true("distance_km" %in% names(result))
  expect_true(is.numeric(result$distance_km))
})

test_that("nearest_pitch returns multiple results when n > 1", {
  results <- nearest_pitch(lat = 53.3498, lon = -6.2603, n = 5)
  
  expect_s3_class(results, "sf")
  expect_equal(nrow(results), 5)
  expect_true(all(diff(results$distance_km) >= 0))  # Should be sorted by distance
})

test_that("nearest_pitch validates coordinates", {
  expect_error(nearest_pitch(lat = 100, lon = -6.2603), "lat must be between -90 and 90")
  expect_error(nearest_pitch(lat = 53.3498, lon = 200), "lon must be between -180 and 180")
  expect_error(nearest_pitch(lat = "invalid", lon = -6.2603), "lat must be a single numeric value")
})

test_that("nearest_pitch validates n parameter", {
  expect_error(nearest_pitch(lat = 53.3498, lon = -6.2603, n = -1), "n must be a positive integer")
  expect_error(nearest_pitch(lat = 53.3498, lon = -6.2603, n = "five"), "n must be a positive integer")
})

test_that("nearest_pitch calculates reasonable distances", {
  # Dublin city center to nearest pitch
  result <- nearest_pitch(lat = 53.3498, lon = -6.2603)
  
  # Distance should be reasonable (not negative, not impossibly large)
  expect_true(result$distance_km >= 0)
  expect_true(result$distance_km < 100)  # Should be within 100km for Dublin
})
