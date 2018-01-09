
#' Get time series values in a tibble
#'
#' \code{get_data} returns a tibble with the available data from
#' a time series in a database of Hydroscope.
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
#' @examples
#' \dontrun{
#' # get time series 912 from the Greek Ministry of Environment and Energy
#' df <-get_data("kyy", 912)
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
get_data <- function(subdomain =  c("kyy", "ypaat"), time_id) {

  # check that stationID is given
  if (is.null(time_id)) stop("argument \"time_id\" is missing")

  # match subdomain values
  subdomain <- match.arg(subdomain)
  h_url <- hydroscope_url(subdomain)
  t_url <- paste0(h_url, "/api/tsdata/", time_id, "/")

  # get hydroscope file to dataframe

  tryCatch({
    enhy_get_txt(t_url)
  },
  error = function(e) {
    # return NA values
    stop(paste0("Couldn't get time series' data from ", t_url), call. = FALSE)
  })

}
