# library(hydroscoper)
# library(plyr)


api_stations <- name <- function(domain) {
  h_url <- hydroscope_url(domain)
  h_url <- paste0(h_url, "/api/Gpoint/?format=json")
  df <- enhy_get_df(h_url)

  df$domain <- domain
  df
}

kyy_stations <- api_stations("kyy")
ypaat_stations <- api_stations("ypaat")
emy_stations <- api_stations("emy")
deh_stations <- api_stations("deh")

deh_stations$original_id <- NULL
deh_stations$original_db <- NULL

# # helper functions -------------------------------------------------------------
#
# stations_use_api <- function(domain) {
#
#   h_url <- hydroscope_url(subdomain)
#   h_url <- paste0(h_url, "/api/Gpoint/?format=json")
#
#   stations <- enhy_get_df(h_url)
#   stations$Domain <- domain
#   stations
# }
#
# timeser <- function(stationsID, domain) {
#   ts <- ldply(stationsID, function(id) get_timeseries(domain, id))
#   ts$Domain <- domain
#   ts <- ts[ !is.na(ts$TimeSeriesID),]
#   return(ts)
# }
#
# # stations dataframes ----------------------------------------------------------
#
#
# # get stations data
# kyy_stations <- stations_use_api("kyy")
# emy_stations <- station_coords("emy")
# ypaat_stations <- station_coords("ypaat")
#
# dei_stations <- station_coords("deh")
#
# # combine data by rows
# stations <- rbind(kyy_stations, emy_stations, ypaat_stations)
#
# # remove erroneous coordinates
# stations[which(stations$Long > 28.5),]
# stations[931, c('Long', 'Lat')] <- c(NA, NA)
# stations[1123, c('Long', 'Lat')] <- c(NA, NA)
# stations[1310, c('Long', 'Lat')] <- c(NA, NA)
# stations[1340, c('Long', 'Lat')] <- c(NA, NA)
#
# # save stations data
# devtools::use_data(stations,  overwrite = TRUE)
#
# # time series dataframes -------------------------------------------------------
#
# # get timeseries
# kyy_ts <- timeser(kyy_stations$StationID, "kyy")
# emy_ts <- timeser(emy_stations$StationID, "emy")
# ypaat_ts <- timeser(ypaat_stations$StationID, "ypaat")
#
# # combine data
# timeseries <- rbind(kyy_ts, emy_ts, ypaat_ts)
#
# # remove name and remarks
# timeseries$Name <- NULL
# timeseries$Remarks <- NULL
#
#
# # save time series data
# devtools::use_data(timeseries,  overwrite = TRUE)
