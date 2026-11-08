
#' @title Convert coordinates from Hydroscope's points to a tibble
#'
#' @description \code{hydro_coords} returns a tibble with the stations'
#' longitude and latitude using as input the variable \code{point}
#' from \code{get_stations} function.
#'
#' @param x a string vector with the points retrieved from Hydroscope
#'
#' @return a tibble with the longitude and latitude values.
#'
#' @details Accepts two-dimensional POINT strings with optional SRID=4326.
#'   Points without an SRID are assumed to use WGS84. No transformation is
#'   performed. Unsupported explicit SRIDs cause an error. Missing, malformed
#'   or out-of-range points return NA coordinates, retaining the input rows.
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @export hydro_coords
#'
#' @examples
#' \dontrun{
#' # get stations from the Greek Ministry of Environment and Energy
#' kyy_stations <- get_stations("kyy")
#'
#' # create a tibble with stations' coords
#' coords <- hydro_coords(kyy_stations$point)
#' }
hydro_coords <- function(x) {
  if (!is.character(x)) {
    stop("'x' must be a character vector of POINT geometries.", call. = FALSE)
  }
  number <- "[+-]?(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+)(?:[eE][+-]?[0-9]+)?"
  pattern <- paste0("(?i)^\\s*(?:SRID\\s*=\\s*([0-9]+)\\s*;\\s*)?",
                    "POINT\\s*\\(\\s*(", number, ")\\s+(", number, ")\\s*\\)\\s*$")
  matched <- stringr::str_match(x, pattern)
  unsupported <- !is.na(matched[, 2]) & matched[, 2] != "4326"
  if (any(unsupported)) {
    stop("Unsupported SRID at row(s): ", paste(which(unsupported), collapse = ", "),
         ". Transform explicitly to EPSG:4326 first.", call. = FALSE)
  }
  longitude <- as.numeric(matched[, 3])
  latitude <- as.numeric(matched[, 4])
  valid <- is.finite(longitude) & is.finite(latitude) &
    abs(longitude) <= 180 & abs(latitude) <= 90
  longitude[!valid] <- NA_real_
  latitude[!valid] <- NA_real_
  tibble::tibble(long = longitude, lat = latitude)
}

