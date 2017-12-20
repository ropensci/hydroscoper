## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(hydroscoper)
library(plyr)

subdomain <- "kyy"

# get stations data
stations <- get_stations(subdomain)
 
# get coordinates and elevation
coords <- ldply(stations$StationID, function(id) {
   suppressWarnings(get_coords(subdomain, id))
})

# merge data
stations_coords <- merge(stations, coords, by = "StationID", all.x = TRUE)

# show data
head(stations_coords)

## ------------------------------------------------------------------------

# subdomain to use
subdomain <- "kyy"

# create timeseries dataframe
timeseries <- ldply(stations$StationID, function(id) {
  suppressWarnings(get_timeseries(subdomain, stationID = id))
})

head(timeseries)

