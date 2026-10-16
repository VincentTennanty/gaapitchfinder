test_that("pitches_within_radius returns correct structure", {
  # Dublin city center, 10km radius
  results <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 10)
  
  expect_s3_class(results, "sf")
  expect_true("distance_km" %in% names(results))
  expect_true(all(results$distance_km <= 10))
})

test_that("pitches_within_radius returns empty sf when no matches", {
  # Middle of the Atlantic Ocean
  results <- pitches_within_radius(lat = 40.0, lon = -40.0, radius = 10)
  
  expect_s3_class(results, "sf")
  expect_equal(nrow(results), 0)
  expect_true("geometry" %in% names(results))
})

test_that("pitches_within_radius results are sorted by distance", {
  results <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 20)
  
  if (nrow(results) > 1) {
    expect_true(all(diff(results$distance_km) >= 0))
  }
})

test_that("pitches_within_radius validates inputs", {
  expect_error(pitches_within_radius(lat = 100, lon = -6.2603, radius = 10), 
               "lat must be between -90 and 90")
  expect_error(pitches_within_radius(lat = 53.3498, lon = 200, radius = 10), 
               "lon must be between -180 and 180")
  expect_error(pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = -5), 
               "radius must be a positive numeric value")
  expect_error(pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = "ten"), 
               "radius must be a positive numeric value")
})

test_that("pitches_within_radius finds more pitches with larger radius", {
  small_radius <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 5)
  large_radius <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 20)
  
  expect_true(nrow(large_radius) >= nrow(small_radius))
})
