#' Get data frames from Hydroscope
#'
#' \code{get_stations}, \code{get_timeseries}, \code{get_instruments},
#' is a family of functions that return a data frame from tables that
#' exist in a specific database of Hydroscope.
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
#' returns a tidy dataframe with data from the corresponding database
#' of Hydroscope. Otherwise returns an error message.
#'
#' @note
#' Objects' IDs are not unique among the different Hydroscope databases. For
#' example, time series' IDs from http://kyy.hydroscope.gr have same values
#' with time series' from http://ypaat.hydroscope.gr.
#'
#' The Greek Water Divisions are:
#' \tabular{ll}{
#' \strong{Code}  \tab \strong{Name} \cr
#' GR01 \tab DYTIKE PELOPONNESOS \cr
#' GR02 \tab BOREIA PELOPONNESOS \cr
#' GR03 \tab ANATOLIKE PELOPONNESOS \cr
#' GR04 \tab DYTIKE STEREA ELLADA \cr
#' GR05 \tab EPEIROS  \cr
#' GR06 \tab ATTIKE  \cr
#' GR07 \tab ANATOLIKE STEREA ELLADA \cr
#' GR08 \tab THESSALIA  \cr
#' GR09 \tab DYTIKE MAKEDONIA  \cr
#' GR10 \tab KENTRIKE MAKEDONIA  \cr
#' GR11 \tab ANATOLIKE MAKEDONIA  \cr
#' GR12 \tab THRAKE  \cr
#' GR13 \tab KRETE  \cr
#' GR14 \tab NESOI AIGAIOU  \cr
#' }
#'
#' @examples
#'
#' \dontrun{
#'
#' # get data from the Ministry of Environment and Energy
#' kyy_stations <- get_stations("kyy")
#' kyy_timser <- get_timeseries("kyy")
#' kyy_instr <- get_instruments("kyy")
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
#' European Terrestrial Reference System 1989 (ETRS),
#' \url{http://bit.ly/2kJwFuf}
#'
#' Greek Water Divisions,
#' \url{http://bit.ly/2kk0tOm}
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#'
#' @name get_functions
NULL
