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


# use Enhydris API to get json data
enhy_get_df <- function(h_url, trans_lit = TRUE) {

  df <- jsonlite::fromJSON(h_url, flatten=TRUE)
  df <- tibble::as.tibble(df)

  for (cname in c(names(df))) {
    df[cname] <- greek2latin(df[cname])
  }

}

# use Enhydris API to get plain text data
enhy_get_txt <- function(h_url = "http://kyy.hydroscope.gr/api/tsdata/259/") {

  # read timeseries data
  tmFormat <- "%Y-%m-%d %H:%M"

  # use readr to get values
  ts <- readr::read_csv(url(h_url),
                  col_names = c("Date", "Value", "Comment"),
                  col_types = list(
                    readr::col_datetime(format = tmFormat),
                    readr::col_double(),
                    readr::col_character()))

  return(ts)
}
