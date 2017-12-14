# Translations and transliterations --------------------------------------------
greek2latin <- function(x) {
  lapply(x, function(str) {
    str <- stringi::stri_trans_general(str, "Latin")
    stringi::stri_trans_general(str, "latin-ascii")
    })
}

stations_types <- function(type) {

  # convert stations types to meteorological station and stream gage
  type <- ifelse(type %in% c("GEORGIKOS", "KLIMATOLOGIKOS", "METEOROLOGIKOS",
                             "YDROMETEOROLOGIKOS"),
                 "MeteoStation", type)
  type <- ifelse(type == "STATHMEMETRIKOS", "StreamGage", type)

  return(type)
}

add_wd_id <- function(wd) {

  # use a lookup table to create Water Division IDs
  wd_names <- make.names(wd)
  lookup <- c(DYTIKE.PELOPONNESOS = "GR01",
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
              NESOI.AIGAIOU = "GR14")
  wd <- lookup[wd_names]
  names(wd) <- NULL

  return(wd)
}

owner_names <- function(owner) {

  # abr/sions strings
  kyy <- "YPOURGEIO PERIBALLONTOS, ENERGEIAS KAI KLIMATIKES ALLAGES"
  noa <- "ETHNIKO ASTEROSKOPEIO ATHENAS"

  # change owners' names
  owner <- ifelse(owner == noa,
                  "NOA",
                  owner)
  owner <- ifelse(owner == kyy,
                  "MEE",
                  owner)
  owner <- ifelse(owner %in% c("NOA", "MEE"),
                  owner,
                  "Other")

  return(owner)
}
