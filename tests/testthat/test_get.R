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

skip_if_not_online <- function(subdomain) {
  h_url <- paste0(subdomain, ".hydroscope.gr")

  if(is.na(pingr::ping(h_url, count = 1))) {
    skip(paste(h_url, "is not online"))
  }
}

expect_names_in_api <- function(subdomain) {
  exp_names <- c("Station", "Timeseries", "Instrument", "WaterBasin",
                 "WaterDivision", "PoliticalDivision", "Variable",
                 "UnitOfMeasurement", "TimeStep", "Organization",
                 "InstrumentType", "StationType")

  expect_true(all(exp_names %in% names(get_api_json(subdomain))))
}

context("Test API")
test_that("kyy returns expected tables", {
  skip_if_not_online("kyy")
  expect_names_in_api("kyy")
})
test_that("emy returns expected tables", {
  skip_if_not_online("emy")
  expect_names_in_api("emy")
})
test_that("deh returns expected tables", {
  skip_if_not_online("deh")
  expect_names_in_api("deh")
})
test_that("ypaat returns expected tables", {
  skip_if_not_online("ypaat")
  expect_names_in_api("ypaat")
})

context("Test get_ functions")
test_that("get_ functions work on kyy", {
  skip_if_not_online("kyy")
  expect_is(get_database("kyy"), "list")
})
test_that("get_ functions work on emy", {
  skip_if_not_online("emy")
  expect_is((get_database("emy")), "list")
})
test_that("get_ functions work on deh", {
  skip_if_not_online("deh")
  expect_is((get_database("deh")), "list")
})
test_that("get_ functions work on ypaat", {
  skip_if_not_online("ypaat")
  expect_is((get_database("ypaat")), "list")
})

context("Download timeseries values from Hydroscope")
test_that("Can download time series values from kyy", {
  skip_if_not_online("kyy")
  expect_is(get_data("kyy", 129), "data.frame")
})
test_that("Can download time series values from ypaat", {
  skip_if_not_online("ypaat")
  expect_is(get_data("ypaat", 160), "data.frame")
})
