
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
#' of Hydroscope. Otherwise returns an error message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{station_id}{The station's ID}
#'     \item{name}{The station's name}
#'     \item{last_modified}{The date that the station's data were last modified}
#'     \item{altitude}{The station's altitude, meters above sea level}
#'     \item{long}{The station's longitude, decimal degrees, ETRS89}
#'     \item{lat}{The station's latitude, decimal degrees, ETRS89}
#'     \item{water_division}{The station's Water Division}
#'     \item{water_basin}{The station's Water Basin}
#'     \item{political_division}{The station's Political Division}
#' }
#'
#' @note
#' Stations' IDs might not be unique at the different databases records from the
#' Hydroscope domains.
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
#' # get stations' data from the Hydroscope's databases
#' kyy_stations <- get_stations(subdomain = "kyy")
#' ypaat_stations <- get_stations(subdomain = "ypaat")
#' emy_stations <- get_stations(subdomain = "emy")
#' deh_stations <- get_stations(subdomain = "deh")
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
#'
#' European Terrestrial Reference System 1989 (ETRS),
#' \url{http://bit.ly/2kJwFuf}
#'
#' Greek Water Divisions,
#' \url{http://bit.ly/2kk0tOm}
#'
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
  s_url <- hydroscope_url(subdomain)
  h_url <- paste0(s_url, "/api/Gpoint/?format=json")

  # try to get data
  result <- tryCatch({
    enhy_get_df(h_url)
  },
  error = function(e) {
    stop(paste0("Failed to parse url: ", h_url), call. = FALSE)
  })

  # create lat and long from points
  coords <- create_coords(result$point)

  # get water_basin, water_division and political_division values
  water_basin <- get_names(s_url, "water_basin", result)
  water_division <- get_names(s_url, "water_division", result)
  political_division <- get_names(s_url, "political_division", result)

  # remove area from water basin values
  water_basin <- sapply(water_basin,
                        function(str) gsub("\\([^()]*\\)", "", str))

  # create dataframe with stations data
  keep_col <- c("id","name", "last_modified",  "altitude")
  result <- cbind(result[keep_col], coords,water_division, water_basin,
                  political_division)
  names(result)[1] <- "station_id"

  # transliterate names
  trans_col <- c("name", "water_basin", "water_division", "political_division")
  if(translit) {
    for (clm in trans_col) {
      result[clm] <- greek2latin(result[clm])
    }
  }

  return(result)
}
