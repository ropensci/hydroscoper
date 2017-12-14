get_stations <- function(url = "http://kyy.hydroscope.gr/") {

  # Web scrapping --------------------------------------------------------------

  # download stations data
  doc <- XML::htmlParse(url, encoding = "UTF8")

  # get table nodes
  html_table <- "/html/body/div[3]/div/div/div/div[2]/div/table"
  table_nodes <- XML::getNodeSet(doc, html_table)

  # check table nodes
  if(is.null(table_nodes)) {
    stop(paste0("Couldn't download stations' list from", url))
  }

  # read html file to table
  stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)

  # Make valid names -----------------------------------------------------------

  # make valid names for stations if there are rows and the columns are 7
  if (NROW(stations) > 0 & NCOL(stations) == 7) {
  names(stations) <- c("ID", "Name", "WaterBasin", "WaterDivision",
                       "PoliticalDivision", "Owner", "Type")
  } else {
    stop(paste("Couldn't get any station data from url: ", url, ""))
  }

  # Translations and transliterations ------------------------------------------


  # replace greek characters with latin
  for (cname in c(names(stations)[-1])) {
    stations[cname] <- greek2latin(stations[cname])
  }

  # translate types
  stations$Type <- stations_types(stations$Type)

  # add water division id
  wd_names <- names(table(stations$WaterDivision))
  if (length(wd_names) == 14) {
    stations$WaterDivisionID <-  add_wd_id(stations$WaterDivision)
  }

  # use abr/sions for owners' names
  stations$Owner <- owner_names(stations$Owner)

  # remove area from water basin values
  stations$WaterBasin <- sapply(stations$WaterBasin,
                                 function(str) gsub("\\([^()]*\\)", "", str))

  cnames <- c("ID","Name", "WaterDivisionID","WaterBasin", "PoliticalDivision",
              "Owner", "Type")

  return(stations[cnames])
}

get_coords <- function(stationID = '200280') {

  # Web scrapping --------------------------------------------------------------

  url <- paste0("http://kyy.hydroscope.gr/stations/d/", stationID, "/")

  doc <- XML::htmlParse(url, encoding = 'UTF8')

  # get table nodes
  path = "/html/body/div[3]/div/div[1]/div/div[2]/div/div[2]/table"
  tableNodes <- XML::getNodeSet(doc, path)

  # check table nodes
  if(is.null(tableNodes)) {
    stop(paste0("Couldn't download station data for stationID =",stationID))
  }

  # read table
  stat_table  <- XML::readHTMLTable(tableNodes[[1]],
                           header = FALSE,
                           stringsAsFactors = FALSE)

  # get values from table
  values <- stat_table$V2
  names(values) <- stat_table$V1

  # Coordinates creation -------------------------------------------------------

  # convert Coords to Lat and Long
  Elevation <-as.numeric(values['Altitude'])
  Coords <- as.character(values['Co-ordinates'])
  tmp <- stringr::str_split(string = Coords, pattern = ',|\n', simplify = TRUE)
  Lat <- as.numeric(tmp[1])
  Long <- as.numeric(tmp[2])

  # return results as a dataframe
  data.frame(ID = stationID, Long = Long, Lat = Lat, Elevation = Elevation)

}

get_timeseries <- function(stationID = '200251') {

  # Web scrapping --------------------------------------------------------------

  # parse hydroscope
  url <- paste0("http://kyy.hydroscope.gr/stations/d/", stationID, "/")
  doc <- XML::htmlParse(url, encoding = 'UTF8')

  # get table nodes
  tableNodes <- XML::getNodeSet(doc, '//*[@id="timeseries"]')
  if(is.null(tableNodes)) {
    stop(paste("Couldn't download timeseries list for station ID =", stationID))
  }
  # read table
  tb2 <- XML::readHTMLTable(tableNodes[[1]], header = TRUE, stringsAsFactors = FALSE)
  tb2$StationID <- stationID

  # make valid names for timeseries --------------------------------------------
  if (NROW(tb2) > 0 & NCOL(tb2) == 10) {
    names(tb2) <- c("TimeSeriesID", "Name", "Variable", "TimeStep", "Unit",
                    "Remarks",  "Instrument", "StartDate", "EndDate",
                    "StationID")
  } else {
    stop(paste("Couldn't get timeseries data from url: ", url, ""))
  }

  # Translations and transliterations ------------------------------------------

  # convert strings to latin
  for (cname in c(names(tb2))) {
    tb2[cname] <- greek2latin(tb2[cname])
  }

  # translations TODO

  return(tb2)
}

