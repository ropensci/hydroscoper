
#' Get instruments data
#'
#' \code{get_instruments} returns a dataframe with data from the instruments
#' that exist in a database of Hydroscope.
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
#' returns a tidy dataframe with instruments' data from the corresponding
#' database of Hydroscope. Otherwise returns an error message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{id}{The instrument ID from the domain's database}
#'     \item{last_modified}{The date that the timeseries data were last
#'     modified}
#'
#'     \item{manufacturer}{The instrument's manufacturer}
#'     \item{model}{The instrument's model}
#'     \item{start_date}{The instrument's starting date}
#'     \item{end_date}{The instrument's ending date}
#'     \item{name}{The instrument's name}
#'     \item{remarks}{Remarks about the instrument}
#'     \item{name_alt}{The instrument's, maybe alternative, name}
#'     \item{remarks_alt}{Alternative remarks about the instrument}
#'     \item{station}{The instrument's station ID}
#'     \item{type}{The instrument's type}
#'
#' }
#'
#' @note
#' Instruments' IDs are not unique at the different databases records from
#' the Hydroscope domains.
#'
#' @examples
#' \dontrun{
#'
#' # get instruments' data from the Hydroscope's databases
#' kyy_ins <- get_instruments("kyy")
#' ypaat_ins <- get_instruments("ypaat")
#' emy_ins <- get_instruments("emy")
#' deh_ins <- get_instruments("deh")
#' }
#'
#' @references
#'
#' Instruments' data are retrieved from the Hydroscope's databases:
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
#' @export get_instruments
get_instruments <- function(subdomain =  c("kyy", "ypaat", "emy", "deh"),
                           translit = TRUE){
  # match subdomain values
  subdomain <- match.arg(subdomain)

  # create url
  h_url <- hydroscope_url(subdomain)
  s_url <- paste0(h_url, "/api/Instrument/?format=json")

  # try to get data
  result <- tryCatch({
    enhy_get_df(s_url)
  },
  error = function(e) {
    stop(paste0("Failed to parse url: ", h_url), call. = FALSE)
  })

  # transliterate names
  if(translit) {
    for (cname in names(result)) {
      result[cname] <- as.character(greek2latin(result[cname]))
    }
  }

  return(result)
}
