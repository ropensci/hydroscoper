#' hydroscoper: Interface to Hydroscope
#'
#' R interface to the  Greek National Data Bank for Hydrological and
#' Meteorological Information http://www.hydroscope.gr/. It
#' covers Hydroscope's data sources and provides functions: a) to transliterate
#' and translate Greek terms to English and b) download time series' data into
#' tidy dataframes.
#'
#' @section Data Sources:
#'
#' The data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}.
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}.
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}.
#' \item{Greek Public Power Corporation},
#' \url{http://deh.hydroscope.gr}.
#'}
#'
#' @name hydroscoper
#' @docType package
#'
#' @import stringi
#' @import stringr
#' @import jsonlite
#' @import readr


"_PACKAGE"
