#' hydroscoper: Interface to Hydroscope
#'
#' R interface to the  Greek National Data Bank for Hydrological and
#' Meteorological Information http://www.hydroscope.gr/.
#'
#' \code{hydroscoper} covers Hydroscope's data sources using the
#' \href{http://bit.ly/2CLlAAA}{Enhydris API} and provides functions to:
#' \enumerate{
#'   \item {Transform the available tables and data sets into
#'        \href{http://bit.ly/2Dg1sHY}{tibbles}.}
#'   \item{Transliterate the Greek Unicode names to Latin.}
#'   \item{Translate various Greek terms to English.}
#' }
#'
#' @section Enhydris API:
#'
#' The Enhydris database is implemented in PostgreSQL. Details about the
#' database can be found \href{http://bit.ly/2D0cZgA}{here}  and about the
#' Web-service API \href{http://bit.ly/2FlRtBB}{here}.
#'
#' @section Data Sources:
#'
#' The data are retrieved from the Hydroscope's databases:
#' \itemize{
#'   \item \href{http://kyy.hydroscope.gr}{Ministry of Environment, Energy and
#'   Climate Change}.
#'   \item \href{http://ypaat.hydroscope.gr}{Ministry of Rural Development
#'   and Food}.
#'   \item \href{http://emy.hydroscope.gr}{National Meteorological Service}.
#'   \item  \href{http://deh.hydroscope.gr}{Greek Public Power Corporation}.
#'}
#'
#' @name hydroscoper
#' @aliases hydroscoper-package
#' @docType package
"_PACKAGE"
