#' stations
#'
#' Stations' data from the Greek National Data Bank for Hydrological and
#' Meteorological Information.
#'
#' @format A data frame:
#' \describe{
#'     \item{station_id}{The station's ID from the domain's database}
#'     \item{name}{The station's name}
#'     \item{water_basin}{The station's Water Basin}
#'     \item{water_division}{The station's Water Division}
#'     \item{owner}{The station's owner}
#'     \item{longitude}{The station's longitude in decimal degrees, ETRS89}
#'     \item{latitude}{The station's latitude in decimal degrees, ETRS89}
#'     \item{altitude}{The station's altitude, meters above sea level}
#'     \item{subdomain}{The corresponding Hydroscope's database}
#' }
"stations"

#' timeseries
#'
#' Time series' data from the Greek National Data Bank for Hydrological and
#' Meteorological Information, Ministry of Environment and Energy.
#'
#' @format A data frame:
#' \describe{
#'     \item{timeser_id}{The time series ID from the database}
#'     \item{station_id}{The corresponding station's ID}
#'     \item{variable}{The time series variable type}
#'     \item{timestep}{The timestep of time series}
#'     \item{units}{The units of the time series}
#'     \item{start_date}{The starting date of time series values}
#'     \item{end_date}{The ending date of time series values}
#'     \item{subdomain}{The corresponding Hydroscope's database}
#' }
"timeseries"
