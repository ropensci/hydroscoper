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


owners_map <- function(x) {

switch (x,
        "DEMOSIAEPICHEIRISEELEKTRISMOU" = "public_power_corp",
        "ETHNIKEMETEOROLOGIKEYPERESIA"  = "natio_meteo_service",
        "ETHNIKOASTEROSKOPEIOATHENAS"   = "natio_observ_athens",
        "ETHNIKOIDRYMAAGROTIKESEREUNAS" = "natio_argic_resear",
        "MOUSEIOPHYSIKESISTORIASKRETES" = "crete_natural_museum",
        "NOMARCHIAKEAUTODIOIKESE"       = "greek_perfectures"  ,
        "POLYTECHNEIOKRETES"            = "crete_eng_faculty",
        "YPOURGEIOAGROTIKESANAPTYXESKAITROPHIMON" = "min_agricult",
        "YPOURGEIOPERIBALLONTOS,ENERGEIASKAIKLIMATIKESALLAGES" = "min_envir",
        x
)


}

