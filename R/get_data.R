
#' Get stations data
#'
#' \code{get_stations} returns a dataframe with data from the stations that
#' exist in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of Hydroscope.
#' @param translit Automatically transliterate Greek to Latin.
#'
#' @return If \code{subdomain} is one of:
#' \itemize{
#' \item{\code{kyy}, Ministry of Environment and Energy}
#' \item{\code{ypaat}, Ministry of Rural Development and Food}
#' \item{\code{deh}, Greek Public Power Corporation}
#' \item{\code{emy}, National Meteorological Service}
#' }
#' returns a tidy dataframe with stations' data from the corresponding database
#' of Hydroscope. Otherwise gives an error message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{station_id}{The station's ID from the domain's database}
#'     \item{last_modified}{The date that the station's data were last modified}
#'     \item{name}{The station's name}
#'     \item{water_basin}{The station's Water Basin}
#'     \item{water_division}{The station's Water Division ID}
#'     \item{political_division}{The station's Political Division}
#'     \item{altitude}{The station's owner}
#'     \item{Type}{The station's type}
#'
#' }
#'
#' @note
#' Stations' IDs might not be unique at the different databases records from the
#' different Hydroscope domains.
#'
#' @examples
#'
#' # get stations' data from the Hydroscope's databases
#' kyy_stations <- get_stations(subdomain = "kyy")
#' ypaat_stations <- get_stations(subdomain = "ypaat")
#' emy_stations <- get_stations(subdomain = "emy")
#' deh_stations <- get_stations(subdomain = "deh")
#'
#' \dontrun{
#' stations <- get_stations(subdomain = "none")
#' }
#'
#' @references
#'
#' Stations' data are retrieved from the Hydroscope's databases:
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
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import jsonlite
#' @export get_stations
get_stations <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                         translit = TRUE) {

  # match subdomain values
  subdomain <- match.arg(subdomain)

  # create url
  h_url <- hydroscope_url(subdomain)
  h_url <- paste0(h_url, "/api/Gpoint/?format=json")

  # try to get data
  result <- tryCatch({
    enhy_get_df(h_url)
  },
  error = function(e) {
    stop(paste0("Failed to parse url: ", h_url), call. = FALSE)
  })

  # create lat and long from points
  coords <- create_coords(result$point)

  # columns to keep TODO: test col_names %in% parsed names
  col_names <- c("id", "last_modified", "name", "water_basin",
                 "water_division", "political_division", "altitude")
  result <- result[col_names]
  names(result)[1] <- "station_id"

  # add coords
  result <- cbind(result, coords)

  # transliterate names
  if(translit) {
    result$name <- greek2latin(result$name)
  }

  return(result)
}

#' Get time series data
#'
#' \code{get_stations} returns a dataframe with data from the stations that
#' exist in a database of Hydroscope.
#'
#' @inheritParams get_stations
#'
#' @return If \code{subdomain} is one of:
#' \itemize{
#' \item{\code{kyy}, Ministry of Environment and Energy}
#' \item{\code{ypaat}, Ministry of Rural Development and Food}
#' \item{\code{deh}, Greek Public Power Corporation}
#' \item{\code{emy}, National Meteorological Service}
#' }
#' returns a tidy dataframe with stations' data from the corresponding database
#' of Hydroscope. Otherwise gives an error message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{station_id}{The station's ID from the domain's database}
#'     \item{last_modified}{The date that the station's data were last modified}
#'     \item{name}{The station's name}
#'     \item{water_basin}{The station's Water Basin}
#'     \item{water_division}{The station's Water Division ID}
#'     \item{political_division}{The station's Political Division}
#'     \item{altitude}{The station's owner}
#'     \item{Type}{The station's type}
#'
#' }
#'
#' @note
#' Stations' IDs might not be unique at the different databases records from the
#' different Hydroscope domains.
#'
#' @examples
#'
#' # get time series' data from the Hydroscope's databases
#' kyy_ts <- get_timeseries(subdomain = "kyy")
#' ypaat_ts <- get_timeseries(subdomain = "ypaat")
#' emy_ts <- get_timeseries(subdomain = "emy")
#' deh_ts <- get_timeseries(subdomain = "deh")
#'
#' \dontrun{
#' ts <- get_timeseries(subdomain = "none")
#' }
#'
#' @references
#'
#' Stations' data are retrieved from the Hydroscope's databases:
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
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import jsonlite
#' @export get_timeseries
get_timeseries <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  # match subdomain values
  subdomain <- match.arg(subdomain)

  # create url
  h_url <- hydroscope_url(subdomain)
  h_url <- paste0(h_url, "/api/Timeseries/?format=json")

  # try to get data
  result <- tryCatch({
    enhy_get_df(h_url)
  },
  error = function(e) {
    warning(paste0("Failed to parse url: ", h_url), call. = FALSE)
    return(stationsNA(stationID))
  })

  #
  # # columns to keep
  # col_names <- c("id", "last_modified", "name", "water_basin",
  #                "water_division", "political_division", "altitude")
  # result <- result[col_names]
  # names(result)[1] <- "station_id"
  #
  # # add coords
  # result <- cbind(result, coords)
  #
  # # transliterate names
  # if(translit) {
  #   result$name <- greek2latin(result$name)
  # }

  return(result)
}

#' Get time series values in a tidy dataframe
#'
#' \code{get_data} returns a tidy dataframe with the available data from
#' a time series in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param time_id A time series ID
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy) or \code{"ypaat"} (Ministry of Rural Development and Food),
#' and timeID is not NULL, returns a tidy dataframe with the time series values
#' from the corresponding database of hydroscope.gr. Otherwise gives an error
#' message.
#'
#' If the time series ID does not exist in the database, or the url from
#' Hydroscope could not parsed, returns a dataframe with NA values.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{Date}{The time series Dates (POSIXct)}
#'     \item{Value}{The time series values (numeric)}
#'     \item{Comment}{Comments about the values (character)}
#' }
#'
#' @note
#' The subdomains \code{"deh"} (Greek Public Power Corporation) and \code{"emy"}
#' (National Meteorological Service) are not used, because the data are not
#' freely available.
#'
#' The subdomain "main", which also is not used, is a data
#' aggregator from several databases. It uses different IDs for stations and
#' time series.
#'
#' @examples
#' # get time series 912 from the Greek Ministry of Environment and Energy
#' df <-get_data("kyy", 912)
#'
#' \dontrun{
#' get_data("ypaat")
#' }
#'
#' @references
#' Stations' data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#'}
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import readr
#' @export get_data
get_data <- function(subdomain =  c("kyy", "ypaat"), time_id) {

  # check that stationID is given
  if (is.null(time_id)) stop("argument \"time_id\" is missing")

  # match subdomain values
  subdomain <- match.arg(subdomain)
  h_url <- hydroscope_url(subdomain)
  h_url <- paste0(h_url, "/api/tsdata/", time_id, "/")

  # get hydroscope file to dataframe

  tryCatch({
    enhy_get_txt(h_url)
  },
  error = function(e) {
    # return NA values
    warning(paste("Couldn't get time series' data from ", h_url), call. = FALSE)
    dataNA()
  })

}
