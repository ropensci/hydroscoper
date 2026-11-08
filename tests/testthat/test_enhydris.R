# Helper functions -------------------------------------------------------------

test_that("enhydris_names returns error", {
  expect_error(enhydris_names("xxxx"))
})

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


# Check enhydris_get and enhydris_listfunctions --------------------------------



context("Test that wrong subdomain returns an error")
test_that("Test that wrong subdomain returns an error", {
  expect_error(enhydris_get("ky", api_value = "owner"))
})

testthat::test_that("CSV distinguishes missing measurements from bad data", {
  payload <- "1980-10-01 00:00,18.2,checked\n1980-11-01 00:00,,"
  testthat::local_mocked_bindings(enhydris_read_text = function(...) payload,
                                  .package = "hydroscoper")
  result <- enhydris_txt("fixture", 120)
  testthat::expect_equal(result$value, c(18.2, NA_real_))
  testthat::expect_equal(result$comment, c("checked", NA_character_))
  testthat::expect_equal(enhydris_txt("fixture", 330)$date[1],
                         as.POSIXct("1980-09-30 18:30:00", tz = "UTC"))
  testthat::expect_equal(enhydris_txt("fixture", -90)$date[1],
                         as.POSIXct("1980-10-01 01:30:00", tz = "UTC"))
  for (bad in c("1980-10-01 00:00,abc,", "1980-10-01 00:00,Inf,",
                "1980-10-01 00:00,1,,extra", ",1,",
                "<html>Service unavailable</html>")) {
    payload <- bad
    testthat::expect_error(enhydris_txt("fixture", 120), "Invalid time-series")
  }
  payload <- "1980-02-30 00:00,1,"
  testthat::expect_error(enhydris_txt("fixture", 120), "Invalid time-series dates")
  payload <- "1980-10-01T00:00:00+02:00,1,"
  testthat::expect_error(enhydris_txt("fixture", 120), "offset-free")
  payload <- ""
  empty <- enhydris_txt("fixture", 120)
  testthat::expect_identical(names(empty), c("date", "value", "comment"))
  testthat::expect_equal(nrow(empty), 0L)
  testthat::expect_s3_class(empty$date, "POSIXct")
})
testthat::test_that("JSON accepts ID zero and rejects unexpected payloads", {
  payload <- '[{"id":0,"descr":"AGNOSTO"}]'
  testthat::local_mocked_bindings(enhydris_read_text = function(...) payload,
                                  .package = "hydroscoper")
  testthat::expect_equal(get_variables("kyy")$id, 0)
  payload <- '{"detail":"Service unavailable"}'
  testthat::expect_error(get_variables("kyy"), "Unexpected schema")
  payload <- 'null'
  testthat::expect_error(get_variables("kyy"), "Unexpected schema")
  payload <- '{}'
  testthat::expect_error(get_variables("kyy"), "Unexpected schema")
  payload <- '[]'
  testthat::expect_identical(names(get_variables("kyy")), c("id", "descr"))
  payload <- '[{"id":1,"descr":null}]'
  testthat::expect_identical(get_variables("kyy")$descr, NA_character_)
  payload <- '<html>Service unavailable</html>'
  testthat::expect_error(get_variables("kyy"), "Invalid JSON")
  payload <- '[{"id":"wrong","descr":"x"}]'
  testthat::expect_error(get_variables("kyy"), "Unexpected type")
})


testthat::test_that("index and owner downloads use fixture content", {
  testthat::local_mocked_bindings(enhydris_read_text = function(url) {
    if (grepl("/Organization/", url, fixed = TRUE)) {
      return('[{"id":1,"name":"\u0391\u0398\u0397\u039d\u0391"}]')
    }
    '{"Station":"station-url","Timeseries":"timeseries-url"}'
  }, .package = "hydroscoper")
  testthat::expect_named(enhydris_list("kyy"), c("Station", "Timeseries"))
  testthat::expect_equal(get_owners("kyy")$name, "ATHENA")
  testthat::expect_equal(get_owners("kyy", FALSE)$name,
                         "\u0391\u0398\u0397\u039d\u0391")
  testthat::expect_error(enhydris_names("xxxx"), "Not a valid Enhydris API")
  testthat::expect_error(enhydris_list("ky"), "subdomain")
  testthat::expect_equal(enhydris_url("kyy", "Station"),
                         "http://kyy.hydroscope.gr/api/Station/?format=json")
  testthat::expect_equal(enhydris_url("kyy", "tsdata", "1"),
                         "http://kyy.hydroscope.gr/api/tsdata/1/")
})


testthat::test_that("transformation failures are not called download failures", {
  testthat::local_mocked_bindings(
    enhydris_json = function(...) data.frame(id = 1, name = "A"),
    translit_all = function(...) stop("Deliberate transformation failure"),
    .package = "hydroscoper")
  testthat::expect_error(get_owners("kyy"), "^Deliberate transformation failure$")
})
