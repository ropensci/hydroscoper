get_stations <- function() {

  url = "http://kyy.hydroscope.gr/"

  # download stations data
  doc <- XML::htmlParse(url, encoding = "UTF8")
  table_nodes <-
    XML::getNodeSet(doc, "/html/body/div[3]/div/div/div/div[2]/div/table")

  # check tableNodes
  if(is.null(tableNodes)) {
    stop(paste0("Couldn't download stations' list from", url))
  }


  stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)

  # make valid names for stations
  if (NROW(stations) > 0 & NCOL(stations) == 7) {
  names(stations) <- c("ID", "Name", "WaterBasin", "WaterDivision",
                       "PoliticalDivision", "Owner", "type")
  } else {
    stop(paste("Couldn't get any station data from url: ", url, ""))
  }

  # replace greek characters with latin
  for (cname in c(names(stations)[-1])) {
    stations[cname] <- greek2latin(stations[cname])
  }

  # change type to meaningfull names
  type <- stations$type
  type <- ifelse(type %in% c("GEORGIKOS", "KLIMATOLOGIKOS", "METEOROLOGIKOS",
                             "YDROMETEOROLOGIKOS"),
                 "Meteorogical", type)
  type <- ifelse(type == "STATHMEMETRIKOS", "StreamGage", type)
  stations$Type <- type

  # add water division id
  wd_names <- names(table(stations$WaterDivision))
  if (length(wd_names) == 14) {

    wd <- stations$WaterDivision
    wd <- make.names(wd)
    lookup <- c(ANATOLIKE.MAKEDONIA = "EL11",
                 ANATOLIKE.PELOPONNES = "EL13",
                 ANATOLIKE.STEREA.ELL = "EL07",
                 ATTIKE = "EL06",
                 BOREIA.PELOPONNESOS = "EL02",
                 DYTIKE.MAKEDONIA = "EL09",
                 DYTIKE.PELOPONNESOS = "EL01",
                 DYTIKE.STEREA.ELLADA = "EL04",
                 EPEIROS = "EL05",
                 KENTRIKE.MAKEDONIA = "EL10",
                 KRETE = "EL13",
                 NESOI.AIGAIOU = "EL14",
                 THESSALIA = "EL06",
                 THRAKE = "EL12")
    wd <- lookup[wd]
    names(wd) <- NULL
  stations$WaterDivisionID <-  wd
  }

  # change owner to meaningfull names
  owner <- stations$Owner
  kyy <- "YPOURGEIO PERIBALLONTOS, ENERGEIAS KAI KLIMATIKES ALLAGES"
  noa <- "ETHNIKO ASTEROSKOPEIO ATHENAS"

  owner <- ifelse(owner == noa,
                  "NOA",
                  owner)
  owner <- ifelse(owner == kyy,
                  "MEE",
                  owner)
  owner <- ifelse(owner %in% c("NOA", "MEE"),
                  owner,
                  "Other")

  stations$Owner <- owner

  # remove area from water basin values
  stations$WaterBasin <- sapply(stations$WaterBasin,
                                 function(str) gsub("\\([^()]*\\)", "", str))

  return(stations)
}

get_coords <- function(stationID = '200251') {

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
  tb1  <- XML::readHTMLTable(tableNodes[[1]],
                           header = FALSE,
                           stringsAsFactors = FALSE)
  # rearrange data
  tb1u  <- t(utils::unstack(tb1, form=V2~V1))

  # subset data
  x  <- tb1u[c(4,1,2)]

  # get coords and elevation
  if(class(x) == 'character'){
    Elevation <-  x[2]
    Coords <- x[3]
  } else if (class(x) == 'list') {
    Elevation <-  x[[2]]
    Coords <- x[[3]]
  } else {
    Elevation <-  NA
    Coords <- "NA \n NA"
  }

  # convert Coords to Lat and Long
  Coords <- as.character(Coords)
  tmp = stringr::str_split(string = Coords, pattern = ',|\n', simplify = TRUE)
  Lat = as.numeric(tmp[1])
  Long= as.numeric(tmp[2])

  # return results as a dataframe
  data.frame(ID = stationID, Long = Long, Lat = Lat, Elevation = Elevation)

}

get_timeseries <- function(stationID = '200251') {

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

  # make valid names for timeseries
  if (NROW(tb2) > 0 & NCOL(tb2) == 10) {
    names(tb2) <- c("TimeSeriesID", "Name", "Variable", "TimeStep", "Unit", "Remarks",
                    "Instrument", "StartDate", "EndDate", "StationID")
  } else {
    stop(paste("Couldn't get timeseries data from url: ", url, ""))
  }

  # convert strings to latin
  for (cname in c(names(tb2))) {
    tb2[cname] <- greek2latin(tb2[cname])
  }

  # make data meaningfull

  return(tb2)
}

