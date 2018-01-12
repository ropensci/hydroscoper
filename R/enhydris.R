# Enhydris API -----------------------------------------------------------------

# use ping to check if a subdomain is alive
down_server <- function(subdomain) {
  h_url <- paste0(subdomain, ".hydroscope.gr")

  if (is.na(pingr::ping(h_url, count = 1))) {
    stop(paste0("The server for that data source is probably down, get more info
                at hydroscope@hydroscope.gr or try again later"),
         call. = FALSE)
  }
}


# get subdomains' tables
get_api_json <- function(subdomain) {
  h_url <- paste0(hydroscope_url(subdomain), "/api/?format=json") # nolint
  enhy_get_df(h_url)
}

# create url
hydroscope_url <- function(subdomain) {
  return(paste0("http://", subdomain, ".hydroscope.gr"))
}

# use Enhydris API to get json data
enhy_get_df <- function(s_url) {

  # get data
  jsonlite::fromJSON(s_url, flatten = TRUE)
}

# use Enhydris API to get plain text data
enhy_get_txt <- function(h_url) {

  # read timeseries data
  tm_format <- "%Y-%m-%d %H:%M"

  # use readr to get values
  readr::read_csv(url(h_url),
                  col_names = c("Date", "Value", "Comment"),
                  col_types = list(
                    readr::col_datetime(format = tm_format),
                    readr::col_double(),
                    readr::col_character()))
}

# get api name
get_api <- function(val) {

  switch(
    val,
    stations            = "Station",
    timeseries          = "Timeseries",
    instruments         = "Instrument",
    water_basin         = "WaterBasin",
    water_division      = "WaterDivision",
    political_division  = "PoliticalDivision",
    variable            = "Variable",
    unit_of_measurement = "UnitOfMeasurement",
    time_step           = "TimeStep",
    owner               = "Organization",
    intr_type           = "InstrumentType",
    station_type        = "StationType",
    stop(paste0(val, " is not used as an api value"))

  )
}

# workhorse function
get_and_translit <- function(subdomain = c("kyy", "ypaat", "emy", "deh"),
                             val,
                             translit) {

  # match subdomain values
  subdomain <- match.arg(subdomain)

  api <- get_api(val)

  # create url
  h_url <- hydroscope_url(subdomain)

  # check if a sudomain is down
  down_server(subdomain)

  s_url <- paste0(h_url, "/api/", api, "/?format=json") # nolint

  # try to get data
  result <- tryCatch({
    enhy_get_df(s_url)
  },
  error = function(e) {
    stop(paste0("No data found at url: ", s_url), call. = FALSE)
  })

  # transliterate names
  if (translit) {
    result <- trasnlit_all(result)
  }

  tibble::as.tibble(result)
}

# create coords from points in Hydroscope
create_coords <- function(str) {

  str_split <- stringr::str_split(string = str, pattern = "[\\(  \\)]",
                                  simplify = TRUE)
  if (NCOL(str_split) == 5) {
    tibble::tibble(long = as.numeric(str_split[, 3]),
               lat = as.numeric(str_split[, 4]))
  } else {
    tibble::tibble(long = rep(NA, NROW(str)),
               lat = rep(NA, NROW(str)))
  }
}
