
#' @title Get time series values in a tibble
#'
#' @description  \code{get_data} returns a tibble from  a Hydroscope's
#' time-series text file.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param time_id A time series ID
#' @param utc_offset Optional fixed source offset from UTC, in minutes.
#'   Positive values are east of UTC. If NULL, resolve it from the legacy
#'   Timeseries and TimeZone metadata. For example, 120 means UTC+02:00.
#'
#' @return If \code{subdomain} is one of:
#' \itemize{
#' \item{\code{kyy}, Ministry of Environment and Energy}
#' \item{\code{ypaat}, Ministry of Rural Development and Food}
#' \item{\code{deh}, Greek Public Power Corporation}
#' \item{\code{emy}, National Meteorological Service}
#' }
#' and \code{time_id} exists in that \code{subdomain}, returns a tibble with
#' the time series values. Otherwise returns an error message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{date}{The time series Dates (POSIXct, UTC)}
#'     \item{value}{The time series values (numeric)}
#'     \item{comment}{Comments about the values (character)}
#' }
#'
#' @details Legacy timestamps have no explicit offset. Dates are converted to
#'   UTC using the source's fixed offset. Missing metadata causes an error;
#'   UTC is never assumed silently.
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
#' Stations' data are retrieved from the Hydroscope's
#' databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change.
#' \item Ministry of Rural Development.
#' }
#'

#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @export get_data
get_data <- function(subdomain = "kyy", time_id, utc_offset = NULL) {
  if (missing(time_id) || is.null(time_id)) {
    stop("Argument 'time_id' is missing.", call. = FALSE)
  }
  enhydris_get(subdomain, "time_data", time_id = time_id, utc_offset = utc_offset)
}
