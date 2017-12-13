get_stations <- function(url = "http://kyy.hydroscope.gr/") {

  # download stations data
  doc <- XML::htmlParse(url, encoding = 'UTF8')
  tableNodes <- XML::getNodeSet(doc, '/html/body/div[3]/div/div/div/div[2]/div/table')
  Stations <- XML::readHTMLTable(tableNodes[[1]], stringsAsFactors = FALSE)

  # make valid names for stations
  if(NROW(Stations) > 0 & NCOL(Stations == 7)) {
  names(Stations) <- c("ID", "Name", "WaterBasin", "WaterDivision",
                       "PoliticalDivision", "Owner", "Type")
  } else {
    stop( paste("Couldn't get any station data from url: ", url, ""))
  }

  # replace greek characters with latin
  for (cname in c(names(Stations)[-1])) {
    Stations[cname] <- greek2latin(Stations[cname])
  }

  # change type to meaningfull names
  Type <- Stations$Type
  Type <- ifelse(Type %in% c("GEORGIKOS", "KLIMATOLOGIKOS", "METEOROLOGIKOS"),
                 "Meteorogical", Type)
  Type <- ifelse(Type == "STATHMEMETRIKOS", "StreamGage", Type)
  Type <- ifelse(Type == "YDROMETEOROLOGIKOS", "HydroMeteorogical", Type)
  Stations$Type <- Type

  # add water division id
  wd_names <- names(table(Stations$WaterDivision))
  if(length(wd_names) == 14) {

    wd <- Stations$WaterDivision
    wd <- make.names(wd)
    lookup <- c( ANATOLIKE.MAKEDONIA = "EL11",
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
  Stations$WaterDivisionID <-  wd
  }

  # change owner to meaningfull names
  owner <- Stations$Owner
  owner <- ifelse(owner == "ETHNIKO ASTEROSKOPEIO ATHENAS",
                  "NOA",
                  owner)
  owner <- ifelse(owner == "YPOURGEIO PERIBALLONTOS, ENERGEIAS KAI KLIMATIKES ALLAGES",
                  "MEE",
                  owner)
  owner <- ifelse(owner %in% c("NOA", "MEE"),
                  owner,
                  "Other")

  Stations$Owner <- owner

  # remove area from water basin values
  Stations$WaterBasin <- lapply( Stations$WaterBasin, function(str) gsub("\\([^()]*\\)", "", str))

  return(Stations)
}
