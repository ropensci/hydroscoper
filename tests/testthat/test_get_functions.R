skip("heavy web usage")

context("Test API")
test_that("API returns a list of tables", {
  expect_is( get_api_json("kyy"), "list")
  expect_is( get_api_json("ypaat"), "list")
  expect_is( get_api_json("emy"), "list")
  expect_is( get_api_json("deh"), "list")
})

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

context("Check if data from hydroscope are as expected")
test_that("get functions return dataframes with a subset of variables", {

  # get data from subdomains ---------------------------------------------------
  expect_is(kyy <- get_database("kyy"), "list")
  expect_is(emy <- get_database("emy"), "list")
  expect_is(ypaat <- get_database("ypaat"), "list")
  expect_is(deh <- get_database("deh"), "list")

  # dataframes have expected variables -----------------------------------------
  expect_have_vars <- function(df, vars) {
    eval(bquote(expect_true(all(.(vars) %in% names(.(df))))))
  }

  expect_database <- function(subdomain, st_vars, ts_vars, wb_vars,
                              wd_vars, var_vars, own_vars, unit_vars,
                              tstep_vars) {
    # stations
    eval(bquote(expect_have_vars(.(subdomain)$stations, st_vars)))
    # timeseries
    eval(bquote(expect_have_vars(.(subdomain)$timeseries, ts_vars)))
    # water_basins
    eval(bquote(expect_have_vars(.(subdomain)$water_basins, wb_vars)))
    # water_divisions
    eval(bquote(expect_have_vars(.(subdomain)$water_divisions, wd_vars)))
    # variables
    eval(bquote(expect_have_vars(.(subdomain)$variables, var_vars)))
    # owners
    eval(bquote(expect_have_vars(.(subdomain)$owners, own_vars)))
    # units
    eval(bquote(expect_have_vars(.(subdomain)$units, unit_vars)))
    # time_steps
    eval(bquote(expect_have_vars(.(subdomain)$time_steps, tstep_vars)))
  }

  st_vars <- c("id", "name", "owner", "point", "altitude", "water_basin",
                     "water_division")
  wd_vars <- wb_vars <- own_vars <- c("id", "name")
  ts_vars <- c("id", "gentity", "start_date_utc", "end_date_utc", "variable",
                "time_step", "unit_of_measurement")
  var_vars <- tstep_vars <- c("id", "descr")
  unit_vars <- c("id", "symbol")

  expect_database(kyy,  st_vars, ts_vars, wb_vars, wd_vars, var_vars, own_vars,
                  unit_vars, tstep_vars)
  expect_database(emy,  st_vars, ts_vars, wb_vars, wd_vars, var_vars, own_vars,
                  unit_vars, tstep_vars)
  expect_database(ypaat,  st_vars, ts_vars, wb_vars, wd_vars, var_vars, own_vars,
                  unit_vars, tstep_vars)

  # deh subdomain use different timeseries variables ---------------------------
  ts_deh_vars <- c("id", "gentity", "variable", "time_step",
                   "unit_of_measurement")
  expect_database(deh,  st_vars, ts_deh_vars, wb_vars, wd_vars, var_vars,
                  own_vars, unit_vars, tstep_vars)
})

context("Download timeseries from Hydroscope")
test_that("Can download time series values from KYY and YPAAT", {
  expect_is(get_data("kyy", 129), "data.frame")
  expect_is(get_data("kyy", 435), "data.frame")
})
