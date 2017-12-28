context("Get stations data from Hydroscope")

test_that("function return errors", {
  expect_error(get_stations("none"))
})

test_that("function returns dataframes for all databases", {
  expect_is(get_stations("kyy"), "data.frame")
  expect_is(get_stations("ypaat"), "data.frame")
  expect_is(get_stations("emy"), "data.frame")
  expect_is(get_stations("deh"), "data.frame")
})

exp_cols <-c("station_id", "name", "last_modified", "altitude", "long",
             "lat", "water_division", "water_basin", "political_division")

test_that("function returns dataframes with specific variables", {
  expect_true(all(names(get_stations("kyy")) %in% exp_cols))
  expect_true(all(names(get_stations("ypaat")) %in% exp_cols))
  expect_true(all(names(get_stations("emy")) %in% exp_cols))
  expect_true(all(names(get_stations("deh")) %in% exp_cols))
})


context("Get time series data from Hydroscope")

test_that("function return errors", {
  expect_error(get_timeseries("none"))
})

test_that("function returns dataframes for all databases", {
  expect_is(get_timeseries("kyy"), "data.frame")
  expect_is(get_timeseries("ypaat"), "data.frame")
  expect_is(get_timeseries("emy"), "data.frame")
  expect_is(get_timeseries("deh"), "data.frame")
})

exp_cols <-c("timeseries_id", "name", "last_modified", "instrument",
             "station_id", "remarks", "variable", "unit_of_measurement",
             "time_step")
test_that("function returns dataframes with specific variables", {
  expect_true(all(names(get_timeseries("kyy")) %in% exp_cols))
  expect_true(all(names(get_timeseries("ypaat")) %in% exp_cols))
  expect_true(all(names(get_timeseries("emy")) %in% exp_cols))
  expect_true(all(names(get_timeseries("deh")) %in% exp_cols))
})


context("Get data from Hydroscope")

test_that("function return errors", {
  expect_error(get_data("none"))
})

test_that("function returns dataframes for all databases", {
  expect_is(get_data("kyy", 912), "data.frame")
})

