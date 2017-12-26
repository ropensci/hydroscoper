#' stations
#'
#' Stations' data from the Greek National Data Bank for Hydrological and
#' Meteorological Information databases: \url{http://kyy.hydroscope.gr/},
#' \url{http://emy.hydroscope.gr/} and \url{http://ypaat.hydroscope.gr/}
#' The stations with IDs: have erroneous coordinates and their longitudes,
#' latitudes have been replaced with NA values.
#'
#' @format A data frame:
#' \describe{
#'     \item{StationID}{The station's ID from the domain's database}
#'     \item{Name}{The station's name}
#'     \item{WaterDivisionID}{The station's Water Division ID, values: GR01 -
#'     GR14}
#'     \item{WaterBasin}{The station's Water Basin}
#'     \item{PoliticalDivision}{The station's Political Division}
#'     \item{Owner}{The station's owner}
#'     \item{Type}{The station's type}
#'     \item{Domain}{The corresponding Hydroscope's domain}
#'     \item{Long}{The station's longitude in decimal degrees, ETRS89}
#'     \item{Lat}{The station's latitude in decimal degrees, ETRS89}
#'     \item{Elevation}{The station's altitude, meters above sea level}

#' }
"stations"

#' timeseries
#'
#' Time series' data from the Greek National Data bank for Hydrological and
#' Meteorological Information databases: \url{http://kyy.hydroscope.gr/},
#' \url{http://emy.hydroscope.gr/} and \url{http://ypaat.hydroscope.gr/}
#'
#' @format A data frame:
#' \describe{
#'     \item{TimeSeriesID}{The time series ID from the database}
#'     \item{Variable}{The time series variable type}
#'     \item{TimeStep}{The timestep of time series}
#'     \item{Unit}{The units of the time series}
#'     \item{Instrument}{The instrument ID}
#'     \item{StartDate}{The starting date of time series values}
#'     \item{EndDate}{The ending date of time series values}
#'     \item{StationID}{The corresponding station's ID}
#'     \item{Domain}{The corresponding Hydroscope's domain}
#' }
"timeseries"
