## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----subset_data---------------------------------------------------------
library(hydroscoper)

data("stations")
data("timeseries")

# subset data
st_data <- subset(stations, subdomain == "kyy" |  subdomain =="ypaat")
time_data <- subset(timeseries, subdomain == "kyy" |  subdomain =="ypaat")

## ----stations_with_timeseries--------------------------------------------
st_data <- st_data[st_data$station_id %in% time_data$station_id,]

## ----create_map, message=F, warning=F------------------------------------

library(ggmap)

# create map
map <- get_map(
    location = c(lon = mean(stations$longitude, na.rm = TRUE),
                 lat = mean(stations$latitude, na.rm = TRUE)),
    maptype = "toner-background",
    color = 'bw',
    zoom = 6)
p <- ggmap(map)

p +
  geom_point(data = st_data,
             aes(x = longitude, y = latitude),
             fill = 'red',
             shape = 21,
             alpha = 0.8,
             size = 2) +
  scale_fill_brewer(palette = "Set1")+
  xlim(19.5, 29) +
  ylim(34, 41.5)

## ------------------------------------------------------------------------
head(sort(table(time_data$variable), decreasing = TRUE), n = 10)


## ------------------------------------------------------------------------
sort(table(time_data$timestep[time_data$variable == "precipitation"]), decreasing = TRUE)

