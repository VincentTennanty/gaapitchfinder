test_that("gaa_pitches dataset loads correctly", {
  data(gaa_pitches, envir = environment())
  
  expect_s3_class(gaa_pitches, "sf")
  expect_true(nrow(gaa_pitches) > 1000)  # Should have many pitches
})

test_that("gaa_pitches has correct coordinate system", {
  data(gaa_pitches, envir = environment())
  
  crs <- sf::st_crs(gaa_pitches)
  expect_equal(crs$epsg, 4326)
})

test_that("gaa_pitches has required columns", {
  data(gaa_pitches, envir = environment())
  
  required_cols <- c("club", "pitch", "county", "province", "latitude", 
                     "longitude", "geometry")
  
  expect_true(all(required_cols %in% names(gaa_pitches)))
})

test_that("gaa_pitches coordinates are valid", {
  data(gaa_pitches, envir = environment())
  
  # Check that latitudes and longitudes are in valid ranges
  expect_true(all(gaa_pitches$latitude >= -90 & gaa_pitches$latitude <= 90))
  expect_true(all(gaa_pitches$longitude >= -180 & gaa_pitches$longitude <= 180))
})

test_that("gaa_pitches has no missing coordinates", {
  data(gaa_pitches, envir = environment())
  
  expect_true(all(!is.na(gaa_pitches$latitude)))
  expect_true(all(!is.na(gaa_pitches$longitude)))
})
