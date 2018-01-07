## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
   eval = FALSE,
  comment = "#>"
)

## ------------------------------------------------------------------------
#  library(hydroscoper)
#  library(plyr)
#  
#  subdomain <- c("kyy", "ypaat", "emy", "deh")
#  
#  # download all databases
#  hydro_data <- lapply(subdomain, function(x)get_database(x))
#  names(hydro_data) <- subdomain
#  

## ------------------------------------------------------------------------
#  # check stations variables
#  vars <- c("id", "name", "owner", "point", "altitude", "water_basin",
#            "water_division")
#  
#  sapply(subdomain, function(id) {
#    vars %in% names(hydro_data[[id]]$stations)
#  })
#  
#  # check water_basin, water_division and owner variables
#  vars2 <- c("id", "name")
#  sapply(subdomain, function(id) {
#    (vars2 %in% names(hydro_data[[id]]$water_basin)) &
#    (vars2 %in% names(hydro_data[[id]]$water_division)) &
#    (vars2 %in% names(hydro_data[[id]]$owner))
#  })

## ------------------------------------------------------------------------
#  stations <- ldply(subdomain, function(id){
#  
#    tmp <-  hydro_data[[id]]
#  
#    # extract dataframes to join
#    wbas <- tmp$water_basins[c("id", "name")]
#    wdiv <- tmp$water_divisions[c("id", "name")]
#    owners <- tmp$owners[c("id", "name")]
#  
#    # remove area from water_basin
#    wbas$name <- sapply(wbas$name, function(y) gsub("\\([^()]*\\)", "", y))
#  
#    # translate names
#    wdiv$name <- hydro_translate(wdiv$name, "division")
#    owners$name <- hydro_translate(owners$name, "owner")
#  
#    # rename dataframes
#    names(wbas) <- c("water_basin", "water_basin_name")
#    names(wdiv) <- c("water_division", "water_division_name")
#    names(owners) <- c("owner", "owner_name")
#  
#    # merge data
#    res <- merge(tmp$stations, wbas, by = "water_basin", all.x = TRUE)
#    res <- merge(res, wdiv, by = "water_division", all.x = TRUE)
#    res <- merge(res, owners, by = "owner", all.x = TRUE)
#  
#    # create coords
#    coords <- get_coords(res$point)
#  
#  
#    data.frame(station_id = as.integer(res$id),
#                   name = as.character(res$name),
#                   water_basin = res$water_basin_name,
#                   water_division = res$water_division_name,
#                   owner = res$owner_name,
#                   longitude = as.numeric(coords$long),
#                   latitude = as.numeric(coords$lat),
#                   altitude = as.numeric(res$altitude),
#                   subdomain = rep(id, nrow(res)))
#  
#  })
#  

## ------------------------------------------------------------------------
#  vart <- c("id", "gentity", "start_date_utc", "end_date_utc", "variable",
#            "time_step", "unit_of_measurement")
#  sapply(subdomain, function(id) {
#    vart %in% names(hydro_data[[id]]$timeseries)
#  })
#  
#  # use NA to fill missing values in deh$timeseries
#  vart[!(vart %in%  names(hydro_data$deh$timeseries))]
#  hydro_data$deh$timeseries$start_date_utc <- NA
#  hydro_data$deh$timeseries$end_date_utc <- NA
#  
#  # check variables and timesteps
#  vart2 <- c("id", "descr")
#  sapply(subdomain, function(id) {
#    (vart2 %in% names(hydro_data[[id]]$variables)) &
#    (vart2 %in% names(hydro_data[[id]]$time_steps))
#  })
#  
#  # check unit_of_measurement
#  vart3 <- c("id", "symbol")
#  sapply(subdomain, function(id) {
#    vart3 %in% names(hydro_data[[id]]$units)
#  })

## ------------------------------------------------------------------------
#  # create stations' dataframe
#  timeseries <- ldply(subdomain, function(id){
#  
#    tmp <-  hydro_data[[id]]
#  
#    # create data frames to join
#    var_names <- tmp$variables[c("id", "descr")]
#    ts_names <-  tmp$time_steps[c("id", "descr")]
#    ts_units <-tmp$units[c("id", "symbol")]
#  
#    # translate names
#    var_names$descr <- hydro_translate(var_names$descr, "variable")
#    ts_names$descr <- hydro_translate(ts_names$descr, "timestep")
#  
#    # rename data frames
#    names(var_names) <- c("variable", "variable_name")
#    names(ts_names) <- c("time_step", "time_step_name")
#    names(ts_units) <- c("unit_of_measurement", "unit_of_measurement_name")
#  
#    # merge data
#    res <- merge(tmp$timeseries, var_names, by = "variable", all.x = TRUE)
#    res <- merge(res, ts_names, by = "time_step", all.x = TRUE)
#    res <- merge(res, ts_units, by = "unit_of_measurement", all.x = TRUE)
#  
#    data.frame(
#      "timeser_id" = as.integer(res$id),
#      "station_id" = as.integer(res$gentity),
#      "variable" = as.character(res$variable_name),
#      "timestep" = as.character(res$time_step_name),
#      "units" = as.character(res$unit_of_measurement_name),
#      "start_date" = as.character(res$start_date_utc),
#      "end_date" = as.character(res$end_date_utc),
#      "subdomain" = rep(id, nrow(res))
#    )
#  })
#  

