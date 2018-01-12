context("Create Errors")
test_that("Missing arguments and unknown subdomains return errors", {
  subdomain <- "xxxx"

  get_fun <- c("get_stations", "get_timeseries", "get_instruments",
               "get_water_basins", "get_water_divisions",
               "get_political_divisions", "get_variables",
               "get_units_of_measurement", "get_time_steps", "get_owners",
               "get_instruments_type", "get_station_type", "get_database")

  for (fn in get_fun) {
    f <- get(fn)
    expect_error(f(subdomain))
  }
  expect_error(get_data(subdomain, 34))
  expect_error(get_data("kyy"))
})

# To test local using devtools::test() comment the following line
skip("Heavy web usage")

context("Test API")
test_that("APIs return lists of expected tables", {

  # create booleans if servers are online
  online <- function(h_url){
    !is.na(pingr::ping(h_url, count = 1))
  }

  kyy   <- online("kyy.hydroscope.gr")
  emy   <- online("emy.hydroscope.gr")
  ypaat <- online("ypaat.hydroscope.gr")
  deh   <- online("deh.hydroscope.gr")


  exp_names <- c("Station", "Timeseries", "Instrument", "WaterBasin",
                "WaterDivision", "PoliticalDivision", "Variable",
                "UnitOfMeasurement", "TimeStep", "Organization",
                "InstrumentType", "StationType")


  expect_tables_in_api <- function(subomain) {
    expect_true(all(exp_names %in% names(get_api_json(subomain))))
  }

  skip_if_not(kyy, "kyy is not online, skip expect_list_api test")
  expect_tables_in_api("kyy")

  skip_if_not(emy, "emy is not online, skip expect_list_api test")
  expect_tables_in_api("emy")

  skip_if_not(ypaat, "ypaat is not online, skip expect_list_api test")
  expect_tables_in_api("ypaat")

  skip_if_not(deh, "deh is not online, skip expect_list_api test")
  expect_tables_in_api("deh")

})

context("Check data from hydroscope ")
test_that("Check if all get_ family functions return data", {

  # create booleans if servers are online
  online <- function(h_url){
    !is.na(pingr::ping(h_url, count = 1))
  }

  kyy   <- online("kyy.hydroscope.gr")
  emy   <- online("emy.hydroscope.gr")
  ypaat <- online("ypaat.hydroscope.gr")
  deh   <- online("deh.hydroscope.gr")


  # check and download lists of tibbles
  skip_if_not(kyy, "kyy is not online, skip get_database test")
  expect_is((get_database("kyy")), "list")

  skip_if_not(emy, "emy is not online, skip get_database test")
  expect_is((get_database("emy")), "list")

  skip_if_not(ypaat, "ypaat is not online, skip get_database test")
  expect_is((get_database("ypaat")), "list")

  skip_if_not(deh, "deh is not online, skip get_database test")
  expect_is((get_database("deh")), "list")

})

context("Download timeseries values from Hydroscope")
test_that("Can download values from KYY and YPAAT", {

  # create booleans if servers are online
  online <- function(h_url){
    !is.na(pingr::ping(h_url, count = 1))
  }

  kyy   <- online("kyy.hydroscope.gr")
  ypaat <- online("ypaat.hydroscope.gr")

  # download time series values from kyy
  skip_if_not(kyy, "kyy is not online, skip get_data test")
  expect_is(get_data("kyy", 129), "data.frame")

  # download time series values from ypaat
  skip_if_not(ypaat, "ypaat is not online, skip get_data test")
  expect_is(get_data("ypaat", 160), "data.frame")
})
