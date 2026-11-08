# Run only when ALL intended providers are available, or deliberately use
# archived raw responses with recorded dates. Do not silently omit DEH.

library(hydroscoper)
subdomains <- c("kyy", "ypaat", "emy", "deh")
retrieved_at <- Sys.time()
hydro_data <- setNames(lapply(subdomains, get_database), subdomains)

require_columns <- function(x, columns) {
  if (!is.data.frame(x) || !all(columns %in% names(x))) {
    stop("Missing required columns: ", paste(columns, collapse = ", "))
  }
}
lookup <- function(x, column) {
  require_columns(x, c("id", column))
  stopifnot(!anyNA(x$id), !anyDuplicated(x$id))
  x[c("id", column)]
}

stations <- tibble::as_tibble(do.call(rbind, lapply(subdomains, function(id) {
  db <- hydro_data[[id]]
  require_columns(db$stations, c("id", "name", "point", "altitude",
                                 "owner", "water_basin", "water_division"))
  stopifnot(nrow(db$stations) > 0L)
  basin <- lookup(db$water_basins, "name")
  division <- lookup(db$water_divisions, "name")
  owner <- lookup(db$owners, "name")
  basin$name <- trimws(gsub("\\([^()]*\\)", "", basin$name))
  division$name <- hydro_translate(division$name, "division")
  owner$name <- hydro_translate(owner$name, "owner")
  names(basin) <- c("water_basin", "water_basin_name")
  names(division) <- c("water_division", "water_division_name")
  names(owner) <- c("owner", "owner_name")
  x <- merge(db$stations, basin, by = "water_basin", all.x = TRUE)
  x <- merge(x, division, by = "water_division", all.x = TRUE)
  x <- merge(x, owner, by = "owner", all.x = TRUE)
  coords <- hydro_coords(x$point)
  tibble::tibble(station_id = as.integer(x$id), name = x$name,
                 water_basin = x$water_basin_name, water_division = x$water_division_name,
                 owner = x$owner_name, longitude = coords$long, latitude = coords$lat,
                 altitude = as.numeric(x$altitude), subdomain = rep(id, nrow(x)))
})))

timeseries <- tibble::as_tibble(do.call(rbind, lapply(subdomains, function(id) {
  db <- hydro_data[[id]]
  require_columns(db$timeseries,
                  c("id", "gentity", "variable", "time_step", "unit_of_measurement"))
  x <- db$timeseries
  # Fill absent columns only; never overwrite existing DEH dates with NA.
  for (column in c("start_date_utc", "end_date_utc")) {
    if (!column %in% names(x)) x[[column]] <- rep(NA_character_, nrow(x))
  }
  variables <- lookup(db$variables, "descr")
  steps <- lookup(db$time_steps, "descr")
  units <- lookup(db$units_of_measurement, "symbol")
  variables$descr <- hydro_translate(variables$descr, "variable")
  steps$descr <- hydro_translate(steps$descr, "timestep")
  names(variables) <- c("variable", "variable_name")
  names(steps) <- c("time_step", "step_name")
  names(units) <- c("unit_of_measurement", "unit_symbol")
  x <- merge(x, variables, by = "variable", all.x = TRUE)
  x <- merge(x, steps, by = "time_step", all.x = TRUE)
  x <- merge(x, units, by = "unit_of_measurement", all.x = TRUE)
  tibble::tibble(time_id = as.integer(x$id), station_id = as.integer(x$gentity),
                 variable = x$variable_name, timestep = x$step_name, units = x$unit_symbol,
                 start_date = as.character(x$start_date_utc),
                 end_date = as.character(x$end_date_utc), subdomain = rep(id, nrow(x)))
})))

stopifnot(ncol(stations) == 9L, ncol(timeseries) == 8L,
          !anyDuplicated(stations[c("subdomain", "station_id")]),
          !anyDuplicated(timeseries[c("subdomain", "time_id")]))
print(table(stations$subdomain))
print(table(timeseries$subdomain))

# Review counts, unmatched lookups and date audit before saving.
# Store raw responses and provenance outside the shipped data/ directory.
saveRDS(list(retrieved_at = retrieved_at, data = hydro_data),
        file.path("data-raw", paste0("hydroscope_raw_",
                                     format(retrieved_at, "%Y%m%dT%H%M%S", tz = "UTC"), "Z.rds")))
usethis::use_data(stations, timeseries, overwrite = TRUE)
