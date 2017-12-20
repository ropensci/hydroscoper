
#' Get stations data
#'
#' \code{get_stations} returns a dataframe with data from the stations that
#' exist in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy), \code{"ypaat"} (Ministry of Rural Development and Food),
#' \code{"emy"} (National Meteorological Service) or \code{"main"} (all the
#' databases, merged), returns a tidy dataframe with stations' data
#' from the corresponding database of hydroscope.gr. Otherwise gives an error
#' message.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{StationID}{The station's ID from the domain's database}
#'     \item{Name}{The station's name}
#'     \item{WaterDivisionID}{The station's Water Division ID, values: GR01 -
#'     GR14}
#'     \item{WaterBasin}{The station's Water Basin}
#'     \item{PoliticalDivision}{The station's Political Division}
#'     \item{Owner}{The station's owner}
#'     \item{Type}{The station's type}
#' }
#'
#' @note
#' Stations' IDs might not be unique at the different databases records from the
#' different Hydroscope domains.
#'
#' The Greek Water Divisions ID are:
#' \tabular{ll}{
#' \strong{Code}  \tab \strong{Name} \cr
#' GR01 \tab DYTIKE PELOPONNESOS \cr
#' GR02 \tab BOREIA PELOPONNESOS \cr
#' GR03 \tab ANATOLIKE PELOPONNESOS \cr
#' GR04 \tab DYTIKE STEREA ELLADA \cr
#' GR05 \tab EPEIROS  \cr
#' GR06 \tab ATTIKE  \cr
#' GR07 \tab ANATOLIKE STEREA ELLADA \cr
#' GR08 \tab THESSALIA  \cr
#' GR09 \tab DYTIKE MAKEDONIA  \cr
#' GR10 \tab KENTRIKE MAKEDONIA  \cr
#' GR11 \tab ANATOLIKE MAKEDONIA  \cr
#' GR12 \tab THRAKE  \cr
#' GR13 \tab KRETE  \cr
#' GR14 \tab NESOI AIGAIOU  \cr
#' }
#'
#' The codes used in Owner variable are:
#' \tabular{ll}{
#' \strong{Code}  \tab \strong{Name} \cr
#' min_env \tab Ministry of Environment and Energy \cr
#' noa \tab National Observatory of Athens \cr
#' min_rur \tab  Ministry of Rural Development and Food\cr
#' prefec \tab Prefectures of Greece  \cr
#' emy \tab National Meteorological Service  \cr
#' dei \tab Public Power Corporation  \cr
#' }
#'
#' The types used at station's type are:
#' \tabular{ll}{
#' \strong{Code}  \tab \strong{Description} \cr
#' meteo_station \tab Weather station \cr
#' stream_gage \tab Gauging station  \cr
#' }
#'
#' @examples
#'
#' # get stations' data from the Greek National Meteorological Service
#' emy_stations <- get_stations(subdomain = "emy")
#'
#' \dontrun{
#' dei_stations <- get_stations(subdomain = "dei")
#' }
#'
#' @references
#' European Terrestrial Reference System 1989 (ETRS),
#' \url{http://bit.ly/2kJwFuf}
#'
#' Greek Water Divisions,
#' \url{http://bit.ly/2kk0tOm}
#'
#' Stations' data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}
#' \item Main Hydroscope's database,
#' \url{http://main.hydroscope.gr}
#'}
#'
#'
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import XML
#' @export get_stations
get_stations <- function(subdomain =  c("kyy", "ypaat", "emy", "main")) {

  # match subdomain values
  subdomain <- match.arg(subdomain)

  # create url
  url <- hydroscope_url(subdomain)

  # Web scrapping --------------------------------------------------------------
  tryCatch({
    # parse url
    doc <- XML::htmlParse(url, encoding = "UTF8")

    # get table nodes
    html_table <- "/html/body/div[3]/div/div/div/div[2]/div/table"
    table_nodes <- XML::getNodeSet(doc, html_table)

    # check if table nodes is NULL
    if (is.null(table_nodes))  stop()

    # read html file to table
    stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)

    # check table's numbers of rows and cols
    if (NROW(stations) == 0 | NCOL(stations) != 7) stop()

    # Make valid names
    names(stations) <- c("StationID", "Name", "WaterBasin", "WaterDivision",
                           "PoliticalDivision", "Owner", "Type")

    # Translations and transliterations ----------------------------------------

    # replace greek characters with latin
    for (cname in c(names(stations)[-1])) {
      stations[cname] <- greek2latin(stations[cname])
    }

    # translate types
    stations$Type <- stations_types(stations$Type)

    # add water division id
    stations$WaterDivisionID <- add_wd_id(stations$WaterDivision)

    # use abr/sions for owners' names
    stations$Owner <- owner_names(stations$Owner)

    # remove area from water basin values
    stations$WaterBasin <- sapply(stations$WaterBasin, function(str){
      gsub("\\([^()]*\\)", "", str)
    })

    # Return data --------------------------------------------------------------
    cnames <- c("StationID", "Name", "WaterDivisionID", "WaterBasin",
                "PoliticalDivision", "Owner", "Type")

    stations[cnames]
  },
  error = function(e) {
    warning(paste0("Failed to parse url: ", url, "\n"))
    stationsNA()
  })
}


#' Get station's coordinates
#'
#' \code{get_coords} returns a dataframe with the coordinates and elevation from
#' a station in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param stationID A station ID
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy), \code{"ypaat"} (Ministry of Rural Development and Food),
#' \code{"emy"} (National Meteorological Service) or \code{"main"} (all the
#' databases, merged), and stationID is not NULL, returns a dataframe with
#' station's coordinates and elevation from the corresponding database of
#' hydroscope.gr. Otherwise gives an error message.
#'
#'  If the station ID does not exist in the database, or the url from hydroscope
#'  could not parsed, returns a dataframe with NA values.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{StationID}{The station's ID from the database}
#'     \item{Long}{The station's longitude in decimal degrees, ETRS89}
#'     \item{Lat}{The station's latitude in decimal degrees, ETRS89}
#'     \item{Elevation}{The station's altitude, meters above sea level}
#' }
#'
#' @note
#' Stations' IDs might not be unique at the different databases records from the
#' different Hydroscope domains.
#'
#' @examples
#' # get station 200171 coords from the Greek Ministry of Environment and Energy
#' get_coords("kyy", 200171)
#'
#' # get station data from the Greek National Meteorological Service
#' get_coords("emy", 20035)
#'
#' \dontrun{
#' get_coords("emy")
#' }
#'
#' @references
#' European Terrestrial Reference System 1989 (ETRS),
#' \url{http://bit.ly/2kJwFuf}
#'
#' Stations' data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}
#' \item Main Hydroscope's database,
#' \url{http://main.hydroscope.gr}
#'}
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import XML
#' @export get_coords
get_coords <- function(subdomain =  c("kyy", "ypaat", "emy", "main"),
                       stationID) {

  # check that stationID is given
  if (is.null(stationID)) stop("argument \"stationID\" is missing")

  # match subdomain values -----------------------------------------------------
  subdomain <- match.arg(subdomain)

  # create url
  url <- hydroscope_url(subdomain)
  url <- paste0(url, "/stations/d/", stationID, "/")

  # Web scrapping --------------------------------------------------------------
  tryCatch({

    # parse url
    doc <- XML::htmlParse(url, encoding = "UTF8")

    # get table nodes
    path <- "/html/body/div[3]/div/div[1]/div/div[2]/div/div[2]/table"
    tableNodes <- XML::getNodeSet(doc, path)

    # check if table nodes is NULL
    if (is.null(tableNodes)) stop()

    # read table
    stat_table <- XML::readHTMLTable(tableNodes[[1]], header = FALSE,
                                     stringsAsFactors = FALSE)
    # get values from table
    values <- stat_table$V2
    names(values) <- stat_table$V1

    # convert Coords to Lat and Long
    Elevation <- as.numeric(values["Altitude"])
    Coords <- as.character(values["Co-ordinates"])
    tmp <- stringr::str_split(string = Coords, pattern = ",|\n",
                              simplify = TRUE)
    Lat <- as.numeric(tmp[1])
    Long <- as.numeric(tmp[2])

    # return results as a dataframe
    data.frame(StationID = stationID,
               Long = Long,
               Lat = Lat,
               Elevation = Elevation)
  },
  error = function(e) {
    warning(paste0("Failed to parse url: ", url, "\n"))
    # return NA values
    coordsNA(stationID)
  })

}


#' Get time series corresponding to a station
#'
#' \code{get_timeseries} returns a dataframe with the available time series from
#' a station in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param stationID A station ID
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy), \code{"ypaat"} (Ministry of Rural Development and Food),
#' \code{"emy"} (National Meteorological Service) or \code{"main"} (all the
#' databases, merged), and stationID is not NULL, returns a dataframe with
#' time series data from the corresponding station and database of
#' hydroscope.gr. Otherwise gives an error message.
#'
#'  If the station ID does not exist in the database, or the url from hydroscope
#'  could not parsed, returns a dataframe with NA values.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{TimeSeriesID}{The time series ID from the database}
#'     \item{Name}{The time series name}
#'     \item{Variable}{The time series variable type}
#'     \item{TimeStep}{The timestep of time series}
#'     \item{Unit}{The units of the time series}
#'     \item{Remarks}{Remarks from Hydroscope}
#'     \item{Instrument}{The instrument ID}
#'     \item{StartDate}{The starting date of time series values}
#'     \item{EndDate}{The ending date of time series values}
#'     \item{StationID}{The corresponding station's ID}
#' }
#'
#' @note
#' Stations' and time series' IDs might not be unique at the different databases
#' records from the different Hydroscope domains.
#'
#' The codes used in Variable are:
#' \tabular{ll}{
#' \strong{Code}  \tab \strong{Name} \cr
#' wind_direc \tab Wind Direction \cr
#' wind_speed \tab Wind Speed \cr
#' wind_speed_av \tab  Average Wind Speed\cr
#' calcium \tab Calcium Concentration  \cr
#' rain_snow \tab Rain and Snow Height  \cr
#' rainfall \tab Rain Height  \cr
#' snow \tab Snow Height  \cr
#' evap_estim \tab Estimated Evaporation   \cr
#' evap_actual \tab Measured Evaporation \cr
#' flow \tab Discharge  \cr
#' pressure \tab Atmospheric Pressure  \cr
#' water_level_flood \tab Flood Water Level   \cr
#' air_temp \tab Air Temperature  \cr
#' ground_temp \tab Ground Temperature  \cr
#' ground_temp_min \tab Minimum Ground Temperature  \cr
#' ground_temp_max \tab Maximum Ground Temperature  \cr
#' temp_min \tab Minimum Air Temperature  \cr
#' temp_max \tab Maximum Air Temperature  \cr
#' humid_absol \tab Absolute Humidity  \cr
#' humid_rel \tab Relative Humidity  \cr
#' }
#'
#' @examples
#' # get station's time series from the Greek Ministry of Environment and Energy
#' get_timeseries("kyy", 200171)
#'
#' \dontrun{
#' get_timeseries("ypaat")
#' }
#'
#' @references
#' Stations' data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}
#' \item Main Hydroscope's database,
#' \url{http://main.hydroscope.gr}
#'}
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import XML
#' @export get_timeseries
get_timeseries <- function(subdomain =  c("kyy", "ypaat", "emy", "main"),
                           stationID) {

  # check that stationID is given
  if (is.null(stationID)) stop("argument \"stationID\" is missing")

  # match subdomain values -----------------------------------------------------
  subdomain <- match.arg(subdomain)
  url <- hydroscope_url(subdomain)
  url <- paste0(url, "/stations/d/", stationID, "/")

  # Web scrapping --------------------------------------------------------------
  tryCatch({

    # parse url
    doc <- XML::htmlParse(url, encoding = "UTF8")

    # get table nodes
    tableNodes <- XML::getNodeSet(doc, "//*[@id=\"timeseries\"]")

    # check if table nodes is NULL
    if (is.null(tableNodes)) stop()

    # read table
    ts_table <- XML::readHTMLTable(tableNodes[[1]], header = TRUE,
                              stringsAsFactors = FALSE)
    ts_table$StationID <- stationID

    # check table dimensions
    if (NROW(ts_table) == 0 | NCOL(ts_table) != 10) stop()

    # make names for table
    names(ts_table) <- c("TimeSeriesID", "Name", "Variable", "TimeStep", "Unit",
                    "Remarks", "Instrument", "StartDate", "EndDate",
                    "StationID")

    # Translations and transliterations ----------------------------------------
    for (cname in c(names(ts_table))) {
      ts_table[cname] <- greek2latin(ts_table[cname])
    }

    # translations
    ts_table$Variable <- ts_variable(ts_table$Variable)
    ts_table$TimeStep <- ts_timestep(ts_table$TimeStep)

    # convert start and end dates to posixct -----------------------------------
    ts_table$StartDate <- ifelse(ts_table$StartDate == "",
                                 NA, ts_table$StartDate)
    ts_table$EndDate <- ifelse(ts_table$EndDate == "",
                               NA, ts_table$EndDate)

    # create dates
    time_format <- "%Y/%m/%d %H:%M"
    ts_table$StartDate <- as.POSIXct(ts_table$StartDate,
                                     format = time_format,
                                     tz = "")
    ts_table$EndDate <- as.POSIXct(ts_table$EndDate,
                                   format = time_format,
                                   tz = "")

    # return dataframe
    ts_table

  },
  error = function(e) {
    warning(paste0("Failed to parse url: ", url, "\n"))
    timeserNA(stationID)
  })
}


#' Get time series values in a tidy dataframe
#'
#' \code{get_data} returns a tidy dataframe with the available data from
#' a time series in a database of Hydroscope.
#'
#' @param subdomain One of the subdomains of hydroscope.gr
#' @param timeID A time series ID
#'
#' @return If \code{subdomain} is one of \code{"kyy"} (Ministry of Environment
#' and Energy), \code{"ypaat"} (Ministry of Rural Development and Food) or
#' \code{"emy"} (National Meteorological Service), and timeID is not NULL,
#' returns a tidy dataframe with the time series values from the corresponding
#' time series and database of hydroscope.gr. Otherwise gives an error message.
#'
#' If the time series ID does not exist in the database, or the url from
#' Hydroscope could not parsed, returns a dataframe with NA values.
#'
#' The dataframe columns are:
#' \describe{
#'     \item{Date}{The time series Dates (POSIXct)}
#'     \item{Value}{The time series values (numeric)}
#'     \item{Comment}{Comments from Hydroscope (character)}
#' }
#'
#' @note
#' The subdomain "main" from Hydroscope is not used, because it uses different
#' ID values for time series from the other subdomains and also because it does
#' not contain the raw data of the time series.
#'
#' @examples
#' # get time series 912 from the Greek Ministry of Environment and Energy
#' df <-get_data("kyy", 912)
#'
#' \dontrun{
#' get_data("ypaat")
#' }
#'
#' @references
#' Stations' data are retrieved from the Hydroscope's databases:
#' \itemize{
#' \item Ministry of Environment, Energy and Climate Change,
#' \url{http://kyy.hydroscope.gr}
#' \item Ministry of Rural Development and Food,
#' \url{http://ypaat.hydroscope.gr}
#' \item National Meteorological Service,
#' \url{http://emy.hydroscope.gr}
#' \item Main Hydroscope's database,
#' \url{http://main.hydroscope.gr}
#'}
#' @author Konstantinos Vantas, \email{kon.vantas@gmail.com}
#' @import readr
#' @export get_data
get_data <- function(subdomain =  c("kyy", "ypaat", "emy"), timeID) {

  # check that stationID is given
  if (is.null(timeID)) stop("argument \"timeID\" is missing")

  # match subdomain values -----------------------------------------------------
  subdomain <- match.arg(subdomain)
  url <- hydroscope_url(subdomain)
  url <- paste0(url, "/timeseries/d/", timeID, "/download/")

  # Download and convert hydroscope file to dataframe --------------------------

  # create a temp file
  tmp <- tempfile()
  suppressWarnings(
    result<- tryCatch({

      # download file
      dl_code <- utils::download.file(url = url, destfile = tmp)
      if (dl_code != 0) stop()

      # Count the number of fields in each line of a file
      cf <- readr::count_fields(tmp,
                                tokenizer = readr::tokenizer_csv(),
                                n_max = 50)

      # check the number of columns in hts file
      if (any(cf == 3)) {

        # read timeseries data
        tmFormat <- "%Y-%m-%d %H:%M"
        result <- readr::read_csv(file = tmp,
                                  skip =  sum(cf < 3),
                                  col_names = c("Date", "Value", "Comment"),
                                  col_types = list(
                                    readr::col_datetime(format = tmFormat),
                                    readr::col_double(),
                                    readr::col_character()))

        # remove NA Date values and return dataframe
        result[!is.na(result$Date), ]

      } else {
        dataNA()
      }
    },
    error = function(e) {
      # return NA values
      warning(paste("Couldn't get time series' data from "), url, "\n")
      dataNA()

    },
    finally = {
      # delete temp file
      unlink(tmp)
    }))
  return(result)
}
