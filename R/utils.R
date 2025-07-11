#' Create host name address using a subdomain
#' @noRd
server_address <- function(subdomain) {
  paste0(subdomain, ".hydroscope.gr")
}

#' Check if a remote server is alive
#' @noRd
server_alive <- function(subdomain) {
  # test the http capabilities of the current R build
  if (!capabilities(what = "http/ftp")) {
    stop("The current R build has no http capabilities")
  }

  url <- server_address(subdomain)
  # test connection by trying to read first line of url
  test <- try(suppressWarnings(readLines(url, n = 1)), silent = TRUE)

  # return FALSE if test inherits 'try-error' class
  if (inherits(test, "try-error")) {
    err_msg <- paste(
      "The server for that data source is probably down,",
      "get more info at hydroscope@hydroscope.gr or try",
      "again later."
    )
    stop(err_msg)
  }
}

#' create coords from points
#' @noRd
create_coords <- function(str) {
  str_split <- stringr::str_split(
    string = str, pattern = "[\\(  \\)]",
    simplify = TRUE
  )
  if (NCOL(str_split) == 5) {
    tibble::tibble(
      long = as.numeric(str_split[, 3]),
      lat = as.numeric(str_split[, 4])
    )
  } else {
    tibble::tibble(
      long = rep(NA, NROW(str)),
      lat = rep(NA, NROW(str))
    )
  }
}

#' convert degrees to radians
#' @noRd
deg_to_rads <- function(degrees) {
  degrees * pi / 180
}

#' Distance calculation: Haversine formula
#' Presuming a spherical Earth with radius R  and that the locations of the two
#' points in spherical coordinates (longitude and latitude) are lon1, lat1 and
#' lon2,lat2, then the Haversine Formula is:
#' @noRd
haversine <- function(lat1, lon1, lat2, lon2) {
  lat1 <- deg_to_rads(lat1)
  lat2 <- deg_to_rads(lat2)
  lon1 <- deg_to_rads(lon1)
  lon2 <- deg_to_rads(lon2)

  # Differences in latitude and longitude
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1

  # radius of earth in km
  r_earh <- 6373

  # compute distance
  a <- (sin(dlat / 2))^2 + cos(lat1) * cos(lat2) * (sin(dlon / 2))^2
  r_earh * 2 * atan2(sqrt(a), sqrt(1 - a))
}
