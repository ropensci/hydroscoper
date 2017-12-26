library(hydroscoper)
library(plyr)

station_coords <- function(domain) {
  stations <- get_stations(domain)
  stations$Domain <- domain
  coords <- ldply(stations$StationID, function(id) get_coords(domain, id))
  merge(stations, coords, by = 'StationID', all.x = TRUE)
}

timeser <- function(domain, stationsID) {
  ts <- ldply(StationID, function(id) get_timeseries(domain, id))
  ts$Domain <- domain
  return(ts)
}

# get stations data
kyy_stations <- station_coords("kyy")
emy_stations <- station_coords("emy")
ypaat_stations <- station_coords("ypaat")

# concatenate data
stations <- rbind(kyy_stations, emy_stations, ypaat_stations)

# remove errors
stations[which(stations$Long > 28.5),]
stations[931, c('Long', 'Lat')] <- c(NA, NA)
stations[1123, c('Long', 'Lat')] <- c(NA, NA)
stations[1310, c('Long', 'Lat')] <- c(NA, NA)
stations[1340, c('Long', 'Lat')] <- c(NA, NA)


devtools::use_data(stations,  overwrite = TRUE)


# get timeseries



kyy_ts <- ldply(kyy_stations$StationID, function(id) get_timeseries("kyy", id))
ypaat_ts <- ldply(kyy_stations$StationID, function(id) get_timeseries("ypaat", id))
emy_ts <- ldply(kyy_stations$StationID, function(id) get_timeseries("emy", id))



