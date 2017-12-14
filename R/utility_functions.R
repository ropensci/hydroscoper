# Translations and transliterations --------------------------------------------
greek2latin <- function(x) {
  lapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    stringi::stri_trans_general(str, "latin-ascii")
  })
}

# stations types translation
stations_types <- function(type) {
  sapply(type, function(x) {
    switch(x, GEORGIKOS = "MeteoStation",
           KLIMATOLOGIKOS = "MeteoStation",
           METEOROLOGIKOS = "MeteoStation",
           YDROMETEOROLOGIKOS = "MeteoStation",
           STATHMEMETRIKOS = "StreamGage",
           "unknown")
  })
}

# water divisions id creation
add_wd_id <- function(wd) {
  sapply(make.names(wd), function(x) {
    switch(x, DYTIKE.PELOPONNESOS = "GR01",
           BOREIA.PELOPONNESOS = "GR02",
           ANATOLIKE.PELOPONNES = "GR03",
           DYTIKE.STEREA.ELLADA = "GR04",
           EPEIROS = "GR05",
           ATTIKE = "GR06",
           ANATOLIKE.STEREA.ELL = "GR07",
           THESSALIA = "GR08",
           DYTIKE.MAKEDONIA = "GR09",
           KENTRIKE.MAKEDONIA = "GR10",
           ANATOLIKE.MAKEDONIA = "GR11",
           THRAKE = "GR12",
           KRETE = "GR13",
           NESOI.AIGAIOU = "GR14",
           "unknown")
  })
}

# translate owners' names
owner_names <- function(owner) {

  # abr/sions strings
  kyy <- "YPOURGEIO PERIBALLONTOS, ENERGEIAS KAI KLIMATIKES ALLAGES"
  noa <- "ETHNIKO ASTEROSKOPEIO ATHENAS"

  # change owners' names
  owner <- ifelse(owner == noa, "NOA", owner)
  owner <- ifelse(owner == kyy, "MEE", owner)
  owner <- ifelse(owner %in% c("NOA", "MEE"), owner, "Other")

  return(owner)
}

# translate timeseries' variables names
ts_variable <- function(variable) {
  sapply(make.names(variable), function(x) {
    switch(x, ANEMOS..DIEUTHYNSE. = "wind_direc",
           ANEMOS..TACHYTETA. = "wind_speed",
           ANEMOS..TACHYTETA.MESE. = "wind_speed_av",
           ASBESTIO = "calcium",
           BATHOS.YGROU..CHIONOBROCHOMETRO. = "rain_snow",
           BROCHOPTOSE = "rainfall",
           CHIONI = "snow",
           CHIONI...BROCHE..CHIONOBROCHOMETRO. = "rain_snow",
           EXATMISE..EKTIMEMENE. = "evap_estim",
           EXATMISE..PAROUSA. = "evap_actual",
           PAROCHE = "flow",
           PIESE..ATMOSPHAIRIKE. = "pressure",
           STATHME = "water_level",
           STATHME..PLEMMYRA. = "water_level_flood",
           THERMOKRASIA..AERA. = "air_temp",
           THERMOKRASIA..EDAPHOUS. = "ground_temp",
           THERMOKRASIA..EDAPHOUS.EL.. = "ground_temp_min",
           THERMOKRASIA..EDAPHOUS.MEG.. = "ground_temp_max",
           THERMOKRASIA..ELACHISTE. = "temp_min",
           THERMOKRASIA..MEGISTE. = "temp_max",
           YDROMETRESE = "flow",
           YGRASIA..APOLYTE. = "humid_absol",
           YGRASIA..SCHETIKE. = "humid_rel",
           "unknown")
  })
}

# translate timestep names
ts_timestep <- function(variable) {
  sapply(make.names(variable), function(x) {
    switch(x, Emeresia...1.day.s. = "day",
           Meniaia...0.year.s. = "month",
           Variable.step = "variable",
           X10lepte...0.day.s. = "10min",
           X30lepte...0.day.s. = "30min",
           X5lepte...0.day.s. = "5min",
           "unknown")
  })
}

# Data creation functions ------------------------------------------------------

# stations dataframe with NA values
stationsNA <- function() {
  data.frame(ID = NA,
             Name = NA,
             WaterDivisionID = NA,
             WaterBasin = NA,
             PoliticalDivision = NA,
             Owner = NA, Type = NA)
}

# timeseries dataframe with NA values
timeserNA <- function() {
  data.frame(TimeSeriesID = NA,
             Variable = NA,
             TimeStep = NA,
             Unit = NA,
             Instrument = NA,
             StartDate = NA,
             EndDate = NA,
             StationID = stationID)
}

# create stations' database
stations_db <- function() {

  # download data
  stations <- get_stations()
  coords <- plyr::ldply(stations$ID, function(id) get_coords(id))

  # merge data
  stations <- merge(stations, coords, by = "ID")

  # replace empty values with NA
  stations$WaterBasin <- ifelse(stations$WaterBasin == "", NA,
                                stations$WaterBasin)
  stations$PoliticalDivision <- ifelse(stations$PoliticalDivision == "", NA,
                                       stations$PoliticalDivision)
  stations$WaterBasin <- ifelse(stations$WaterBasin == "", NA,
                                stations$WaterBasin)

  return(stations)

}

# create timeseries database
timeseries_db <- function() {

  # download data
  stations <- get_stations()
  timeseries <- plyr::ldply(stations$ID, function(id) get_timeseries(id))
  return(timeseries)

}
