test_that("plot_pitches creates a leaflet object", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]

  p <- plot_pitches(sample_pitches)

  expect_s3_class(p, "leaflet")
  expect_s3_class(p, "htmlwidget")
})

test_that("plot_pitches handles color parameter", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:20, ]

  p <- plot_pitches(sample_pitches, color = "province")
  expect_s3_class(p, "leaflet")
})

test_that("plot_pitches validates inputs", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]

  expect_error(plot_pitches("not_an_sf_object"), "pitches must be an sf object")
  expect_error(plot_pitches(sample_pitches, radius = -1), "radius must be a positive number")
  expect_error(plot_pitches(sample_pitches, alpha = 1.5), "alpha must be between 0 and 1")
  expect_error(plot_pitches(sample_pitches, color = "nonexistent_column"),
               "color column .* not found")
})

test_that("plot_pitches handles empty data", {
  data(gaa_pitches, envir = environment())
  empty_pitches <- gaa_pitches[0, ]

  p <- plot_pitches(empty_pitches)
  expect_s3_class(p, "leaflet")
})

test_that("plot_pitches respects radius and alpha parameters", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]

  p <- plot_pitches(sample_pitches, radius = 8, alpha = 0.5)
  expect_s3_class(p, "leaflet")
})
