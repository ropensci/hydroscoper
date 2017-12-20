## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----stations df creation, eval = FALSE----------------------------------
#  library(hydroscoper)
#  library(plyr)
#  
#  subdomain <- "kyy"
#  
#  # get stations data
#  stations <- get_stations(subdomain)
#  
#  # get coordinates and elevation
#  coords <- ldply(stations$StationID, function(id) {
#     get_coords(subdomain, id)
#  })
#  
#  # merge data
#  stations <- merge(stations, coords, by = "StationID", all.x = TRUE)
#  
#  # show data
#  head(stations)

## ----timeseries creation, eval = FALSE-----------------------------------
#  # create timeseries dataframe
#  timeseries <- ldply(stations$StationID, function(id) {
#    get_timeseries(subdomain, id)
#  })
#  
#  head(timeseries)

