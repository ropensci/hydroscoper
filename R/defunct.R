#' Defunct functions in hydroscoper
#'
#' These functions are no longer available in \pkg{hydroscoper}.
#'
#' @param ... Defunct function's parameters
#'
#' \itemize{
#'  \item \code{\link{get_coords}}: This function is defunct. Please use
#'  \code{\link{hydro_coords}} to convert Hydroscope's points raw format to a
#'  tidy data frame.
#' }
#'
#' @name hydroscoper_defunct
NULL

#' @rdname hydroscoper_defunct
#' @export get_coords
get_coords <- function(...) {
  .Defunct(msg = "'get_coords' has been removed from this package")
}
