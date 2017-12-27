context("Get data from Hydroscope functions")

test_that("get_ functions give errors", {

  expect_error(get_stations("none"))

  expect_error(get_coords(subdomain = "none", stationID = 1))
  expect_error(get_coords(subdomain = "kyy"))

  expect_error(get_timeseries(subdomain = "none", stationID = 1))
  expect_error(get_timeseries(subdomain = "deh"))

  expect_error(get_data(subdomain = "none", timeID = 1))
  expect_error(get_data(subdomain = "kyy"))
})

test_that("get_ functions give warnings", {
  expect_warning(get_coords("kyy", "a"))
  expect_warning(get_timeseries("emy", "a"))
})

test_that("get_ functions return dataframes", {

  # return data franes
  expect_is(get_stations("ypaat"), "data.frame")
  expect_is(get_coords("kyy", 10004), "data.frame")
  expect_is(get_timeseries("kyy", 200206), "data.frame")

  expect_is(get_timeseries("emy", 20100), "data.frame")
  expect_is(get_data("kyy", 789), "data.frame")

  # empty time series
  expect_is(get_data("kyy", 2256), "data.frame")
})
