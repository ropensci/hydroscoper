library(hydroscoper)
library(plyr)

# helper functions -------------------------------------------------------------

station_coords <- function(domain) {
  stations <- get_stations(domain)
  stations$Domain <- domain
  coords <- ldply(stations$StationID, function(id) get_coords(domain, id))
  merge(stations, coords, by = 'StationID', all.x = TRUE)
}

timeser <- function(stationsID, domain) {
  ts <- ldply(stationsID, function(id) get_timeseries(domain, id))
  ts$Domain <- domain
  ts <- ts[ !is.na(ts$TimeSeriesID),]
  return(ts)
}

# stations dataframes ----------------------------------------------------------


# get stations data
kyy_stations <- station_coords("kyy")
emy_stations <- station_coords("emy")
ypaat_stations <- station_coords("ypaat")

# combine data by rows
stations <- rbind(kyy_stations, emy_stations, ypaat_stations)

# remove erroneous coordinates
stations[which(stations$Long > 28.5),]
stations[931, c('Long', 'Lat')] <- c(NA, NA)
stations[1123, c('Long', 'Lat')] <- c(NA, NA)
stations[1310, c('Long', 'Lat')] <- c(NA, NA)
stations[1340, c('Long', 'Lat')] <- c(NA, NA)

# save stations data
devtools::use_data(stations,  overwrite = TRUE)

# time series dataframes -------------------------------------------------------

# get timeseries
kyy_ts <- timeser(kyy_stations$StationID, "kyy")
emy_ts <- timeser(emy_stations$StationID, "emy")
ypaat_ts <- timeser(ypaat_stations$StationID, "ypaat")

# combine data
timeseries <- rbind(kyy_ts, emy_ts, ypaat_ts)

# remove name and remarks
timeseries$Name <- NULL
timeseries$Remarks <- NULL


# save time series data
devtools::use_data(timeseries,  overwrite = TRUE)
