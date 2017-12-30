context("Get data from Hydroscope")

test_that("get functions returns dataframes", {

  subdomains <- c("kyy", "ypaat", "emy", "deh")
  get_fun <- c("get_stations", "get_timeseries", "get_instruments",
               "get_water_basins", "get_water_divisions",
               "get_political_divisions", "get_variables",
               "get_units_of_measurement", "get_time_steps", "get_owners",
               "get_instruments_type", "get_station_type")

  for (sd in subdomains) {
    for (fn in get_fun) {
      f <- get(fn)
      skip_on_cran()
      expect_is(f(sd), "data.frame")
    }
  }
})


