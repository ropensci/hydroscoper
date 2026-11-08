context("get_tables family function tests")

test_that("Missing arguments and unknown subdomains return errors", {
  subdomain <- "xxxx"

  get_fun <- c(
    "get_stations", "get_timeseries", "get_instruments",
    "get_water_basins", "get_water_divisions",
    "get_political_divisions", "get_variables",
    "get_units_of_measurement", "get_time_steps", "get_owners",
    "get_instruments_type", "get_station_type", "get_database"
  )

  for (fn in get_fun) {
    f <- get(fn)
    expect_error(f(subdomain))
  }
})


testthat::test_that("all table getters default to kyy and permit lookup ID zero", {
  testthat::local_mocked_bindings(enhydris_json = function(url) {
    testthat::expect_match(url, "^http://kyy[.]hydroscope[.]gr/")
    data.frame(id = 0, name = "A", point = "POINT(23 38)",
               gentity = 1, descr = "AGNOSTO", symbol = "mm")
  }, .package = "hydroscoper")
  getters <- list(get_stations, get_timeseries, get_instruments,
                  get_water_basins, get_water_divisions, get_political_divisions,
                  get_variables, get_units_of_measurement, get_time_steps, get_owners,
                  get_instruments_type, get_station_type)
  for (getter in getters) testthat::expect_s3_class(getter(), "tbl_df")
  database <- get_database()
  testthat::expect_length(database, 12L)
  testthat::expect_equal(database$variables$id, 0)
})
