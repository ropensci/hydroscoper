greek2latin <- function(x) {
  lapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    stringi::stri_trans_general(str, "latin-ascii")
    })
}
