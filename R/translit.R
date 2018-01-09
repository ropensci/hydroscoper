# Transliterations -------------------------------------------------------------

# translitarate all the columns of a dataframe from Greek to latin-ascii
trasnlit_all <- function(df) {

  df[] <- lapply(df, function(x){
    y <- stringi::stri_trans_general(x, "Latin")
    stringi::stri_trans_general(y, "latin-ascii")
  })
  return(df)
}

# Translations -----------------------------------------------------------------

# translate vector y using dataframe map df
translate_str <- function(y, df){
  for (i in seq(1, nrow(df))) {
    y <- stringr::str_replace_all(y, df$from[i], df$to[i])
  }
  y
}

# tranlate owners
map_owners <- function(y) {

y <- stringr::str_replace_all(y, " ", "")

df <- data.frame(
  from = c(
    "DEMOSIAEPICHEIRISEELEKTRISMOU", "ETHNIKEMETEOROLOGIKEYPERESIA",
    "ETHNIKOASTEROSKOPEIOATHENAS", "ETHNIKOIDRYMAAGROTIKESEREUNAS",
    "MOUSEIOPHYSIKESISTORIASKRETES", "NOMARCHIAKEAUTODIOIKESE",
    "POLYTECHNEIOKRETES", "YPOURGEIOAGROTIKESANAPTYXESKAITROPHIMON",
    "YPOURGEIOPERIBALLONTOS,ENERGEIASKAIKLIMATIKESALLAGES"
  ),

  to = c(
    "public_power_corp", "natio_meteo_service", "natio_observ_athens",
    "natio_argic_resear", "crete_natural_museum", "greek_prefectures",
    "crete_eng_faculty", "min_agricult", "min_envir_energy"
  ),
  stringsAsFactors = FALSE)

translate_str(y, df)

}

# translate variables
map_variables <- function(y){
  y <- stringr::str_to_lower(y)
  df <- data.frame(
    from = c(
      " -", "-", " ", "[()]", "agnosto", "anemos", "dieuthynse",
      "parelthon", "tachyteta", "mese", "brochoptose", "diarkeia",
      "exatmise",
      "exatmisodiapnoe", "thermokrasia", "edaphous", "bathos",
      "elachiste", "megiste", "piese", "semeiake", "chioni",
      "ypsometro", "stathme", "plemmyra", "paroche", "broche",
      "katastase", "ektimemene", "athroistiko", "stereo", "ygrasia",
      "ygro", "apolyte", "schetike", "asbestio", "wetu",
      "chionobrochometro", "xero", "ydrometrese", "thalasses",
      "semeio_drosou", "oratoteta", "steria", "thalassa", "barometro",
      "tase_ydratmon", "psychrometro", "isodynamo_ypsos", "agogimoteta",
      "aktinobolia", "anthraka", "dioxeidio", "ypoloipo", "argilio",
      "argilos", "arseniko", "pyritiou", "aera", "nephokalypse", "nephose",
      "axiosemeiota", "nephe", "kairos", "diafora", "atmosfairiki", "stathera",
      "parousa", "parelthousa", "kalymeno", "el.", "meg.", "skleroteta",
      "eliophaneia", "eisroe_se_tamieuteres"
    ),

    to   = c(
      "", "_", "_", "", "unknown", "wind", "direction", "past", "speed",
      "average", "precipitation", "duration", "evaporation",
      "evapotranspiration", "temperature", "ground", "depth",
      "min", "max", "pressure", "point", "snow", "elevation",
      "level", "flood", "flow", "precipitation", "condition", "estimation",
      "cumulative", "sediment", "humidity", "wet", "absolute", "relative",
      "calcium", "precipitation", "snow_rain_gauge", "dry", "flow_gauge", "sea",
      "dew_point", "visibility", "land", "sea", "barometer",
      "vapour_pressure", "psychrometer", "water_equivalent",
      "conductance", "radiation", "carbon", "dioxide", "residual",
      "aluminum", "clay", "arsenic", "silicon", "air", "cloud_cover", "clouds",
      "remarkably", "clouds", "weather", "difference", "atmospheric",
      "constant", "present", "past", "cover", "min", "max", "hardness",
      "sunshine", "inflow_reservoir"
    ),
  stringsAsFactors = FALSE)

  translate_str(y, df)
}

# translate time steps
map_ts <- function(y){
  y <- stringr::str_to_lower(y)

  df <- data.frame(
    from = c("lepte", "emeresia", "meniaia", "etesia", "oriaia"),
    to   = c("_minutes", "daily", "monthly", "annual", "hourly"),
    stringsAsFactors = FALSE)

  translate_str(y, df)

}

# translate water division
map_wd <- function(y){
  y <- stringr::str_replace_all(y, " ", "")

  df <- data.frame(
    from = c(
      "DYTIKEPELOPONNESOS", "BOREIAPELOPONNESOS", "ANATOLIKEPELOPONNES",
      "DYTIKESTEREAELLADA", "EPEIROS", "ATTIKE", "ANATOLIKESTEREAELL",
      "THESSALIA", "DYTIKEMAKEDONIA", "KENTRIKEMAKEDONIA", "ANATOLIKEMAKEDONIA",
      "THRAKE", "KRETE", "NESOIAIGAIOU"),

    to = c("GR01", "GR02", "GR03", "GR04", "GR05", "GR06", "GR07", "GR08",
           "GR09", "GR10", "GR11", "GR12", "GR13", "GR14"),
    stringsAsFactors = FALSE)

  translate_str(y, df)

}
