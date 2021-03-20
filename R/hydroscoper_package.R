#' @title hydroscoper: Interface to Hydroscope
#'
#' @description \code{hydroscoper} provides an R interface to the  Greek
#' National Data Bank for Hydrological and Meteorological Information
#' \code{http://www.hydroscope.gr}.
#'
#' \code{hydroscoper} covers Hydroscope's data sources using the
#' \code{Enhydris API} and provides functions to:
#' \enumerate{
#'   \item {Transform the available tables and data sets into
#'        \href{https://tibble.tidyverse.org/}{tibbles}.}
#'   \item{Transliterate the Greek Unicode names to Latin.}
#'   \item{Translate various Greek terms to English.}
#' }
#'
#' @section Enhydris API:
#'
#' The Enhydris database is implemented in PostgreSQL. Details
#' can be found \href{https://enhydris.readthedocs.io}{here}
#'
#' @section Data Sources:
#'
#' The data are retrieved from the Hydroscope's databases:
#' \itemize{
#'   \item Ministry of Environment, Energy and Climate Change.
#'   \item Ministry of Rural Development and Food.
#'   \item  National Meteorological Service.
#'   \item  Greek Public Power Corporation.
#' }
#'
#' @name hydroscoper
#' @aliases hydroscoper-package
#' @docType package
"_PACKAGE"
