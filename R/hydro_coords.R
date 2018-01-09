
#' Convert coordinates from Hydroscope's points to a tibble
#'
#' \code{hydro_coords} returns a tibble with the stations' longitudes and
#' latitudes using as input the variable \code{point} from \code{get_stations}
#'  function.
#'
#' @param x a string vector with the points retrieved from Hydroscope
#'
#' @return a tibble with the longitude and latitude values.
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @export hydro_coords
#'
#' @examples
#' \dontrun{
#' # get stations from the Greek Ministry of Environment and Energy
#' kyy_stations <-get_stations("kyy")
#'
#' # create a dataframe with the coords of the stations
#' coords <- hydro_coords(kyy_stations$point)
#' }
hydro_coords <- function(x) {
  coords <- plyr::ldply(x, create_coords)
  tibble::as.tibble(coords)
}
