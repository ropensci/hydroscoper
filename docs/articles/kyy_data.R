## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## ----database_creation---------------------------------------------------
#  # load libraries
#  library(hydroscoper)
#  library(tibble)
#  # get data from kyy
#  kyy_data <- get_database("kyy")
#  

## ----create_stations_coords----------------------------------------------
#  coords <- get_coords(kyy_data$stations$point)

## ------------------------------------------------------------------------
#  # create names data frames
#  wbas_names <- merge(x = kyy_data$stations$water_basin,
#                    y = kyy_data$water_basins[c("id", "name")],
#                    all.x = TRUE,
#                    by.x = "water_basin",
#                    by.y = "id")
#  wd_names <- merge(x = kyy_data$stations$water_division,
#                    y = kyy_data$water_divisions[c("id", "name")],
#                    all.x = TRUE,
#                    by.x = "water_division",
#                    by.y = "id")
#  own_names <- merge(x = kyy_data$stations$owner,
#                     y = kyy_data$owners[c("id", "name")],
#                      all.x = TRUE,
#                    by.x = "owner",
#                    by.y = "id")
#  
#  # transate names
#  own_names$name <- hydro_translate(own_names$name, "owner")
#  wd_names$name <- hydro_translate(wd_names$name, "division")

## ----stations_dataframe--------------------------------------------------
#  
#  stations <- tibble(
#    "station_id" = as.numeric(kyy_data$stations$id),
#    "name" = as.character(kyy_data$stations$name),
#    "water_basin" = as.character(wbas_names$name),
#    "water_division" = as.character(wd_names$name),
#    "owner" = as.character(own_names$name),
#    "longitude" = as.numeric(coords$long),
#    "latitude" = as.numeric(coords$lat),
#    "altitude" = as.numeric(kyy_data$stations$altitude)
#  )
#  stations

## ----timeseries_names----------------------------------------------------
#  # create names data frames
#  var_names <- merge(x = kyy_data$timeseries$variable,
#                    y = kyy_data$variables[c("id", "descr")],
#                    all.x = TRUE,
#                    by.x = "variable",
#                    by.y = "id")
#  ts_names <-  merge(x = kyy_data$timeseries$time_step,
#                    y = kyy_data$time_steps[c("id", "descr")],
#                    all.x = TRUE,
#                    by.x = "time_step",
#                    by.y = "id")
#  
#  ts_units <- merge(x = kyy_data$timeseries$unit_of_measurement,
#                    y = kyy_data$units[c("id", "symbol")],
#                    all.x = TRUE,
#                    by.x = "unit_of_measurement",
#                    by.y = "id")
#  
#  # translate names
#  var_names$descr <- hydro_translate(var_names$descr, "variable")
#  ts_names$descr <- hydro_translate(ts_names$descr, "timestep")
#  
#  

## ----timeseries_dataframe------------------------------------------------
#  timeseries <- tibble(
#    "timeser_id" = as.numeric(kyy_data$timeseries$id),
#    "station_id" = as.numeric(kyy_data$timeseries$gentity),
#    "variable" = as.character(var_names$descr),
#    "timestep" = as.character(ts_names$descr),
#    "units" = as.character(ts_units$symbol),
#    "start_date" = as.character(kyy_data$timeseries$start_date_utc),
#    "end_date" = as.character(kyy_data$timeseries$end_date_utc)
#  )
#  timeseries

