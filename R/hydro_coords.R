
#' Convert coordinates from Hydroscope's points
#'
#' \code{hydro_coords} returns a data frame with the stations' longitudes and
#' latitudes using as input the variable \code{point} from \code{get_stations}
#'  function.
#'
#' @param x a string vector with the points retrieved from Hydroscope
#'
#' @return a data frame with the longitude and latitude values. If the
#' coordinates of
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @export hydro_coords
#'
#' @examples
#' \dontrun{
#' # get stations from the Greek Ministry of Environment and Energy
#' kyy_stations <-get_stations("kyy")
#' # create a dataframe with the coords of the stations
#' coords <- get_coords(kyy_stations$point)
#' }
hydro_coords <- function(x) {
  do.call(rbind, lapply(x, create_coords))
}

