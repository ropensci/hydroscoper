
#' Get tibbles from Hydroscope
#'
#' A family of functions that return a tibble from a specific database
#' of Hydroscope using the Enhydris API. \code{get_database} returns a named
#' list of tibbles using all the family functions.
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
#' returns a tibble or a named list with tibbles from the corresponding database
#' of Hydroscope. Otherwise returns an error message.
#'
#' @note
#' Objects' IDs are not unique among the different Hydroscope databases. For
#' example, time series' IDs from http://kyy.hydroscope.gr have same values
#' with time series' from http://ypaat.hydroscope.gr.
#'
#' The coordinates of points are based on the European Terrestrial Reference
#' System 1989 (ETRS89).
#'
#' @examples
#'
#' \dontrun{
#'
#' # get data from all the Hydroscope's subdomains
#' kyy_db <- get_database("kyy")
#' ypaat_db <- get_database("ypaat")
#' emy_db <- get_database("emy")
#' deh_db <- get_database("deh")
#'
#' }
#'
#' @references
#'
#' The data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}
#' \item{Greek Public Power Corporation},
#' \url{http://deh.hydroscope.gr}
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
#' @name get_functions
NULL

#' @rdname get_functions
#' @export get_stations
get_stations <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE) {

  api <- "stations"
  get_and_translit(subdomain, api, translit)

}

#' @rdname get_functions
#' @export get_timeseries
get_timeseries <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "timeseries"
  get_and_translit(subdomain, api, translit)

}

#' @rdname get_functions
#' @export get_instruments
get_instruments <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "instruments"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_water_basins
get_water_basins <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_basin"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_water_divisions
get_water_divisions <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_division"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_political_divisions
get_political_divisions <- function(subdomain =  c("kyy", "ypaat", "emy",
                                                   "deh"),
                               translit = TRUE){
  api <- "political_division"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_variables
get_variables <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                   translit = TRUE){
  api <- "variable"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_units_of_measurement
get_units_of_measurement <- function(subdomain =  c("kyy", "ypaat", "emy",
                                                    "deh"),
                         translit = TRUE){
  api <- "unit_of_measurement"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_time_steps
get_time_steps <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                     translit = TRUE){
  api <- "time_step"
  get_and_translit(subdomain, api, translit)
}


#' @rdname get_functions
#' @export get_owners
get_owners <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "owner"
  get_and_translit(subdomain, api, translit)
}


#' @rdname get_functions
#' @export get_owners
get_instruments_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                       translit = TRUE){
  api <- "intr_type"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @export get_station_type
get_station_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                 translit = TRUE){
  api <- "station_type"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
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
       "units" = get_units_of_measurement(subdomain, translit),
       "time_steps" = get_time_steps(subdomain, translit),
       "owners" = get_owners(subdomain, translit),
       "instr_type" = get_instruments_type(subdomain, translit),
       "stations_type" = get_station_type(subdomain, translit))
}
