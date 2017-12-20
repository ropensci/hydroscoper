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

# test_that("get functions give warnings",{
#
#   expect_warning()
#
# })
