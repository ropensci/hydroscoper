
#' @title Get tibbles from Hydroscope
#'
#' @description  A family of functions that return a tibble from a specific
#'  database from Hydroscope using the Enhydris API. \code{get_database} returns
#'  a named list of tibbles using all the family's functions.
#'
#' @param subdomain One of the subdomains of Hydroscope in the vector
#' \code{c("kyy", "ypaat", "emy", "deh")}.
#' @param translit Automatically transliterate Greek to Latin.
#'
#' @return If \code{subdomain} is one of:
#' \itemize{
#' \item{\code{kyy}, Ministry of Environment and Energy.}
#' \item{\code{ypaat}, Ministry of Rural Development and Food.}
#' \item{\code{deh}, Greek Public Power Corporation.}
#' \item{\code{emy}, National Meteorological Service.}
#' }
#' returns a tibble or a named list with tibbles from the corresponding
#' database. Otherwise returns an error message.
#'
#' @note Objects' IDs are not unique among the different Hydroscope databases.
#' For example, time series' IDs from http://kyy.hydroscope.gr have same values
#' with time series' from http://ypaat.hydroscope.gr.
#'
#' The coordinates of the stations are based on the European Terrestrial
#' Reference System 1989 (ETRS89).
#'
#' @examples
#'
#' \dontrun{
#'
#' # data will be downloaded from Ministry of Environment and Energy (kyy):
#' subdomain <- "kyy"
#'
#' # stations
#' kyy_stations <- get_stations(subdomain)
#'
#' # time series
#' kyy_ts <- get_timeseries(subdomain)
#'
#' # instruments
#' kyy_inst <- get_instruments(subdomain)
#'
#' # water basins
#' kyy_wbas <- get_water_basins(subdomain)
#'
#' # water divisions
#' kyy_wdiv <- get_water_divisions(subdomain)
#'
#' # political divisions
#' kyy_pol <- get_political_divisions(subdomain)
#'
#' # variables
#' kyy_vars <- get_variables(subdomain)
#'
#' # units of measurement
#' kyy_units <- get_units_of_measurement(subdomain)
#'
#' # time steps
#' kyy_time_steps <- get_time_steps(subdomain)
#'
#' # owners
#' kyy_owners <- get_owners(subdomain)
#'
#' # instruments type
#' kyy_instr_type <- get_instruments_type(subdomain)
#'
#' # stations' type
#' kyy_st_type <- get_station_type(subdomain)
#'
#' # use all the get_ functions above to create a named list with tibbles
#' kyy_db <- get_database(subdomain)
#'
#' }
#'
#' @references
#'
#' The data are retrieved from the Hydroscope's \url{http://www.hydroscope.gr/}
#' databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change.
#' \item Ministry of Rural Development and Food.
#' \item National Meteorological Service.
#' \item Greek Public Power Corporation.
#'}
#'
#' European Terrestrial Reference System 1989 (ETRS),
#' \url{http://bit.ly/2kJwFuf}
#'
#' Greek Water Divisions,
#' \url{http://bit.ly/2kk0tOm}, \url{http://bit.ly/2ltQC8O}
#'
#' Greek Water Basins,
#' \url{http://bit.ly/2Dvzo1W}
#'
#' Tibble, \url{http://tibble.tidyverse.org/}
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#'
#' @name get_tables
NULL

#' @rdname get_tables
#' @export get_stations
get_stations <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE) {

  api <- "stations"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)

}

#' @rdname get_tables
#' @export get_timeseries
get_timeseries <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "timeseries"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)

}

#' @rdname get_tables
#' @export get_instruments
get_instruments <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "instruments"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_water_basins
get_water_basins <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_basin"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_water_divisions
get_water_divisions <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_division"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_political_divisions
get_political_divisions <- function(subdomain =  c("kyy", "ypaat", "emy",
                                                   "deh"),
                               translit = TRUE){
  api <- "political_division"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_variables
get_variables <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                   translit = TRUE){
  api <- "variable"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_units_of_measurement
get_units_of_measurement <- function(subdomain =  c("kyy", "ypaat", "emy",
                                                    "deh"),
                         translit = TRUE){
  api <- "unit_of_measurement"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_time_steps
get_time_steps <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                     translit = TRUE){
  api <- "time_step"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}


#' @rdname get_tables
#' @export get_owners
get_owners <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "owner"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}


#' @rdname get_tables
#' @export get_instruments_type
get_instruments_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                       translit = TRUE){
  api <- "instrument_type"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_station_type
get_station_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                 translit = TRUE){
  api <- "station_type"
  enhydris_get(subdomain = subdomain, api_value = api, translit = translit)
}

#' @rdname get_tables
#' @export get_database
get_database <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE) {

  list("stations" = get_stations(subdomain, translit),
       "timeseries" = get_timeseries(subdomain, translit),
       "instruments" = get_instruments(subdomain, translit),
       "water_basins" = get_water_basins(subdomain, translit),
       "water_divisions" = get_water_divisions(subdomain, translit),
       "political_divisions" = get_political_divisions(subdomain, translit),
       "variables" = get_variables(subdomain, translit),
       "units_of_measurement" = get_units_of_measurement(subdomain, translit),
       "time_steps" = get_time_steps(subdomain, translit),
       "owners" = get_owners(subdomain, translit),
       "instruments_type" = get_instruments_type(subdomain, translit),
       "stations_type" = get_station_type(subdomain, translit))
}
