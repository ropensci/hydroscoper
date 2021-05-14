
#' get a list with available tables
#'
#' @noRd
enhydris_list <- function(subdomain) {
  hydro_url <- paste0("http://", subdomain, ".hydroscope.gr/api/?format=json") # nolint
  enhydris_json(hydro_url)
}

#' get a data frame from a JSON file
#'
#' @noRd
enhydris_json <- function(hydro_url) {
  jsonlite::fromJSON(hydro_url, flatten = TRUE)
}

#' get a data frame from a TXT file
#'
#' @noRd
enhydris_txt <- function(hydro_url) {

  # enhydris time format
  tm_format <- "%Y-%m-%d %H:%M"
  suppressWarnings(
    # use readr to get values
    readr::read_csv(url(hydro_url),
      col_names = c("date", "value", "comment"),
      col_types = list(
        readr::col_datetime(format = tm_format),
        readr::col_double(),
        readr::col_character()
      )
    )
  )
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
enhydris_get <- function(subdomain = c("kyy", "ypaat", "emy", "deh"),
                         api_value,
                         translit = TRUE,
                         time_id = NULL) {

  # testing arguments and server availability ----------------------------------

  # match subdomain values
  subdomain <- match.arg(subdomain)

  # check if server is alive
  server_alive(subdomain)

  # create hydroscope url
  api <- enhydris_names(api_value)
  if (is.null(time_id)) {
    hydro_url <- enhydris_url(subdomain, api, time_id = NULL)
  } else {
    hydro_url <- enhydris_url(subdomain, api, time_id)
  }

  # try to get data ------------------------------------------------------------

  tryCatch({
    if (is.null(time_id)) {
      # data are a JSON file
      result <- tibble::as_tibble(enhydris_json(hydro_url))
      if (translit) {
        # translitarate values
        trasnlit_all(result)
      } else {
        result
      }
    } else {
      # data are a TXT file, use of readr in enhydris_txt returns a tibble
      enhydris_txt(hydro_url)
    }
  },
  error = function(e) {
    err_msg <- paste(
      "Could not download data for that source.",
      "Please check that it exists or try again later."
    )
    stop(err_msg, call. = FALSE)
  }
  )
}
