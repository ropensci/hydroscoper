# Data functions ---------------------------------------------------------------

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
coordsNA <- function() {
  data.frame(Long = NA,
             Lat = NA)
}

# create lat. and lon. from points
create_coords <- function(str) {
  str_split <- stringr::str_split(string = str, pattern = "[\\(  \\)]",
                     simplify = TRUE)

  if(NCOL(str_split) == 5) {
    data.frame(long = as.numeric(str_split[, 3]),
               lat = as.numeric(str_split[, 4]))
  } else {
    data.frame(long = rep(NA, NROW(str)),
               lat = rep(NA, NROW(str)))
  }

}
