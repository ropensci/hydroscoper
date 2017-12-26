# Translations and transliterations --------------------------------------------
greek2latin <- function(x) {
  sapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    stringi::stri_trans_general(str, "latin-ascii")
  })
}

# stations types translation
stations_types <- function(type) {
  sapply(type, function(x) {
    switch(x,
           GEORGIKOS = "meteo_station",
           KLIMATOLOGIKOS = "meteo_station",
           METEOROLOGIKOS = "meteo_station",
           YDROMETEOROLOGIKOS = "meteo_station",
           STATHMEMETRIKOS = "stream_gauge",
           "unknown")
  })
}

# water divisions id creation
add_wd_id <- function(wd) {
  sapply(make.names(wd), function(x) {
    switch(x,
           DYTIKE.PELOPONNESOS = "GR01",
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
  sapply(make.names(owner), function(x) {
    switch(x,
           YPOURGEIO.PERIBALLONTOS..ENERGEIAS.KAI.KLIMATIKES.ALLAGES =
             "min_env",
           ETHNIKO.ASTEROSKOPEIO.ATHENAS = "noa",
           YPOURGEIO.AGROTIKES.ANAPTYXES.KAI.TROPHIMON = "min_rur",
           NOMARCHIAKE.AUTODIOIKESE = "prefec",
           ETHNIKE.METEOROLOGIKE.YPERESIA = "emy",
           DEMOSIA.EPICHEIRISE.ELEKTRISMOU = "dei",
           "other")
  })
}

# translate timeseries' variables names
ts_variable <- function(variable) {
  sapply(make.names(variable), function(x) {
    switch(x,
           ANEMOS..DIEUTHYNSE. = "wind_direc",
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
    switch(x,
           Emeresia...1.day.s. = "day",
           Meniaia...0.year.s. = "month",
           Variable.step = "variable",
           X10lepte...0.day.s. = "10min",
           X30lepte...0.day.s. = "30min",
           X5lepte...0.day.s. = "5min",
           "unknown")
  })
}

# Data creation functions ------------------------------------------------------

# create url
hydroscope_url <- function(domain) {
return(paste0("http://", domain, ".hydroscope.gr"))
}

# stations dataframe with NA values
stationsNA <- function() {
  data.frame(StationID = NA,
             Name = NA,
             WaterDivisionID = NA,
             WaterBasin = NA,
             PoliticalDivision = NA,
             Owner = NA,
             Type = NA)
}

# timeseries dataframe with NA values
timeserNA <- function(stationID) {
  data.frame(TimeSeriesID = NA,
             Name = NA,
             Variable = NA,
             TimeStep = NA,
             Unit = NA,
             Remarks = NA,
             Instrument = NA,
             StartDate = NA,
             EndDate = NA,
             StationID = stationID)
}

# data dataframe with NA values
dataNA <- function(){
  data.frame(Date = NA, Value = NA, Comment = NA)
}

# coords dataframe with NA values
coordsNA <- function(stationID) {
  data.frame(StationID = stationID,
             Long = NA,
             Lat = NA,
             Elevation = NA)
}


# web scrapping
parseStations <- function(url, translit = TRUE) {

  # parse url
  doc <- XML::htmlParse(url, encoding = "UTF8")

  # get table nodes
  html_table <- "/html/body/div[3]/div/div/div/div[2]/div/table"
  table_nodes <- XML::getNodeSet(doc, html_table)

  # check if table nodes is NULL
  if (is.null(table_nodes))  stop("")

  # read html file to table
  stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)

  # check table's numbers of rows and cols
  if (NROW(stations) == 0 | NCOL(stations) != 7) stop("Error reading table from html")

  # Make valid names
  names(stations) <- c("StationID", "Name", "WaterBasin", "WaterDivision",
                       "PoliticalDivision", "Owner", "Type")

  # Translations and transliterations ----------------------------------------
  if (translit){
    # replace greek characters with latin
    for (cname in c(names(stations)[-1])) {
      stations[cname] <- greek2latin(stations[cname])
    }

    # remove attributes
    stations$Name <- as.vector(stations$Name)
    stations$PoliticalDivision <- as.vector(stations$PoliticalDivision)

    # translate types
    stations$Type <- stations_types(stations$Type)

    # add water division id
    stations$WaterDivisionID <- add_wd_id(stations$WaterDivision)

    # use abr/sions for owners' names
    stations$Owner <- owner_names(stations$Owner)
  }

  # remove area from water basin values
  stations$WaterBasin <- sapply(stations$WaterBasin, function(str){
    gsub("\\([^()]*\\)", "", str)
  })

  # Return data --------------------------------------------------------------
  cnames <- c("StationID", "Name", "WaterDivisionID", "WaterBasin",
              "PoliticalDivision", "Owner", "Type")

  stations[cnames]

}
