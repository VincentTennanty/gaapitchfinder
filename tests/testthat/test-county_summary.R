test_that("county_summary returns correct structure", {
  summary <- county_summary()
  
  expect_s3_class(summary, "data.frame")
  expect_true("county" %in% names(summary))
  expect_true("pitch_count" %in% names(summary))
  expect_true(all(summary$pitch_count > 0))
})

test_that("county_summary is sorted alphabetically", {
  summary <- county_summary()
  
  expect_equal(summary$county, sort(summary$county))
})

test_that("county_summary filters by province", {
  all_summary <- county_summary()
  connacht <- county_summary(province = "Connacht")
  
  expect_true(nrow(connacht) < nrow(all_summary))
  expect_true(all(connacht$province == "Connacht" | is.na(connacht$province)))
})

test_that("county_summary validates province input", {
  expect_error(county_summary(province = "InvalidProvince"), 
               "province must be one of:")
  expect_error(county_summary(province = 123), 
               "province must be a single character string or NULL")
})

test_that("county_summary handles all valid provinces", {
  provinces <- c("Connacht", "Leinster", "Munster", "Ulster")
  
  for (prov in provinces) {
    summary <- county_summary(province = prov)
    expect_s3_class(summary, "data.frame")
    expect_true(nrow(summary) > 0)
  }
})

test_that("county_summary pitch counts are accurate", {
  summary <- county_summary()
  
  # Total pitches should match sum of county counts
  data(gaa_pitches, envir = environment())
  total_pitches <- nrow(gaa_pitches)
  total_from_summary <- sum(summary$pitch_count)
  
  expect_equal(total_from_summary, total_pitches)
})
