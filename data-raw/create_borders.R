# load packages
library(ggplot2)
library(broom)
library(rgdal)

#load greece polygon
greece_borders <- readOGR(dsn = "./data-raw/greece_shp", layer = "greece")
proj4string(greece_borders) = CRS("+init=epsg:2100")

#convert to ETRS89
etrs89 <- CRS("+init=epsg:4258")
greece_borders <- spTransform(greece_borders, etrs89)

# convert shp file to dataframe
greece_borders <- broom::tidy(greece_borders)

# remove id variable (no values in there)
greece_borders$id <- NULL

# convert to a tibble
greece_borders <- tibble::as.tibble(greece_borders)

# save data
devtools::use_data(greece_borders, overwrite = TRUE)
