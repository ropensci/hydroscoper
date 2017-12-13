#' Title
#'
#' @param x a vector  with unicode strings
#'
#' @return a vector of strings. The function transliterates characters from Greek to Latin
#' @export
#' @import
#'
#' @examples
greek2latin <- function(x) {
  lapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    stringi::stri_trans_general(str, "latin-ascii")
    })
}
