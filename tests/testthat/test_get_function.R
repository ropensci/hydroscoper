context("Get stations data from Hydroscope")

test_that("function return errors", {
  expect_error(get_stations("none"))
})

test_that("function returns dataframes for all databases", {
  expect_is(get_stations(subdomain = "kyy"), "data.frame")
  expect_is(get_stations(subdomain = "ypaat"), "data.frame")
  expect_is(get_stations(subdomain = "emy"), "data.frame")
  expect_is(get_stations(subdomain = "deh"), "data.frame")
})

exp_cols <-c("station_id", "name", "last_modified", "altitude", "long",
             "lat", "water_division", "water_basin", "political_division")

test_that("function returns dataframes with specific variables", {
  expect_true(all(names(get_stations(subdomain = "kyy")) %in% exp_cols))
  expect_true(all(names(get_stations(subdomain = "ypaat")) %in% exp_cols))
  expect_true(all(names(get_stations(subdomain = "emy")) %in% exp_cols))
  expect_true(all(names(get_stations(subdomain = "deh")) %in% exp_cols))
})


context("Get time series data from Hydroscope")

test_that("function return errors", {
  expect_error(get_timeseries("none"))
})
