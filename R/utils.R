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
