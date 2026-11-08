
#' translitarate all the columns of a dataframe from Greek to latin-ASCII
#' @noRd
translit_all <- function(df) {
  columns <- intersect(
    names(df),
    c("name", "name_alt", "short_name",
      "short_name_alt", "descr", "descr_alt", "remarks", "remarks_alt",
      "acronym", "acronym_alt", "ordering_string"))
  columns <- columns[vapply(df[columns], is.character, logical(1))]
  df[columns] <- lapply(df[columns], function(x) {
    stringi::stri_trans_general(x, "Greek-Latin; Latin-ASCII")
  })
  df
}


#' translate vector y using dataframe map df
#' @noRd
translate_str <- function(y, df) {
  for (i in seq(1, nrow(df))) {
    y <- stringr::str_replace_all(y, df$from[i], df$to[i])
  }
  y
}

#' tranlate owners
#' @noRd
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
    stringsAsFactors = FALSE
  )

  translate_str(y, df)
}

#' translate variables
#' @noRd
map_variables <- function(y) {
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
      "parousa", "parelthousa", "kalymeno", "el\\.", "meg\\.", "skleroteta",
      "eliophaneia", "eisroe_se_tamieuteres"
    ),

    to = c(
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
    stringsAsFactors = FALSE
  )

  translate_str(y, df)
}

#' translate time steps
#' @noRd
map_ts <- function(y) {
  y <- stringr::str_to_lower(y)

  df <- data.frame(
    from = c("lepte", "emeresia", "meniaia", "etesia", "oriaia"),
    to = c("_minutes", "daily", "monthly", "annual", "hourly"),
    stringsAsFactors = FALSE
  )

  translate_str(y, df)
}

#' translate water division
#' @noRd
map_wd <- function(y) {
  if (!is.character(y)) stop("'y' must be a character vector.", call. = FALSE)
  keys <- stringr::str_to_upper(stringr::str_remove_all(y, "\\s+"))
  dictionary <- c(
    DYTIKEPELOPONNESOS = "GR01", BOREIAPELOPONNESOS = "GR02",
    ANATOLIKEPELOPONNES = "GR03", ANATOLIKEPELOPONNESOS = "GR03",
    DYTIKESTEREAELLADA = "GR04", EPEIROS = "GR05", ATTIKE = "GR06",
    ANATOLIKESTEREAELL = "GR07", ANATOLIKESTEREAELLADA = "GR07",
    THESSALIA = "GR08", DYTIKEMAKEDONIA = "GR09", KENTRIKEMAKEDONIA = "GR10",
    ANATOLIKEMAKEDONIA = "GR11", THRAKE = "GR12", KRETE = "GR13",
    NESOIAIGAIOU = "GR14")
  translated <- unname(dictionary[keys])
  found <- !is.na(translated)
  y[found] <- translated[found]
  y
}

