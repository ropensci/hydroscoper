context("Get data from Hydroscope")

test_that("functions return errors", {
  expect_error(get_stations("none"))
  expect_error(get_timeseries("none"))
  expect_error(get_data("none"))
})

test_that("functions returns dataframes", {
  skip("skip")
  expect_is(get_stations("emy"), "data.frame")
  skip()
  expect_is(get_timeseries("ypaat"), "data.frame")
  skip()
  expect_is(get_data("kyy", 912), "data.frame")
})


