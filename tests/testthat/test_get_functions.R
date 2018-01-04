context("Create Errors")
test_that("Missing arguments and unknown subdomains return errors", {
  subdomain <- "xxxx"

  get_fun <- c("get_stations", "get_timeseries", "get_instruments",
               "get_water_basins", "get_water_divisions",
               "get_political_divisions", "get_variables",
               "get_units_of_measurement", "get_time_steps", "get_owners",
               "get_instruments_type", "get_station_type")

   for (fn in get_fun) {
    f <- get(fn)
    expect_error(f(subdomain))
   }

  expect_error(get_data(subdomain, 34))
  expect_error(get_data("kyy"))
})

context("Get data from Hydroscope")
test_that("get functions return dataframes", {

  subdomains <- c("kyy", "ypaat", "emy", "deh")
  get_fun <- c("get_stations", "get_timeseries", "get_instruments",
               "get_water_basins", "get_water_divisions",
               "get_political_divisions", "get_variables",
               "get_units_of_measurement", "get_time_steps", "get_owners",
               "get_instruments_type", "get_station_type")

  for (sd in subdomains) {
    for (fn in get_fun) {
      f <- get(fn)
      # skip("heavy web usage")
      expect_is(f(sd), "data.frame")
    }
  }
})
test_that("Can download time series values from KYY and YPAAT", {
  # skip("heavy web usage")
  expect_is(get_data("kyy", 129), "data.frame")
  # skip("heavy web usage")
  expect_is(get_data("kyy", 435), "data.frame")
})


