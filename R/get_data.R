get_stations <- function(url = "http://kyy.hydroscope.gr/") {

  # download stations data
  doc <- XML::htmlParse(url, encoding = "UTF8")
  table_nodes <-
    XML::getNodeSet(doc, "/html/body/div[3]/div/div/div/div[2]/div/table")
  stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)

  # make valid names for stations
  if (NROW(stations) > 0 & NCOL(stations == 7)) {
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
