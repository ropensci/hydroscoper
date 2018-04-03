#' Find nearest stations using a point's coordinates
#'
#' @description \code{find_stations} returns a tibble with the stations'
#' distances using a given point's longitude and latitude values. This function
#' uses the Haversine formula for distance calculation in km.
#'
#' @param longitude a numeric value in degrees
#' @param latitude  a numeric value in degrees
#'
#' @return If the given longitude is in [24, 38] and the latitude is in [34, 42]
#' (i.e. are valid values for Greece) returns are ordered tibble with the
#' station_id, name, subdomain and distance values in km. The station's data
#' that are used  come from the `stations` dataset. Otherwise returns an error
#' message.
#'
#' @export find_stations
#'
#' @examples
#'
#' # find the five nearest stations to a point near Thessaloniki,
#' # (lon, lat) = (22.97, 40.60)
#' head(find_stations(22.97, 40.60), 5)
#'
find_stations <- function(longitude = 24, latitude = 38) {

  lon_lim <- c(19, 30)
  lat_lim <- c(34, 42)

  if(longitude < lon_lim[1] | longitude > lon_lim[2] |
     latitude < lat_lim[1] | latitude > lat_lim[2]) {
    err_msg <- paste("Valid longitude values for Greece are in [19, 30]",
                      "and latitude values in [34, 42].")
    stop(err_msg , call. = FALSE) #nolint
  }

  # compute haversine distance
  dist <- haversine(lat1 = latitude,
                    lon1 = longitude,
                    lat2 = hydroscoper::stations$latitude,
                    lon2 = hydroscoper::stations$longitude)

  # create a tibble with results
  stat_dist <- tibble::tibble(station_id = hydroscoper::stations$station_id,
                              name = hydroscoper::stations$name,
                              subdomain = hydroscoper::stations$subdomain,
                              distance = dist)

  # return ordered resuts based on distance
  stat_dist[order(stat_dist$distance, decreasing = FALSE),]

}
