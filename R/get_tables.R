#' @rdname get_functions
#' @import jsonlite
#' @export get_stations
get_stations <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE) {

  api <- "stations"
  get_and_translit(subdomain, api, translit)

}

#' @rdname get_functions
#' @import jsonlite
#' @export get_timeseries
get_timeseries <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "timeseries"
  get_and_translit(subdomain, api, translit)

}

#' @rdname get_functions
#' @import jsonlite
#' @export get_instruments
get_instruments <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "instruments"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_water_basins
get_water_basins <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_basin"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_water_divisions
get_water_divisions <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                            translit = TRUE){
  api <- "water_division"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_political_divisions
get_political_divisions <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                               translit = TRUE){
  api <- "political_division"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_variables
get_variables <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                   translit = TRUE){
  api <- "variable"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_units_of_measurement
get_units_of_measurement <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE){
  api <- "unit_of_measurement"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_time_steps
get_time_steps <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                     translit = TRUE){
  api <- "time_step"
  get_and_translit(subdomain, api, translit)
}


#' @rdname get_functions
#' @import jsonlite
#' @export get_owners
get_owners <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  api <- "owner"
  get_and_translit(subdomain, api, translit)
}


#' @rdname get_functions
#' @import jsonlite
#' @export get_owners
get_instruments_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                       translit = TRUE){
  api <- "intr_type"
  get_and_translit(subdomain, api, translit)
}

#' @rdname get_functions
#' @import jsonlite
#' @export get_station_type
get_station_type <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                                 translit = TRUE){
  api <- "station_type"
  get_and_translit(subdomain, api, translit)
}
