# Translations and transliterations --------------------------------------------

# convert greek to latin-ascii
greek2latin <- function(x) {
  sapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    str <- stringi::stri_trans_general(str, "latin-ascii")
    str
  })
}

# translitarate all the columns of a dataframe from Greek to ASCII latin
trasnlit_all <- function(result) {
  for (cnames in names(result)) {
    result[cnames] <- greek2latin(result[cnames])
  }
  result
}

# tranlate owners to englisn
map_owners <- function(x) {
x <- stringr::str_replace_all(" ", "", x)
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
          x)
}

# translate variables to english
map_variables <- function(y){
  y <- stringr::str_to_lower(y)
  df <- data.frame(
  from = c(" -","-", " ", "[()]","agnosto", "anemos", "dieuthynse", "parelthon",
            "tachyteta", "mese", "brochoptose", "diarkeia", "exatmise",
            "exatmisodiapnoe", "thermokrasia", "edaphous", "bathos",
            "elachiste", "megiste","piese", "semeiake", "chioni",
            "ypsometro", "stathme", "plemmyra", "paroche", "broche",
           "katastase", "ektimemene", "athroistiko", "stereo","ygrasia",
           "ygro", "apolyte", "schetike", "asbestio", "wetu",
           "chionobrochometro", "xero", "ydrometrese", "thalasses",
           "semeio_drosou", "oratoteta", "steria", "thalassa", "barometro",
           "tase_ydratmon", "psychrometro", "isodynamo_ypsos", "agogimoteta",
           "aktinobolia", "anthraka", "dioxeidio", "ypoloipo"),

  to   = c("","_", "_", "", "unknown", "wind", "direc", "past", "speed",
             "average", "precipitation", "duration", "evaporation",
             "evapotranspiration","temperature", "ground", "depth",
             "min", "max", "pressure", "point", "snow", "elevation",
             "level", "flood", "flow", "precipitation", "condition", "estim",
            "cumulative", "sediment", "humidity", "wet", "absol","relat", "calcium",
            "precipitation", "snow_rain_gauge", "dry", "flow_gauge", "sea",
            "dew_point", "visibility", "land", "sea", "barometer",
            "vapour_pressure", "psychrometer", "water_equivalent",
            "conductance", "radiation", "carbon", "dioxide", "residual"),
  stringsAsFactors = FALSE)

  for (i in 1:nrow(df)) {
    y <- stringr::str_replace_all(y, df$from[i], df$to[i])
  }
  y
  }
