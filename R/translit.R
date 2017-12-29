# Translations and transliterations --------------------------------------------

# convert greek to latin-ascii
greek2latin <- function(x) {
  sapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    str <- stringi::stri_trans_general(str, "latin-ascii")
    str
  })
}

# translitarate all the columns of a dataframe
trasnlit_all <- function(result) {
  for (cnames in names(result)) {
    result[cnames] <- greek2latin(result[cnames])
  }
  result
}
