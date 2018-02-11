
#' @title Get time series values in a tibble
#'
#' @description  \code{get_data} returns a tibble from  a Hydroscope's
#' time-series text file.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param time_id A time series ID
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy) or \code{"ypaat"} (Ministry of Rural Development and Food),
#' and timeID is not NULL, returns a tidy dataframe with the time series values
#' from the corresponding database of hydroscope.gr. Otherwise returns an error
#' message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{dates}{The time series Dates (POSIXct)}
#'     \item{values}{The time series values (numeric)}
#'     \item{comments}{Comments about the values (character)}
#' }
#'
#' @note Data are not available freely in the sub-domains:  \code{"deh"}
#' (Greek Public Power Corporation) and
#' \code{"emy"} (National Meteorological Service).
#'
#'
#' @examples
#' \dontrun{
#' # get time series 912 from the Greek Ministry of Environment and Energy
#' time_series <- get_data("kyy", 912)
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
#'
#' Tibble, \url{http://tibble.tidyverse.org/}

#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @export get_data
get_data <- function(subdomain = c("kyy", "ypaat", "emy", "deh"), time_id) {

  # check that stationID is not NULL
  if (is.null(time_id)) stop("Argument 'time_id' is missing.")

  enhydris_get(subdomain = subdomain, api_value = "time_data",
               time_id = time_id)
}
