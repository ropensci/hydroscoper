# create lat. and lon. from point stings


#' Create coordinates from Hydroscope's points
#'
#' \code{get_coords} returns a data frame with the stations' longitudes and
#' latitudes using as input the variable \code{point} from \code{get_stations}
#'  function.
#'
#' @param x a string vector with the points retrieved from Hydroscope
#'
#' @return a data frame with the longitude and latitude values. If the
#' coordinates of
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import stringr
#' @export get_coords
#'
#' @examples
#' \dontrun{
#' # get stations from the Greek Ministry of Environment and Energy
#' kyy_stations <-get_stations("kyy")
#' # create a dataframe with the coords of the stations
#' coords <- get_coords(kyy_stations$point)
#' }
get_coords <- function(x) {
  do.call(rbind, lapply(x, create_coords))
}



#' Translate Greek names and terms to English
#'
#' \code{hydro_translate} Greeek to English transaltions of names and terms
#'
#' @param x a string vector
#' @param value One of the predefined values in
#' \code{c("owner", "variable", "timestep", "division")}
#'
#' @return If \code{value} is one of:
  #' \itemize{
  #' \item{\code{owner}, translate organisations' names}
  #' \item{\code{variable}, translate hydrometeorological term}
  #' }
  #' returns a character vector with translations of various hydrometeorological
  #' terms or organisations' names
#' @export hydro_translate
#'
#' @examples
#' \dontrun{
#'
#' # get data from the Ministry of Environment and Energy
#' kyy_owners <- get_owners("kyy")
#' kyy_vars <- get_variables("kyy")
#' owners_names <- hydro_translate(kyy_owners$name, "owner")
#' vars <- hydro_translate(kyy_vars$descr, "variable")
#' }
hydro_translate <- function(x,
                            value = c("owner", "variable", "timestep",
                                      "division")) {

  # match translate values
  value <- match.arg(value)

  # select one of alternatives translations
  switch (value,
          owner = map_owners(x),
          variable = map_variables(x),
          timestep = map_ts(x),
          division = map_wd(x))

}
