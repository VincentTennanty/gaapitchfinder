test_that("plot_pitches creates a ggplot object", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]
  
  p <- plot_pitches(sample_pitches)
  
  expect_s3_class(p, "ggplot")
})

test_that("plot_pitches handles color parameter", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:20, ]
  
  p <- plot_pitches(sample_pitches, color = "province")
  expect_s3_class(p, "ggplot")
})

test_that("plot_pitches validates inputs", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]
  
  expect_error(plot_pitches("not_an_sf_object"), "pitches must be an sf object")
  expect_error(plot_pitches(sample_pitches, size = -1), "size must be a positive numeric value")
  expect_error(plot_pitches(sample_pitches, alpha = 1.5), "alpha must be a numeric value between 0 and 1")
  expect_error(plot_pitches(sample_pitches, color = "nonexistent_column"), 
               "color column .* not found")
})

test_that("plot_pitches handles empty data", {
  data(gaa_pitches, envir = environment())
  empty_pitches <- gaa_pitches[0, ]
  
  expect_warning(p <- plot_pitches(empty_pitches), "Empty pitches object provided")
  expect_s3_class(p, "ggplot")
})

test_that("plot_pitches returns customizable ggplot", {
  data(gaa_pitches, envir = environment())
  sample_pitches <- gaa_pitches[1:10, ]
  
  p <- plot_pitches(sample_pitches) +
    ggplot2::labs(title = "Custom Title")
  
  expect_s3_class(p, "ggplot")
  expect_true("title" %in% names(p$labels))
})
