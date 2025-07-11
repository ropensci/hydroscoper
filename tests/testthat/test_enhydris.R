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
<<<<<<< HEAD
=======

# helper function to skip tests if a server in not alive
skip_if_not_online <- function(subdomain) {
  h_url <- paste0(subdomain, ".hydroscope.gr")

  # test the http capabilities of the current R build
  if (!capabilities(what = "http/ftp")) {
    skip("The current R build has no http capabilities")
  }

  # test connection by trying to read first line of url
  test <- try(suppressWarnings(readLines(url, n = 1)), silent = TRUE)

  # return FALSE if test inherits 'try-error' class
  if (inherits(test, "try-error")) {
    skip(paste("Cannot read data from", h_url))
  }
}

# helper function to check if all expected tables exist
expect_names_in_api <- function(subdomain) {
  exp_names <- c(
    "Station", "Timeseries", "Instrument", "WaterBasin",
    "WaterDivision", "PoliticalDivision", "Variable",
    "UnitOfMeasurement", "TimeStep", "Organization",
    "InstrumentType", "StationType"
  )
  expect_true(all(exp_names %in% names(enhydris_list(subdomain))))
}

>>>>>>> 5f92c0e554c5e22aa235c2fc0bec391976bb65f4
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