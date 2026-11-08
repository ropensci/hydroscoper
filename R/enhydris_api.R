#' get text from an url
#'
#' @noRd
enhydris_read_text <- function(hydro_url) {
  tryCatch({
    con <- url(hydro_url, open = "rb", method = "libcurl")
    on.exit(close(con), add = TRUE)
    paste(readLines(con, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  }, error = function(e) {
    stop("Could not download ", hydro_url, ": ", conditionMessage(e), call. = FALSE)
  })
}



#' get a list with available tables
#'
#' @noRd
enhydris_list <- function(subdomain = "kyy") {
  subdomain <- hydro_validate_subdomain(subdomain)
  result <- enhydris_json(paste0("http://", subdomain,
                                 ".hydroscope.gr/api/?format=json"))
  if (!is.list(result) || !all(c("Station", "Timeseries") %in% names(result))) {
    stop("The response is not a supported legacy Enhydris API index.", call. = FALSE)
  }
  result
}


#' get a data frame from a JSON file
#'
#' @noRd
enhydris_json <- function(hydro_url) {
  text <- enhydris_read_text(hydro_url)
  tryCatch(
    jsonlite::parse_json(text, simplifyVector = TRUE, flatten = TRUE),
    error = function(e) {
      stop("Invalid JSON from ", hydro_url, ": ",
           conditionMessage(e), call. = FALSE)
    })
}

#' get a data frame from a TXT file
#'
#' @noRd
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


#' Convert val to API's tables' names. Change corresponding strings, if there is
#' a change in Enhydris API use `enhydris_list` to get the list of available
#' tables.
#'
#' @noRd
enhydris_names <- function(val) {
  switch(
    val,
    stations = "Station",
    timeseries = "Timeseries",
    time_data = "tsdata",
    instruments = "Instrument",
    water_basin = "WaterBasin",
    water_division = "WaterDivision",
    political_division = "PoliticalDivision",
    variable = "Variable",
    unit_of_measurement = "UnitOfMeasurement",
    time_step = "TimeStep",
    owner = "Organization",
    instrument_type = "InstrumentType",
    station_type = "StationType",
    stop("Not a valid Enhydris API", call. = FALSE)
  )
}

#' Create an URL using the subdomain and Enhydris API value
#'
#' @noRd
enhydris_url <- function(subdomain, api, time_id = NULL) {
  if (is.null(time_id)) {
    paste0("http://", subdomain, ".hydroscope.gr/api/", api, "/?format=json") # nolint
  } else {
    paste0("http://", subdomain, ".hydroscope.gr/api/tsdata/", time_id, "/") # nolint
  }
}


#' Workhorse of `get___` family functions.
#' @noRd
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


#' Validate utc offset
#'
#' @noRd
hydro_validate_offset <- function(utc_offset) {
  if (!is.numeric(utc_offset) || is.complex(utc_offset) || length(utc_offset) != 1L ||
      is.na(utc_offset) || !is.finite(utc_offset) ||
      utc_offset != trunc(utc_offset) || abs(utc_offset) >= 1440) {
    stop("'utc_offset' must be whole minutes strictly between -1440 and 1440.",
         call. = FALSE)
  }
  utc_offset
}

#' Check for missing timezone
#'
#' @noRd
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


#' Validate hydro json data
#'
#' @noRd
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

#' Validate subdomain
#'
#' @noRd
hydro_validate_subdomain <- function(subdomain) {
  if (!is.character(subdomain) || length(subdomain) != 1L ||
      is.na(subdomain) || !subdomain %in% c("kyy", "ypaat", "emy", "deh")) {
    stop("'subdomain' must be one of: kyy, ypaat, emy, deh.", call. = FALSE)
  }
  subdomain
}

#' Validate time ids
#'
#' @noRd
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
