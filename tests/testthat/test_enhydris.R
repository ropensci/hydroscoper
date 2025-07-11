# Helper functions -------------------------------------------------------------
library(httptest)

context("Test enhydris_api helper functions")
test_that("enhydris_names returns error", {
  expect_error(enhydris_names("xxxx"))
})

context("enhydris_url returns expected addresses")
test_that("enhydris_url table address", {
  subdomain <- "kyy"
  api <- "Station"
  time_id <- NULL
  exp_addr <- "http://kyy.hydroscope.gr/api/Station/?format=json"
  expect_equal(enhydris_url(subdomain, api, time_id), exp_addr)
})
test_that("enhydris_url table address", {
  subdomain <- "kyy"
  api <- "tsdata"
  time_id <- 1
  exp_addr <- "http://kyy.hydroscope.gr/api/tsdata/1/"
  expect_equal(enhydris_url(subdomain, api, time_id), exp_addr)
})


# Check API's tables -----------------------------------------------------------
context("Test that expected tables exist in sub-domains' databases")
with_mock_api({
  test_that("kyy returns expected tables", {
    expect_names_in_api <- function(subdomain) {
      exp_names <- c(
        "Station", "Timeseries", "Instrument", "WaterBasin",
        "WaterDivision", "PoliticalDivision", "Variable",
        "UnitOfMeasurement", "TimeStep", "Organization",
        "InstrumentType", "StationType"
      )
      expect_true(all(exp_names %in% names(enhydris_list(subdomain))))
    }
    expect_names_in_api("kyy")
  })
})


# Check enhydris_get and enhydris_listfunctions --------------------------------

context("Test enhydris_get and enhydris_list functions")
with_mock_api({
  test_that("Test that enhydris_get returns a JSON file as a tibble", {
    expect_is(enhydris_get("kyy", api_value = "owner"), "tbl_df")
  })
  test_that("Test that returns a JSON file as a tibble, no translit", {
    expect_is(
      enhydris_get("kyy", api_value = "owner", translit = FALSE),
      "tbl_df"
    )
  })
  test_that("Test that KYY returns a TXT file as a tibble", {
    expect_is(
      enhydris_get("kyy", api_value = "time_data", time_id = 2173),
      "tbl_df"
    )
  })
  
  test_that("Test that returns an error if time-series doesn't exist", {
    expect_error(enhydris_get("kyy", api_value = "time_data", time_id = 0))
  })
})

context("Test enhydris_list function")
with_mock_api({
  test_that("Test that enhydris_list function returns a list", {
    expect_is(enhydris_list("kyy"), "list")
  })
})


context("Test that wrong subdomain returns an error")
test_that("Test that wrong subdomain returns an error", {
  expect_error(enhydris_get("ky", api_value = "owner"))
})