#' Find stations using coordinates
#'
#' @param longitude
#' @param latitude
#'
#' @return
#' @export find_stations
#'
#' @examples
#'
#' # find the five nearest stations to a point near Raphena in Athens,
#' # (lon, lat) = (24, 38)
#' head(find_stations(24, 38), 5)
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
  dist <- haversine(lat1 = latitude, lon1 = longitude,
                    lat2 = stations$latitude, lon2 = stations$longitude)

  # create a tibble with results
  stat_dist <- tibble::tibble(station_id = stations$station_id,
                              name = stations$name,
                              subdomain = stations$subdomain,
                              distance = dist)

  # return ordered resuts based on distance
  stat_dist[order(stat_dist$distance, decreasing = FALSE),]

}
