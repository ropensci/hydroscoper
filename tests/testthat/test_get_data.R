context("get_data function tests")

test_that("get_data return errors", {
  expect_error(get_data(subdomain = "xxx", 1))
  expect_error(get_data(subdomain = "kyy"))
})

testthat::test_that("source offsets resolve automatically without DST", {
  requests <- character()
  testthat::local_mocked_bindings(
    enhydris_read_text = function(url) {
      requests <<- c(requests, url)
      if (grepl("/Timeseries/", url, fixed = TRUE)) {
        return('[{"id":2173,"gentity":200251,"time_zone":1}]')
      }
      if (grepl("/TimeZone/", url, fixed = TRUE)) {
        return('[{"id":1,"code":"EET","utc_offset":120}]')
      }
      if (grepl("/tsdata/2173/", url, fixed = TRUE)) {
        return("1980-10-01 00:00,18.2,\n1980-07-01 00:00,2,")
      }
      stop("Unexpected request: ", url)
    }, .package = "hydroscoper")
  result <- get_data(time_id = 2173)
  testthat::expect_equal(result$date, as.POSIXct(
    c("1980-09-30 22:00:00", "1980-06-30 22:00:00"), tz = "UTC"))
  testthat::expect_length(requests, 3L)
  requests <- character()
  testthat::expect_equal(get_data("kyy", 2173, utc_offset = 120), result)
  testthat::expect_length(requests, 1L)
})

testthat::test_that("missing timezone metadata does not default to UTC", {
  testthat::local_mocked_bindings(
    enhydris_json = function(url) {
      if (grepl("/Timeseries/", url, fixed = TRUE)) {
        return(data.frame(id = 2173, gentity = 200251, time_zone = 99))
      }
      data.frame(id = 1, utc_offset = 120)
    }, enhydris_txt = function(...) stop("CSV must not be requested"),
    .package = "hydroscoper")
  testthat::expect_error(get_data("kyy", 2173), "TimeZone entry not found")
  testthat::expect_error(get_data("kyy", 9999), "missing time-series metadata")
})


testthat::test_that("invalid arguments never reach the transport", {
  calls <- 0L
  testthat::local_mocked_bindings(enhydris_read_text = function(...) {
    calls <<- calls + 1L
    stop("Unexpected request")
  }, .package = "hydroscoper")
  testthat::expect_error(get_data("kyy"), "time_id.*missing")
  testthat::expect_error(get_data("kyy", NULL), "time_id.*missing")
  for (id in list(NA, integer(), c(1, 2), 1.5, TRUE, "../Station", "0", "",
                  Inf, -1, list(1), 2^53, 1i)) {
    testthat::expect_error(get_data("kyy", id), "positive integer ID")
  }
  for (domain in list(NA, character(), c("kyy", "emy"), 1, "ky")) {
    testthat::expect_error(get_stations(domain), "subdomain")
  }
  for (flag in list(NA, logical(), c(TRUE, FALSE), 1, "yes")) {
    testthat::expect_error(get_stations("kyy", flag), "translit")
  }
  testthat::expect_error(get_data("kyy", 2173, utc_offset = NA), "utc_offset")
  testthat::expect_error(get_data("kyy", 2173, utc_offset = 1i), "utc_offset")
  testthat::expect_identical(calls, 0L)
  testthat::expect_identical(hydro_validate_time_id("002173"), "2173")
})


testthat::test_that("station availability respects provider boundaries", {
  stations <- data.frame(subdomain = c("kyy", "ypaat"), station_id = c(1, 1))
  timeseries <- data.frame(subdomain = "ypaat", station_id = 1)
  station_key <- paste(stations$subdomain, stations$station_id, sep = "/")
  series_key <- paste(timeseries$subdomain, timeseries$station_id, sep = "/")
  result <- stations[station_key %in% series_key, ]
  testthat::expect_equal(result$subdomain, "ypaat")
})
