context("Get data from Hydroscope functions")

test_that("get functions give errors", {

  expect_error(get_stations("none"))

  expect_error(get_coords(subdomain = "none", stationID = 1))
  expect_error(get_coords(subdomain = "kyy"))

  expect_error(get_timeseries(subdomain = "none", stationID = 1))
  expect_error(get_timeseries(subdomain = "kyy"))

  expect_error(get_data(subdomain = "none", timeID = 1))
  expect_error(get_data(subdomain = "kyy"))
})



test_that("get_ functions return dataframes", {
  expect_is(get_stations("emy"), "data.frame")
  expect_is(get_coords("kyy", 10004), "data.frame")
  expect_is(get_timeseries("kyy", 200206), "data.frame")
  expect_is(get_data("kyy", 789), "data.frame")
})


