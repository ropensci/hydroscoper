# hydroscoper: assessed implementation proposals (2026-11-08) ------------------
#
# This is an implementation guide, not an automatic migration. Only this file
# is being edited. Findings 01-15 retain their original numbering; 16-18 cover
# links, the latest push, and release work. Each section identifies its target.
#
# IMPLEMENTATION
# Copy replacement functions to the named R/ files, preserving their roxygen
# comments and applying the documentation additions below. Shared functions
# appear once. Sections 01, 02, 05, 10 and 11 must be implemented together.
# Copy the CONTENTS of each relevant if (FALSE) block to its named destination;
# do not copy the wrapper. Tests and maintenance commands never run on sourcing.
# Runtime code uses existing Imports. sf/usethis/devtools/urlchecker are only
# maintainer tools, not new runtime dependencies. Do not apply every suggestion
# indiscriminately: conditional support-policy and release decisions are marked.
#
# INSPECT WITHOUT INSTALLING OR CHANGING THE PACKAGE
#   proposed <- new.env(parent = globalenv())
#   for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) {
#     sys.source(f, proposed)
#   }
#   sys.source("data-raw/proposed_function_corrections.R", proposed)
#   proposed$hydro_coords("POINT(23 38)")
# Sourcing only defines functions. Calling a getter DOES make requests.
# Tests using local_mocked_bindings target the implemented package namespace;
# run them after integration, not against the original installed functions.
#
# REVIEW BASELINE
# GitHub master 77897fe includes the November 7 fixes. DESCRIPTION has separate
# local dependency edits. The original package passed online tests and an
# isolated R CMD check --as-cran --no-manual with incoming checks disabled.
# Five existing tests failed offline. These are original-package results, not
# certification of the proposed maintenance operations or a full CRAN check.
#
# VALIDATION OF THIS REVISED PROPOSAL
# Parsed/sourced successfully. In an isolated package copy with the replacement
# functions and repaired data, 27 test cases / 160 expectations passed offline
# with no failures or warnings (15 cases are proposed here). No package files
# or datasets in the actual repository were changed during that verification.
# Live KYY smoke test: variable ID 0 accepted; series 2173 returned 213 rows and
# first UTC timestamp 1980-09-30 22:00:00. The full four-provider regeneration
# was tested with synthetic inputs only, not live DEH. The sf conversion kept
# 18,474 rows / six columns; nearest corresponding coordinates differ from the
# saved borders by less than 2e-9 degrees. Date audit flags 4994 and preserves it
# in the raw object. CI YAML, publication, lower-R support and full regeneration
# remain implementation-time checks, not completed release validation.
#
# INDEX
# 01 timestamps     02 payloads/zero IDs  03 saved labels     04 offline tests
# 05 defaults       06 POINT parsing     07 CRS docs         08 division names
# 09 units          10 validation        11 errors/transport 12 data scripts
# 13 bad dates      14 station keys      15 versions         16 URLs
# 17 latest fixes   18 CI/release


# 01. CONFIRMED / HIGH: source time offsets -----------------------------------
# TARGET: R/enhydris_api.R (helpers); R/get_data.R (section 05).
# KYY/2173 starts at local 1980-10-01 00:00. Its time_zone=1 maps to EET with
# utc_offset=120 in /api/TimeZone/?format=json. Correct UTC: 1980-09-30 22:00.
# Legacy timezones have fixed offsets; do not assume Europe/Athens DST rules.
# Reference: https://enhydris.readthedocs.io/_/downloads/en/0.2/pdf/
#
# The old proposal made tz mandatory, breaking existing calls. Instead, resolve
# the offset from metadata automatically. An optional utc_offset argument uses
# minutes east of UTC, matching the legacy API and supporting half-hour offsets.
# Output remains POSIXct UTC. Metadata failures are errors, never implicit UTC.
# Automatic resolution adds two metadata requests; no global cache is proposed.

hydro_validate_offset <- function(utc_offset) {
  if (!is.numeric(utc_offset) || is.complex(utc_offset) || length(utc_offset) != 1L ||
      is.na(utc_offset) || !is.finite(utc_offset) ||
      utc_offset != trunc(utc_offset) || abs(utc_offset) >= 1440) {
    stop("'utc_offset' must be whole minutes strictly between -1440 and 1440.",
         call. = FALSE)
  }
  utc_offset
}

hydro_time_offset <- function(subdomain, time_id) {
  series <- hydro_validate_table(
    enhydris_json(enhydris_url(subdomain, "Timeseries")), "timeseries")
  row <- which(as.character(series$id) == time_id)
  if (length(row) != 1L || !"time_zone" %in% names(series)) {
    stop("Cannot resolve source timezone: missing time-series metadata.",
         call. = FALSE)
  }
  zone_id <- series$time_zone[row]
  if (!is.numeric(zone_id) || length(zone_id) != 1L || is.na(zone_id)) {
    stop("Cannot resolve source timezone: invalid time_zone ID.", call. = FALSE)
  }
  zones <- hydro_validate_table(
    enhydris_json(enhydris_url(subdomain, "TimeZone")), "time_zone")
  row <- which(zones$id == zone_id)
  if (length(row) != 1L) {
    stop("Cannot resolve source timezone: TimeZone entry not found.", call. = FALSE)
  }
  hydro_validate_offset(zones$utc_offset[row])
}

# TARGET: tests/testthat/test_get_data.R (append).
if (FALSE) {
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
}
# ROXYGEN: add to R/get_data.R; regenerate man/get_data.Rd.
#' @param utc_offset Optional fixed source offset from UTC, in minutes.
#'   Positive values are east of UTC. If NULL, resolve it from the legacy
#'   Timeseries and TimeZone metadata. For example, 120 means UTC+02:00.
#' @details Legacy timestamps have no explicit offset. Dates are converted to
#'   UTC using the source's fixed offset. Missing metadata causes an error;
#'   UTC is never assumed silently.
# Change the date column description to "Measurement instants (POSIXct, UTC)".
# NEWS must explain the corrected instants: downstream date grouping can change.


# 02. CONFIRMED / HIGH: malformed payloads; correct the proposed zero-ID bug ----
# TARGET: R/enhydris_api.R. Transport is in section 11.
# Current parsing hides invalid dates/numbers, accepts HTML as a one-column
# tibble and accepts JSON error objects as tables. Check schema and parse issues.
# Missing measurements remain NA; malformed values and missing dates are errors.
#
# The OLD PROPOSAL rejects IDs < 1. Variable ID 0 is valid ("unknown") on KYY,
# YPAAT and EMY. That proposal breaks get_variables() and get_database(). Allow
# zero table IDs, but retain positive-only downloadable series IDs (section 10).
# CSV timestamps must be naive legacy clock readings: reject explicit offsets
# rather than applying the source offset twice to an already zoned timestamp.

enhydris_json <- function(hydro_url) {
  text <- enhydris_read_text(hydro_url)
  tryCatch(jsonlite::parse_json(text, simplifyVector = TRUE, flatten = TRUE),
    error = function(e) {
      stop("Invalid JSON from ", hydro_url, ": ", conditionMessage(e), call. = FALSE)
    })
}

enhydris_txt <- function(hydro_url, utc_offset) {
  utc_offset <- hydro_validate_offset(utc_offset)
  text <- enhydris_read_text(hydro_url)
  if (!nzchar(trimws(text))) {
    return(tibble::tibble(date = as.POSIXct(character(), tz = "UTC"),
                          value = double(), comment = character()))
  }
  # Suppress parser warnings only because all reported problems are checked.
  result <- suppressWarnings(readr::read_csv(
    I(text), col_names = c("date", "value", "comment"),
    col_types = readr::cols(date = readr::col_character(),
                          value = readr::col_double(),
                          comment = readr::col_character()),
    na = c("", "NA"), lazy = FALSE, progress = FALSE, show_col_types = FALSE))
  if (!identical(names(result), c("date", "value", "comment")) ||
      nrow(readr::problems(result)) > 0L || anyNA(result$date) ||
      any(!is.na(result$value) & !is.finite(result$value))) {
    stop("Invalid time-series CSV from ", hydro_url, call. = FALSE)
  }
  naive_date <- paste0("^[0-9]{4}-[0-9]{2}-[0-9]{2}[ T][0-9]{2}:[0-9]{2}",
                       "(:[0-9]{2}(\\.[0-9]+)?)?$")
  if (any(!grepl(naive_date, result$date))) {
    stop("Expected offset-free legacy timestamps from ", hydro_url, call. = FALSE)
  }
  dates <- suppressWarnings(readr::parse_datetime(
    result$date, locale = readr::locale(tz = "UTC")))
  if (anyNA(dates) || nrow(readr::problems(dates)) > 0L) {
    stop("Invalid time-series dates from ", hydro_url, call. = FALSE)
  }
  result$date <- dates - utc_offset * 60
  attr(result$date, "tzone") <- "UTC"
  tibble::as_tibble(result)
}

hydro_validate_table <- function(result, api_value) {
  schema <- switch(api_value,
    stations = list(id = integer(), name = character(), point = character()),
    timeseries = list(id = integer(), gentity = integer()),
    water_basin =, water_division =, political_division =, owner =
      list(id = integer(), name = character()),
    variable =, time_step =, instrument_type =, station_type =
      list(id = integer(), descr = character()),
    unit_of_measurement = list(id = integer(), symbol = character()),
    instruments = list(id = integer()),
    time_zone = list(id = integer(), utc_offset = double()),
    stop("Unsupported table type.", call. = FALSE))
  # [] is a valid empty table; null or an error object is not.
  if (is.list(result) && !is.null(result) && is.null(names(result)) &&
      length(result) == 0L) return(tibble::as_tibble(schema))
  if (!is.data.frame(result) || !all(names(schema) %in% names(result))) {
    stop("Unexpected schema for ", api_value, call. = FALSE)
  }
  for (column in names(schema)) {
    x <- result[[column]]
    # Entirely null JSON columns simplify to logical NA.
    if (is.logical(x) && all(is.na(x))) {
      result[[column]] <- if (is.character(schema[[column]])) {
        rep(NA_character_, length(x))
      } else rep(NA_real_, length(x))
    } else if ((is.character(schema[[column]]) && !is.character(x)) ||
               (is.numeric(schema[[column]]) && !is.numeric(x))) {
      stop("Unexpected type for ", api_value, " column ", column, call. = FALSE)
    }
  }
  if (anyNA(result$id) || any(!is.finite(result$id)) ||
      any(result$id < 0 | result$id != trunc(result$id)) ||
      anyDuplicated(result$id)) {
    stop("The table contains invalid or duplicate IDs.", call. = FALSE)
  }
  tibble::as_tibble(result)
}

# TARGET: tests/testthat/test_enhydris.R (replace the old network mocks;
# combine with sections 04 and 11). Fixtures exercise actual parsers.
if (FALSE) {
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
}


# 03. CONFIRMED / HIGH: repair 456 saved labels without dropping DEH ------------
# TARGET: one-time data-raw/repair_timeseries_labels.R; data/timeseries.rda.
# The pushed regex fix is correct, but saved results still use old labels.
# DEH did not resolve, so a full live rebuild could lose historical metadata.
# For this release, repair only the four verified labels in the existing bundle.
# Run this intentionally, review the data diff and retain the script as provenance.
if (FALSE) {
  snapshot <- new.env(parent = emptyenv())
  load("data/timeseries.rda", envir = snapshot)
  original <- snapshot$timeseries
  timeseries <- original
  replacements <- c(humidity_rmintive = "humidity_relative",
    levminflood = "level_flood", minophaneia_duration = "sunshine_duration",
    pressure_levminsea = "pressure_level_sea")
  observed <- vapply(names(replacements), function(label) {
    sum(timeseries$variable == label, na.rm = TRUE)
  }, integer(1))
  # Reviewed snapshot or an already-repaired snapshot; fail on unexpected data.
  stopifnot(identical(unname(observed), c(255L, 79L, 8L, 114L)) ||
              all(observed == 0L))
  matched <- match(timeseries$variable, names(replacements))
  change <- !is.na(matched)
  timeseries$variable[change] <- unname(replacements[matched[change]])
  stopifnot(identical(timeseries[names(timeseries) != "variable"],
                      original[names(original) != "variable"]))
  usethis::use_data(timeseries, overwrite = TRUE)
}
# TARGET: test_translit.R (first test); new tests/testthat/test_data.R (second).
# The data assertion should fail until the data repair has been implemented.
if (FALSE) {
  testthat::test_that("abbreviation patterns do not corrupt full words", {
    x <- c("YGRASIA (SCHETIKE)", "STATHME (PLEMMYRA)",
           "ELIOPHANEIA (DIARKEIA)", "PIESE (STATHME THALASSES)")
    testthat::expect_equal(hydro_translate(x, "variable"),
      c("humidity_relative", "level_flood", "sunshine_duration", "pressure_level_sea"))
  })
  testthat::test_that("bundled labels no longer contain known corruption", {
    bad <- c("humidity_rmintive", "levminflood", "minophaneia_duration",
             "pressure_levminsea")
    testthat::expect_false(any(hydroscoper::timeseries$variable %in% bad))
  })
}


# 04. CONFIRMED / CRAN PRIORITY: deterministic offline tests --------------------
# TARGET: tests/testthat/test_enhydris.R, test_utils.R; DESCRIPTION Suggests.
# httptest intercepts httr, not the package's jsonlite/readr/base downloads.
# Replace test_enhydris.R with sections 02, 04 and 11's tests. Remove library(),
# skip_if_not_installed("httptest"), with_mock_api() and the duplicated helper.
# Remove httptest from Suggests and its unused mocks directory once no uses remain.
# Test parsers using text fixtures and mock only the shared transport boundary.
# FUNCTION TARGET: R/enhydris_api.R, replace enhydris_list().

enhydris_list <- function(subdomain = "kyy") {
  subdomain <- hydro_validate_subdomain(subdomain)
  result <- enhydris_json(paste0("http://", subdomain,
                                 ".hydroscope.gr/api/?format=json"))
  if (!is.list(result) || !all(c("Station", "Timeseries") %in% names(result))) {
    stop("The response is not a supported legacy Enhydris API index.", call. = FALSE)
  }
  result
}

if (FALSE) {
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
}
# R/utils.R: remove unused server_alive() and server_address(). Neither is
# exported or used by the getters. test_utils.R: remove BOTH associated tests,
# retaining the radians and Haversine tests. This removes the unmocked probe of
# xxx.hydroscope.gr. Do not add a homepage preflight check to the workhorse.
# Manual live smoke checks can remain separate from the CRAN test suite.


# 05. CONFIRMED / MEDIUM: consistent scalar defaults ---------------------------
# TARGET: R/get_data.R and R/get_tables.R. Preserve roxygen; regenerate man/.
# Existing public two-argument get_data calls remain valid. Database names stay
# unchanged; there are twelve tables and fourteen exported get_* functions.

get_data <- function(subdomain = "kyy", time_id, utc_offset = NULL) {
  if (missing(time_id) || is.null(time_id)) {
    stop("Argument 'time_id' is missing.", call. = FALSE)
  }
  enhydris_get(subdomain, "time_data", time_id = time_id, utc_offset = utc_offset)
}
get_stations <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "stations", translit)
}
get_timeseries <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "timeseries", translit)
}
get_instruments <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "instruments", translit)
}
get_water_basins <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "water_basin", translit)
}
get_water_divisions <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "water_division", translit)
}
get_political_divisions <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "political_division", translit)
}
get_variables <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "variable", translit)
}
get_units_of_measurement <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "unit_of_measurement", translit)
}
get_time_steps <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "time_step", translit)
}
get_owners <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "owner", translit)
}
get_instruments_type <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "instrument_type", translit)
}
get_station_type <- function(subdomain = "kyy", translit = TRUE) {
  enhydris_get(subdomain, "station_type", translit)
}
get_database <- function(subdomain = "kyy", translit = TRUE) {
  list(stations = get_stations(subdomain, translit),
       timeseries = get_timeseries(subdomain, translit),
       instruments = get_instruments(subdomain, translit),
       water_basins = get_water_basins(subdomain, translit),
       water_divisions = get_water_divisions(subdomain, translit),
       political_divisions = get_political_divisions(subdomain, translit),
       variables = get_variables(subdomain, translit),
       units_of_measurement = get_units_of_measurement(subdomain, translit),
       time_steps = get_time_steps(subdomain, translit),
       owners = get_owners(subdomain, translit),
       instruments_type = get_instruments_type(subdomain, translit),
       stations_type = get_station_type(subdomain, translit))
}
# TARGET: tests/testthat/test_get_table.R (append).
if (FALSE) {
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
}


# 06. CONFIRMED / MEDIUM: POINT syntax, missing points and empty results --------
# TARGET: R/hydro_coords.R. Remove create_coords() from R/utils.R afterwards:
# this vectorized parser needs no lapply/rbind or redundant wrapper. No sf Import.
# Malformed/missing points retain the existing NA-row behavior. Reject explicit
# unsupported SRIDs instead of interpreting projected metres as degrees.

hydro_coords <- function(x) {
  if (!is.character(x)) {
    stop("'x' must be a character vector of POINT geometries.", call. = FALSE)
  }
  number <- "[+-]?(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+)(?:[eE][+-]?[0-9]+)?"
  pattern <- paste0("(?i)^\\s*(?:SRID\\s*=\\s*([0-9]+)\\s*;\\s*)?",
    "POINT\\s*\\(\\s*(", number, ")\\s+(", number, ")\\s*\\)\\s*$")
  matched <- stringr::str_match(x, pattern)
  unsupported <- !is.na(matched[, 2]) & matched[, 2] != "4326"
  if (any(unsupported)) {
    stop("Unsupported SRID at row(s): ", paste(which(unsupported), collapse = ", "),
         ". Transform explicitly to EPSG:4326 first.", call. = FALSE)
  }
  longitude <- as.numeric(matched[, 3])
  latitude <- as.numeric(matched[, 4])
  valid <- is.finite(longitude) & is.finite(latitude) &
    abs(longitude) <= 180 & abs(latitude) <= 90
  longitude[!valid] <- NA_real_
  latitude[!valid] <- NA_real_
  tibble::tibble(long = longitude, lat = latitude)
}
# TARGET: tests/testthat/test_hydro_coords.R (append; retain existing test).
if (FALSE) {
  testthat::test_that("POINT parsing handles whitespace and keeps its schema", {
    x <- c("POINT(23 38)", " POINT (23  38) ", "POINT (23\t38)",
           "SRID=4326;POINT (2.3e1 38)")
    testthat::expect_equal(hydro_coords(x),
      tibble::tibble(long = rep(23, 4), lat = rep(38, 4)))
    testthat::expect_equal(hydro_coords(character()),
      tibble::tibble(long = double(), lat = double()))
    testthat::expect_equal(hydro_coords(c(NA_character_, "", "JUNK (23 38)",
                                          "POINT (181 38)")),
      tibble::tibble(long = rep(NA_real_, 4), lat = rep(NA_real_, 4)))
    testthat::expect_error(hydro_coords("SRID=2100;POINT (500000 4200000)"),
                           "Unsupported SRID")
    testthat::expect_error(hydro_coords(23), "character vector")
  })
}


# 07. CONFIRMED / MEDIUM: station CRS documentation ----------------------------
# TARGET: R/get_tables.R, R/data.R (stations only), R/hydro_coords.R,
# vignettes/intro_hydroscoper.Rmd; regenerate corresponding man/*.Rd.
# Live stations specify SRID=4326. No transformation to ETRS89 occurs. Correct
# the description, not the coordinate values. Keep the borders dataset's ETRS89
# documentation separate; its generation does transform to EPSG:4258.
#
# Replace the two-line coordinate statement in R/get_tables.R with:
#' Station coordinates are supplied in WGS84 (EPSG:4326).
# Replace ONLY the stations longitude/latitude descriptions in R/data.R with:
#' \item{longitude}{The station's longitude in decimal degrees, WGS84 (EPSG:4326)}
#' \item{latitude}{The station's latitude in decimal degrees, WGS84 (EPSG:4326)}
# Add to R/hydro_coords.R:
#' @details Accepts two-dimensional POINT strings with optional SRID=4326.
#'   Points without an SRID are assumed to use WGS84. No transformation is
#'   performed. Unsupported explicit SRIDs cause an error. Missing, malformed
#'   or out-of-range points return NA coordinates, retaining the input rows.
# Vignette replacements:
#   6. `longitude` The station's longitude in decimal degrees, WGS84 (EPSG:4326).
#   7. `latitude` The station's latitude in decimal degrees, WGS84 (EPSG:4326).


# 08. CONFIRMED / MEDIUM: exact water-division mappings ------------------------
# TARGET: R/translit.R, replace map_wd(). Full names must not become GR03OS or
# GR07ADA. Keep truncated aliases; preserve unknown inputs rather than partially
# translating them. This exact lookup is simpler than chained substitutions.

map_wd <- function(y) {
  if (!is.character(y)) stop("'y' must be a character vector.", call. = FALSE)
  keys <- stringr::str_to_upper(stringr::str_remove_all(y, "\\s+"))
  dictionary <- c(
    DYTIKEPELOPONNESOS = "GR01", BOREIAPELOPONNESOS = "GR02",
    ANATOLIKEPELOPONNES = "GR03", ANATOLIKEPELOPONNESOS = "GR03",
    DYTIKESTEREAELLADA = "GR04", EPEIROS = "GR05", ATTIKE = "GR06",
    ANATOLIKESTEREAELL = "GR07", ANATOLIKESTEREAELLADA = "GR07",
    THESSALIA = "GR08", DYTIKEMAKEDONIA = "GR09", KENTRIKEMAKEDONIA = "GR10",
    ANATOLIKEMAKEDONIA = "GR11", THRAKE = "GR12", KRETE = "GR13",
    NESOIAIGAIOU = "GR14")
  translated <- unname(dictionary[keys])
  found <- !is.na(translated)
  y[found] <- translated[found]
  y
}
# TARGET: tests/testthat/test_translit.R (append; retain existing mappings).
if (FALSE) {
  testthat::test_that("full division names and truncated aliases map exactly", {
    x <- c("ANATOLIKE PELOPONNESOS", "ANATOLIKE PELOPONNES",
           "anatolike\tsterea ellada", "ANATOLIKE STEREA ELL", "unknown", NA)
    testthat::expect_equal(hydro_translate(x, "division"),
      c("GR03", "GR03", "GR07", "GR07", "unknown", NA_character_))
  })
}


# 09. CONFIRMED RISK / MEDIUM: preserve units and structured fields ------------
# TARGET: R/translit.R, replace translit_all(). The Greek micro-to-milli example
# is synthetic; those units were not found in the sampled live tables. Scientific
# symbols still must not change. Retain the pushed numeric-type preservation.
# Transliterate descriptive fields, including remarks/acronyms, while preserving
# symbol, URLs, IDs, geometry and dates. Do not blanket-transform every string.

translit_all <- function(df) {
  columns <- intersect(names(df), c("name", "name_alt", "short_name",
    "short_name_alt", "descr", "descr_alt", "remarks", "remarks_alt",
    "acronym", "acronym_alt", "ordering_string"))
  columns <- columns[vapply(df[columns], is.character, logical(1))]
  df[columns] <- lapply(df[columns], function(x) {
    stringi::stri_trans_general(x, "Greek-Latin; Latin-ASCII")
  })
  df
}
# TARGET: tests/testthat/test_translit.R (append).
if (FALSE) {
  testthat::test_that("transliteration preserves units and numeric IDs", {
    original <- data.frame(id = 1:2, name = c("\u0391\u0398\u0397\u039d\u0391", NA),
      symbol = c("\u03bcg/L", "\u03bcS/cm"),
      url = c("https://example.org/\u03bc", "https://example.org/"))
    result <- translit_all(original)
    testthat::expect_equal(result$name, c("ATHENA", NA_character_))
    testthat::expect_identical(result[c("id", "symbol", "url")],
                               original[c("id", "symbol", "url")])
    testthat::expect_identical(translit_all(data.frame()), data.frame())
  })
}


# 10. CONFIRMED / MEDIUM: validate before any request ---------------------------
# TARGET: R/enhydris_api.R. Missing time_id is handled in section 05; the
# workhorse uses these helpers in section 11. Scalar defaults remove the need
# for match.arg(). Accept positive integer numbers/decimal strings for time_id;
# reject numbers outside exact double-integer precision rather than rounding.

hydro_validate_subdomain <- function(subdomain) {
  if (!is.character(subdomain) || length(subdomain) != 1L ||
      is.na(subdomain) || !subdomain %in% c("kyy", "ypaat", "emy", "deh")) {
    stop("'subdomain' must be one of: kyy, ypaat, emy, deh.", call. = FALSE)
  }
  subdomain
}

hydro_validate_time_id <- function(time_id) {
  invalid <- function() stop("'time_id' must be one positive integer ID.",
                             call. = FALSE)
  if (length(time_id) != 1L || is.complex(time_id) ||
      !(is.character(time_id) || is.numeric(time_id)) || is.na(time_id)) invalid()
  if (is.character(time_id)) {
    if (!grepl("^[0-9]+$", time_id)) invalid()
    time_id <- as.numeric(time_id)
  }
  if (!is.finite(time_id) || time_id < 1 || time_id != trunc(time_id) ||
      time_id > 2^53 - 1) invalid()
  sprintf("%.0f", time_id)
}
# TARGET: tests/testthat/test_get_data.R (append).
if (FALSE) {
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
}


# 11. CONFIRMED / MEDIUM: retain the actual failure cause ----------------------
# TARGET: R/enhydris_api.R, add transport and replace enhydris_get().
# Keep existing enhydris_names() and enhydris_url() unchanged; section 01 passes
# the verified "TimeZone" resource name directly to the URL builder.
# Transport errors retain their cause. Parser errors get separate context and
# transformation errors propagate normally, without being called download errors.
# No custom condition hierarchy or configurable-base-URL framework is necessary.
# url()/readLines() raise HTTP failures; validation handles bad HTTP-200 payloads.
# Retain legacy API HTTP until provider TLS works. Never disable certificate checks.

enhydris_read_text <- function(hydro_url) {
  tryCatch({
    con <- url(hydro_url, open = "rb", method = "libcurl")
    on.exit(close(con), add = TRUE)
    paste(readLines(con, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  }, error = function(e) {
    stop("Could not download ", hydro_url, ": ", conditionMessage(e), call. = FALSE)
  })
}

enhydris_get <- function(subdomain = "kyy", api_value, translit = TRUE,
                         time_id = NULL, utc_offset = NULL) {
  subdomain <- hydro_validate_subdomain(subdomain)
  if (!is.logical(translit) || length(translit) != 1L || is.na(translit)) {
    stop("'translit' must be a single TRUE or FALSE.", call. = FALSE)
  }
  api <- enhydris_names(api_value)
  if (identical(api_value, "time_data")) {
    time_id <- hydro_validate_time_id(time_id)
    utc_offset <- if (is.null(utc_offset)) {
      hydro_time_offset(subdomain, time_id)
    } else hydro_validate_offset(utc_offset)
    return(enhydris_txt(enhydris_url(subdomain, api, time_id), utc_offset))
  }
  if (!is.null(time_id) || !is.null(utc_offset)) {
    stop("'time_id' and 'utc_offset' apply only to time-series downloads.",
         call. = FALSE)
  }
  result <- hydro_validate_table(
    enhydris_json(enhydris_url(subdomain, api)), api_value)
  if (translit) translit_all(result) else result
}
# TARGET: tests/testthat/test_enhydris.R (append).
if (FALSE) {
  testthat::test_that("transformation failures are not called download failures", {
    testthat::local_mocked_bindings(
      enhydris_json = function(...) data.frame(id = 1, name = "A"),
      translit_all = function(...) stop("Deliberate transformation failure"),
      .package = "hydroscoper")
    testthat::expect_error(get_owners("kyy"), "^Deliberate transformation failure$")
  })
}


# 12. CONFIRMED / MAINTENANCE: data-generation scripts -------------------------
# These files are excluded by .Rbuildignore, not direct CRAN check failures.
# get_coords() was removed; devtools::use_data is no longer exported. Partial
# names such as $units should be exact; schema checks must stop on failure.
#
# TARGET: data-raw/create_pck_data.R, full replacement CONTENTS below.
# Run only when ALL intended providers are available, or deliberately use
# archived raw responses with recorded dates. Do not silently omit DEH.
# Section 03 repairs known labels without requiring a full live refresh.
# Dates stay verbatim; run section 13's quality audit before saving.
if (FALSE) {
  library(hydroscoper)
  subdomains <- c("kyy", "ypaat", "emy", "deh")
  retrieved_at <- Sys.time()
  hydro_data <- setNames(lapply(subdomains, get_database), subdomains)

  require_columns <- function(x, columns) {
    if (!is.data.frame(x) || !all(columns %in% names(x))) {
      stop("Missing required columns: ", paste(columns, collapse = ", "))
    }
  }
  lookup <- function(x, column) {
    require_columns(x, c("id", column))
    stopifnot(!anyNA(x$id), !anyDuplicated(x$id))
    x[c("id", column)]
  }

  stations <- tibble::as_tibble(do.call(rbind, lapply(subdomains, function(id) {
    db <- hydro_data[[id]]
    require_columns(db$stations, c("id", "name", "point", "altitude",
                                   "owner", "water_basin", "water_division"))
    stopifnot(nrow(db$stations) > 0L)
    basin <- lookup(db$water_basins, "name")
    division <- lookup(db$water_divisions, "name")
    owner <- lookup(db$owners, "name")
    basin$name <- trimws(gsub("\\([^()]*\\)", "", basin$name))
    division$name <- hydro_translate(division$name, "division")
    owner$name <- hydro_translate(owner$name, "owner")
    names(basin) <- c("water_basin", "water_basin_name")
    names(division) <- c("water_division", "water_division_name")
    names(owner) <- c("owner", "owner_name")
    x <- merge(db$stations, basin, by = "water_basin", all.x = TRUE)
    x <- merge(x, division, by = "water_division", all.x = TRUE)
    x <- merge(x, owner, by = "owner", all.x = TRUE)
    coords <- hydro_coords(x$point)
    tibble::tibble(station_id = as.integer(x$id), name = x$name,
      water_basin = x$water_basin_name, water_division = x$water_division_name,
      owner = x$owner_name, longitude = coords$long, latitude = coords$lat,
      altitude = as.numeric(x$altitude), subdomain = rep(id, nrow(x)))
  })))

  timeseries <- tibble::as_tibble(do.call(rbind, lapply(subdomains, function(id) {
    db <- hydro_data[[id]]
    require_columns(db$timeseries,
      c("id", "gentity", "variable", "time_step", "unit_of_measurement"))
    x <- db$timeseries
    # Fill absent columns only; never overwrite existing DEH dates with NA.
    for (column in c("start_date_utc", "end_date_utc")) {
      if (!column %in% names(x)) x[[column]] <- rep(NA_character_, nrow(x))
    }
    variables <- lookup(db$variables, "descr")
    steps <- lookup(db$time_steps, "descr")
    units <- lookup(db$units_of_measurement, "symbol")
    variables$descr <- hydro_translate(variables$descr, "variable")
    steps$descr <- hydro_translate(steps$descr, "timestep")
    names(variables) <- c("variable", "variable_name")
    names(steps) <- c("time_step", "step_name")
    names(units) <- c("unit_of_measurement", "unit_symbol")
    x <- merge(x, variables, by = "variable", all.x = TRUE)
    x <- merge(x, steps, by = "time_step", all.x = TRUE)
    x <- merge(x, units, by = "unit_of_measurement", all.x = TRUE)
    tibble::tibble(time_id = as.integer(x$id), station_id = as.integer(x$gentity),
      variable = x$variable_name, timestep = x$step_name, units = x$unit_symbol,
      start_date = as.character(x$start_date_utc),
      end_date = as.character(x$end_date_utc), subdomain = rep(id, nrow(x)))
  })))

  stopifnot(ncol(stations) == 9L, ncol(timeseries) == 8L,
    !anyDuplicated(stations[c("subdomain", "station_id")]),
    !anyDuplicated(timeseries[c("subdomain", "time_id")]))
  print(table(stations$subdomain))
  print(table(timeseries$subdomain))
  # Review counts, unmatched lookups and section 13's date audit before saving.
  # Store raw responses and provenance outside the shipped data/ directory.
  saveRDS(list(retrieved_at = retrieved_at, data = hydro_data),
    file.path("data-raw", paste0("hydroscope_raw_",
      format(retrieved_at, "%Y%m%dT%H%M%S", tz = "UTC"), "Z.rds")))
  usethis::use_data(stations, timeseries, overwrite = TRUE)
}

# TARGET: data-raw/create_borders.R, full replacement CONTENTS below.
# sf replaces archived rgdal/sp/broom processing in this maintainer script.
# Preserve the public six-column schema and ETRS89/EPSG:4258 coordinates.
# Verify the .prj is equivalent to EPSG:2100, then normalize its authority ID.
# With the anonymous legacy WKT, PROJ selected a ballpark transformation here
# and shifted some coordinates by hundreds of metres. The verified EPSG code
# selects the intended datum transformation; disallow ballpark fallback.
# Do not assign 2100 to an unrelated or unknown CRS. Group identifiers/order can
# change; compare coordinate sets and render the vignette maps.
if (FALSE) {
  shape <- sf::st_read("data-raw/greece_shp/greece.shp", quiet = TRUE)
  stopifnot(!is.na(sf::st_crs(shape)), sf::st_crs(shape) == sf::st_crs(2100))
  shape <- sf::st_set_crs(shape, 2100)
  geometry <- sf::st_cast(sf::st_geometry(sf::st_transform(
                           shape, 4258, allow_ballpark = FALSE)),
                           "MULTIPOLYGON")
  xy <- sf::st_coordinates(geometry)
  # L1=ring, L2=polygon, L3=feature for MULTIPOLYGON coordinates.
  stopifnot(all(c("X", "Y", "L1", "L2", "L3") %in% colnames(xy)))
  rings <- interaction(xy[, "L3"], xy[, "L2"], xy[, "L1"], drop = TRUE)
  greece_borders <- tibble::tibble(long = xy[, "X"], lat = xy[, "Y"],
    order = as.integer(ave(seq_len(nrow(xy)), rings, FUN = seq_along)),
    hole = xy[, "L1"] > 1,
    piece = interaction(xy[, "L3"], xy[, "L2"], drop = TRUE), group = rings)
  usethis::use_data(greece_borders, overwrite = TRUE)
}


# 13. CONFIRMED UPSTREAM DEFECT / MEDIUM: impossible metadata date -------------
# TARGET: data-raw/validate_metadata.R; R/data.R (timeseries @note).
# KYY/806, station 200208 has end_date=4994-03-01T07:59:00+02:00 both upstream
# and in the bundle. Do not invent a year or silently discard the record.
# Preserve the eight-column public schema for this release, document the defect
# and create a separate audit report/validated analysis copy. A new public
# quality column needs a separate documented schema change.
if (FALSE) {
  # Use the constructed timeseries object or load the bundled dataset first.
  audit <- timeseries[c("subdomain", "time_id", "start_date", "end_date")]
  start <- suppressWarnings(readr::parse_datetime(audit$start_date))
  end <- suppressWarnings(readr::parse_datetime(audit$end_date))
  cutoff <- as.POSIXct(Sys.Date() + 1, tz = "UTC")
  audit$invalid_start <- !is.na(audit$start_date) & is.na(start)
  audit$invalid_end <- !is.na(audit$end_date) & is.na(end)
  audit$future_start <- !is.na(start) & start > cutoff
  audit$future_end <- !is.na(end) & end > cutoff
  audit$reversed <- !is.na(start) & !is.na(end) & end < start
  issue <- rowSums(audit[c("invalid_start", "invalid_end", "future_start",
                           "future_end", "reversed")]) > 0
  print(audit[issue, ])
  utils::write.csv(audit[issue, ], "data-raw/metadata_date_issues.csv",
                   row.names = FALSE, na = "")
  validated <- timeseries
  validated$start_date[audit$invalid_start | audit$future_start | audit$reversed] <- NA_character_
  validated$end_date[audit$invalid_end | audit$future_end | audit$reversed] <- NA_character_
  # Use validated for analysis; keep the original dates in the distributed data.
}
# R/data.R, timeseries documentation addition:
#' @note Dates are supplied by upstream providers and may contain errors.
#'   In the bundled snapshot, KYY time series 806 reports an end year of 4994.
#'   This raw value is retained for provenance and should not be used as a
#'   valid coverage endpoint. The datasets are snapshots, not live inventories.


# 14. VALID LATENT ISSUE / LOW: use the complete station key -------------------
# No false matches occur in the reviewed snapshot, but IDs are documented as
# nonunique between providers. No extra join dependency is needed.
# TARGET: vignettes/stations_with_data.Rmd, replace stations_ts assignment.
if (FALSE) {
  station_key <- paste(stations$subdomain, stations$station_id, sep = "/")
  series_key <- paste(timeseries$subdomain, timeseries$station_id, sep = "/")
  stations_ts <- stations[station_key %in% series_key &
                          stations$subdomain %in% c("kyy", "ypaat"), ]
}
# TARGET: vignettes/intro_hydroscoper.Rmd, replace station_ts assignment.
if (FALSE) {
  station_ts <- subset(timeseries, subdomain == "kyy" & station_id == 200200)
}
# TARGET: tests/testthat/test_data.R (append).
if (FALSE) {
  testthat::test_that("station availability respects provider boundaries", {
    stations <- data.frame(subdomain = c("kyy", "ypaat"), station_id = c(1, 1))
    timeseries <- data.frame(subdomain = "ypaat", station_id = 1)
    station_key <- paste(stations$subdomain, stations$station_id, sep = "/")
    series_key <- paste(timeseries$subdomain, timeseries$station_id, sep = "/")
    result <- stations[station_key %in% series_key, ]
    testthat::expect_equal(result$subdomain, "ypaat")
  })
}


# 15. CONFIRMED / LOW: consistent, justified minimum versions ------------------
# TARGET: DESCRIPTION and README.Rmd (regenerate README.md).
# The local R >= 4.6 edit is not in the push. No examined package code needs 4.6
# specifically. Installed stringr/readr/testthat require R >= 4.1; that is a
# candidate floor, NOT a completed compatibility test. Test the chosen older R
# and dependency set before lowering the declaration. Keep >= 4.6 if that is
# the intended tested support policy. Do not raise every minimum to the newest
# installed version without a feature requirement. Remove httptest (section 04)
# and the trailing whitespace after stringr in the local DESCRIPTION edit.
#
# Conservative DESCRIPTION replacement stanza retaining your LOCAL version
# choices, while removing the unused mocking dependency (not a claim that all
# these minima are necessary). Copy after removing a single '# ' prefix:
# Depends: R (>= 4.6)
# Imports:
#     stringi (>= 1.8),
#     stringr (>= 1.6),
#     tibble (>= 3.3),
#     readr (>= 2.2),
#     jsonlite (>= 2.0)
# Suggests:
#     ggplot2 (>= 4.0),
#     knitr (>= 1.52),
#     rmarkdown (>= 2.32),
#     testthat (>= 3.3.2)
# Keep the other DESCRIPTION fields, correcting reviewer URLs in section 16.
#
# Consistent README badge if retaining the present >= 4.6 support policy:
# [![minimal R version](https://img.shields.io/badge/R%3E%3D-4.6-6666ff.svg)](https://cran.r-project.org/)
# If tests establish support for 4.1, change BOTH Depends and the badge to 4.1.
# Derive the package-version badge from DESCRIPTION instead of a stale literal:
# [![packageversion](https://img.shields.io/badge/Package%20version-`r read.dcf("DESCRIPTION")[1, "Version"]`-orange.svg?style=flat-square)](https://github.com/ropensci/hydroscoper)
# The actual release version belongs in DESCRIPTION and NEWS (section 18).


# 16. LINK ISSUES: exact replacements and limits of evidence ------------------
# Checked 2026-11-08. The Codecov fix in 56d9697 (January 2024) already uses the
# working https://app.codecov.io/gh/ropensci/hydroscoper URL. Keep it.
# CRAN says archived 2022-10-02 for policy violation, without identifying the
# README as its cause. Consult maintainer correspondence before claiming a cause.
# https://cran.rstudio.com/web/packages/hydroscoper/index.html
# https://cran-archive.r-project.org/web/checks/2022/2022-10-03_check_results_hydroscoper.html
#
# TARGET: DESCRIPTION Authors@R comments (both reviewers); regenerate man/.
# Replace https://github.com/ropensci/onboarding/issues/185 (404) with:
#   https://github.com/ropensci/software-review/issues/185 (200)
#
# TARGET: README.Rmd, R/hydroscoper_package.R, paper.bib (excluded from build).
# Replace http://www.hydroscope.gr[/] with https://hydroscope.gr/.
# www failed certificate validation; non-www succeeded. Do NOT change provider
# API hosts by applying this replacement to their subdomains.
#
# TARGET: vignettes/intro_hydroscoper.Rmd, R/hydroscoper_package.R.
# Replace http://enhydris.readthedocs.io and the bare HTTPS root with:
#   https://enhydris.readthedocs.io/en/latest/
# Clarify that hydroscoper uses the LEGACY API; current Enhydris documentation
# also describes newer APIs. Updating a documentation link is not API migration.
#
# TARGET: README.Rmd, direct HTTPS badge/footer sources:
#   https://www.r-pkg.org/badges/version/hydroscoper
#   https://joss.theoj.org/papers/10.21105/joss.00625/status.svg
#   https://ropensci.org/public_images/github_footer.png
# Existing HTTP links redirect successfully; these are cleanup, not dead URLs.
#
# TARGET: vignettes/intro_hydroscoper.Rmd, replace availability claims with:
#   Service availability can change. On 2026-11-08 the KYY, YPAAT and EMY
#   metadata APIs responded; the DEH hostname did not resolve. The bundled
#   datasets include historical DEH metadata. Public metadata access does not
#   imply permission to download every measurement series.
# Do not remove deh from accepted subdomains solely because of an outage.
# Provider API HTTPS checks failed certificate validation; keep working HTTP
# endpoints until provider TLS is corrected. Never disable verification.
#
# Canonical CRAN URLs timed out locally; a mirror responded. Keep canonical CRAN
# links and recheck elsewhere. urlchecker reported those timeouts and Enhydris's
# redirect, but did not discover every manually checked prose/comment URL.
# README.Rmd is excluded from the tarball; its generated README.md still matters.


# 17. LATEST PUSH: keep good fixes and finish incomplete ones -----------------
# TARGET: retain current code except for replacements explicitly proposed above.
# - 18849a1: escaping el./meg. is correct; section 03 fixes saved old outputs.
# - e5f4835: helper rename/numeric preservation are correct; section 09 protects
#   unit symbols. All callers already use the corrected translit_all spelling.
# - be75979: find_stations scalar/range guards and corrected docs are sound.
# - fb03531: removing explicit url() from read_csv was reasonable. Sections
#   01/02/11 now add fixed-offset parsing and an explicitly closed transport.
# - c79fa73: default subdomains already failed on current R before the push
#   (condition length > 1). Section 05 fixes the root cause; this is not a proven
#   newly introduced regression.
# - cbce43e: duplicated is.null(time_id) does not handle missing(); section 05.
# - fa9d880: NA_real_ improves types but not syntax/empty schema; section 06.
# - Dataset dimensions, CITATION volume 3, testthat expectation updates and
#   removal of .Rbuildignore conflict markers are correct.
# - README.Rmd now has volume 3, but README.md still has volume 2. Regenerate it.
# No confirmed new runtime regression was found in these pushed fixes. The old
# proposal's ID-zero rejection and mandatory tz were separate proposed changes.
#
# TARGET: tests/testthat/test_find_stations.R (append for the existing fix).
if (FALSE) {
  testthat::test_that("invalid station coordinates produce the intended error", {
    for (x in list(NULL, NA, NaN, Inf, -Inf, c(23, 24), "23")) {
      testthat::expect_error(find_stations(x, 38), "Valid longitude values")
      testthat::expect_error(find_stations(24, x), "Valid longitude values")
    }
  })
}
# TARGET: README.Rmd setup chunk, replace the online()/chk_online setup with
# the following CONTENTS. The download example stays visible but unevaluated.
# A deliberate online maintainer render may opt into TRUE. A working homepage
# does not guarantee that downloading the illustrated series will succeed.
if (FALSE) {
  knitr::opts_chunk$set(collapse = TRUE, comment = "#>",
                       fig.path = "man/figures/README-")
  chk_online <- FALSE
}


# 18. CI AND RELEASE: distinguish infrastructure from package failures --------
# Latest push: Windows/macOS/Linux release passed. Linux devel failed during
# installation with "there is no package called 'tic'"; package checks never ran.
# https://github.com/ropensci/hydroscoper/actions/runs/42414522942
# Diagnose the bootstrap failure before claiming R-devel compatibility.
#
# TARGET: .github/workflows/tic.yml, replace ONLY the [Stage] Install step.
# Avoid constructing a binary-repository path from a changing Ubuntu version;
# use source packages on Linux. This is a proposed improvement, not proof of
# the upstream failure's exact cause. Copy YAML after removing one '# ' prefix:
#
#      - name: "[Stage] Install"
#        shell: Rscript {0}
#        run: |
#          options(repos = c(ropensci = "https://ropensci.r-universe.dev",
#                            CRAN = "https://cloud.r-project.org"), Ncpus = 2L)
#          if (Sys.info()[["sysname"]] == "Linux") options(pkgType = "source")
#          install.packages("tic")
#          if (!requireNamespace("tic", quietly = TRUE)) {
#            stop("tic installation failed; inspect the installation log above.")
#          }
#          print(tic::dsl_load())
#          tic::prepare_all_stages()
#          tic::before_install()
#          tic::install()
#
# Change setup-r's Ncpus: 4 to Ncpus: 2. Refresh action versions separately after
# reading migration notes; observed Node warnings do not establish why tic failed.
# Add the chosen minimum-R matrix entry after section 15's support decision.
#
# TARGET: DESCRIPTION / NEWS.md. Choose a release version (e.g. 1.8.0) after
# implementation/testing. Proposed NEWS (remove comment prefixes):
#
# # hydroscoper 1.8.0
#
# * Correct legacy timestamps using provider UTC-offset metadata; allow an
#   explicit source offset through get_data(utc_offset = ...).
# * Reject malformed downloads and validate arguments before requests.
# * Repair stored variable labels and preserve scientific unit symbols.
# * Accept standard POINT whitespace, preserve empty coordinate columns and
#   document station coordinates as WGS84.
# * Fix default subdomains and full water-division translations.
# * Make tests independent of public services; update documentation and links.
#
# Include only implemented changes. Explain changed timestamp instants and check
# reverse dependencies before submission. Do not call 1.7.9000 a stable release.
#
# TARGET: cran-comments.md. Replace stale R 4.2.1/AppVeyor claims with ACTUAL
# final environments/results. Template (fill after checks, remove prefixes):
#
# ## Resubmission
# This resubmission addresses offline tests, response validation, timestamp
# interpretation, stored metadata labels, and documentation URLs.
# [Explain how the original CRAN maintainer feedback was addressed too.]
#
# ## Test environments and results
# [Exact R versions/platforms and ERROR/WARNING/NOTE counts.]
# [State whether manual generation and incoming URL checks were performed.]
#
# ## Reverse dependencies
# [Record the current query and checks; do not repeat the old assertion of no
# downstream dependencies without verifying it.]
#
# Run deliberately AFTER integrating proposals, never while sourcing this guide:
if (FALSE) {
  devtools::document()
  rmarkdown::render("README.Rmd", output_format = "github_document")
  devtools::test()
  urlchecker::url_check()
  tarball <- devtools::build()
  rcmdcheck::rcmdcheck(tarball, args = "--as-cran", error_on = "never")
}
# Run tests offline too. Review README/man/vignette diffs and render maps after
# data changes. Complete R-devel, incoming/manual and relevant reverse-dependency
# checks before submitting; explain any remaining diagnostics accurately.
