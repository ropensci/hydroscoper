
#' Get time series data
#'
#' \code{get_timeseries} returns a dataframe with data from the time series that
#' exist in a database of Hydroscope.
#'
#' @inheritParams get_stations
#' @param translate Automatically translates Greek terms to Latin.
#'
#' @return If \code{subdomain} is one of:
#' \itemize{
#' \item{\code{kyy}, Ministry of Environment and Energy}
#' \item{\code{ypaat}, Ministry of Rural Development and Food}
#' \item{\code{deh}, Greek Public Power Corporation}
#' \item{\code{emy}, National Meteorological Service}
#' }
#' returns a tidy dataframe with time series' data from the corresponding
#' database of Hydroscope. Otherwise returns an error message.
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
#' Time series' IDs are not unique at the different databases records from
#' the Hydroscope domains.
#'
#' @examples
#' \dontrun{
#'
#' # get time series' data from the Hydroscope's databases
#' kyy_ts <- get_timeseries("kyy")
#' ypaat_ts <- get_timeseries("ypaat")
#' emy_ts <- get_timeseries("emy")
#' deh_ts <- get_timeseries("deh")
#' }
#'
#' @references
#'
#' Time series' data are retrieved from the Hydroscope's databases:
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
                           translit = TRUE,
                           translate = TRUE){
  # match subdomain values
  subdomain <- match.arg(subdomain)

  # create url
  h_url <- hydroscope_url(subdomain)
  s_url <- paste0(h_url, "/api/Timeseries/?format=json")

  # try to get data
  result <- tryCatch({
    enhy_get_df(s_url)
  },
  error = function(e) {
    stop(paste0("Failed to parse url: ", h_url), call. = FALSE)
  })

  return(result)
}
