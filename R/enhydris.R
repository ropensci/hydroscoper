# Enhydris API -----------------------------------------------------------------

# Examples
# PoliticalDivision	"http://kyy.hydroscope.gr/api/PoliticalDivision/?format=json"
# GentityAltCodeType	"http://kyy.hydroscope.gr/api/GentityAltCodeType/?format=json"
# Timeseries	"http://kyy.hydroscope.gr/api/Timeseries/?format=json"
# Person	"http://kyy.hydroscope.gr/api/Person/?format=json"
# TimeStep	"http://kyy.hydroscope.gr/api/TimeStep/?format=json"
# WaterDivision	"http://kyy.hydroscope.gr/api/WaterDivision/?format=json"
# Gpoint	"http://kyy.hydroscope.gr/api/Gpoint/?format=json"
# Overseer	"http://kyy.hydroscope.gr/api/Overseer/?format=json"
# TimeZone	"http://kyy.hydroscope.gr/api/TimeZone/?format=json"
# GentityEvent	"http://kyy.hydroscope.gr/api/GentityEvent/?format=json"
# Organization	"http://kyy.hydroscope.gr/api/Organization/?format=json"
# GentityAltCode	"http://kyy.hydroscope.gr/api/GentityAltCode/?format=json"
# IntervalType	"http://kyy.hydroscope.gr/api/IntervalType/?format=json"
# WaterBasin	"http://kyy.hydroscope.gr/api/WaterBasin/?format=json"
# GentityFile	"http://kyy.hydroscope.gr/api/GentityFile/?format=json"
# StationType	"http://kyy.hydroscope.gr/api/StationType/?format=json"
# Gentity	"http://kyy.hydroscope.gr/api/Gentity/?format=json"
# Gline	"http://kyy.hydroscope.gr/api/Gline/?format=json"
# FileType	"http://kyy.hydroscope.gr/api/FileType/?format=json"
# EventType	"http://kyy.hydroscope.gr/api/EventType/?format=json"
# Variable	"http://kyy.hydroscope.gr/api/Variable/?format=json"
# Instrument	"http://kyy.hydroscope.gr/api/Instrument/?format=json"
# Lentity	"http://kyy.hydroscope.gr/api/Lentity/?format=json"
# InstrumentType	"http://kyy.hydroscope.gr/api/InstrumentType/?format=json"
# UnitOfMeasurement	"http://kyy.hydroscope.gr/api/UnitOfMeasurement/?format=json"
# Garea	"http://kyy.hydroscope.gr/api/Garea/?format=json"
# Station	"http://kyy.hydroscope.gr/api/Station/?format=json"

# Single Station "http://kyy.hydroscope.gr/api/Station/200171/?format=json"
# Single timeseries "http://kyy.hydroscope.gr/api/Timeseries/259/?format=json"
# raw data "http://kyy.hydroscope.gr/api/tsdata/259/


# create url
hydroscope_url <- function(domain) {
  return(paste0("http://", domain, ".hydroscope.gr"))
}

# use Enhydris API to get json data
enhy_get_df <- function(h_url) {
  jsonlite::fromJSON(h_url, flatten=TRUE)
}

# use Enhydris API to get plain text data
enhy_get_txt <- function(h_url) {

  # read timeseries data
  tmFormat <- "%Y-%m-%d %H:%M"

  # use readr to get values
  readr::read_csv(url(h_url),
                  col_names = c("Date", "Value", "Comment"),
                  col_types = list(
                    readr::col_datetime(format = tmFormat),
                    readr::col_double(),
                    readr::col_character()))
}

# create lat. and lon. from point sting
create_coords <- function(str) {
  str_split <- stringr::str_split(string = str, pattern = "[\\(  \\)]",
                                  simplify = TRUE)

  if(NCOL(str_split) == 5) {
    data.frame(long = as.numeric(str_split[, 3]),
               lat = as.numeric(str_split[, 4]))
  } else {
    data.frame(long = rep(NA, NROW(str)),
               lat = rep(NA, NROW(str)))
  }
}

# create water_basin, water_division, political_division values, variable
# unit_of_measurement and time_step strings
get_names <- function(h_url,
                      val = c("water_division",
                                   "water_basin",
                                   "political_division",
                                   "variable",
                                   "unit_of_measurement",
                                   "time_step"),
                      result){

  # create url
  api <- switch(
    val,
    water_basin =         "WaterBasin",
    water_division =      "WaterDivision",
    political_division =  "PoliticalDivision",
    variable =            "Variable",
    unit_of_measurement = "UnitOfMeasurement",
    time_step =           "TimeStep"
  )

  s_url <- paste0(h_url, "/api/", api, "/?format=json")

  get_values <- enhy_get_df(s_url)

  # merge values

  if (val == "variable" | val == "time_step") {
    res <-  merge(result[val], get_values[c("id", "descr")], by.x = val,
                  by.y = "id", all.x = TRUE)
    res$descr
  } else if (val == "unit_of_measurement") {
    res <-  merge(result[val], get_values[c("id", "symbol")], by.x = val,
                  by.y = "id", all.x = TRUE)
    res$symbol

  } else {
    res <-  merge(result[val], get_values[c("id", "name")], by.x = val,
                  by.y = "id", all.x = TRUE)
    res$name

  }



}


# get dataframe from json using an api
get_from_api <- function(subdomain, val) {

   # create url's first part
  h_url <- hydroscope_url(subdomain)

  # create url's second part
  api <- switch(
    val,
    stations            = "Gpoint",
    timeseries          = "Timeseries",
    instruments         = "Instrument",
    water_basin         = "WaterBasin",
    water_division      = "WaterDivision",
    political_division  = "PoliticalDivision",
    variable            = "Variable",
    unit_of_measurement = "UnitOfMeasurement",
    time_step           = "TimeStep"
  )

  s_url <- paste0(h_url, "/api/", api, "/?format=json")

  # get values
  enhy_get_df(s_url)

}

# main get and tranlit function
get_and_translit <- function(subdomain = c("kyy", "ypaat", "emy", "deh"),
                             api,
                             translit) {

  # match subdomain values
  subdomain <- match.arg(subdomain)

  # try to get data
  result <- tryCatch({
    get_from_api(subdomain, api)
  },
  error = function(e) {
    stop(paste0("Failed to parse url: ", h_url), call. = FALSE)
  })

  # transliterate names
  if(translit) {
    trasnlit_all(result)
  } else {
    result
  }
}
