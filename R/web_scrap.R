# # web scrapping ----------------------------------------------------------------
#
# # parse stations' data
# parse_stations <- function(url, translit = TRUE) {
#
#   # parse url
#   doc <- XML::htmlParse(url, encoding = "UTF8")
#
#   # get table nodes
#   html_table <- "/html/body/div[3]/div/div/div/div[2]/div/table"
#   table_nodes <- XML::getNodeSet(doc, html_table)
#
#   # check if table nodes is NULL
#   if (is.null(table_nodes))  stop("")
#
#   # read html file to table
#   stations <- XML::readHTMLTable(table_nodes[[1]], stringsAsFactors = FALSE)
#
#   # check table's numbers of rows and cols
#   if (NROW(stations) == 0 | NCOL(stations) != 7) stop("Error reading table from html")
#
#   # Make valid names
#   names(stations) <- c("StationID", "Name", "WaterBasin", "WaterDivision",
#                        "PoliticalDivision", "Owner", "Type")
#
#   # Translations and transliterations ----------------------------------------
#   if (translit){
#     # replace greek characters with latin
#     for (cname in c(names(stations)[-1])) {
#       stations[cname] <- greek2latin(stations[cname])
#     }
#
#     # remove attributes
#     stations$Name <- as.vector(stations$Name)
#     stations$PoliticalDivision <- as.vector(stations$PoliticalDivision)
#
#     # translate types
#     stations$Type <- stations_types(stations$Type)
#
#     # add water division id
#     stations$WaterDivisionID <- add_wd_id(stations$WaterDivision)
#
#     # use abr/sions for owners' names
#     stations$Owner <- owner_names(stations$Owner)
#   }
#
#   # remove area from water basin values
#   stations$WaterBasin <- sapply(stations$WaterBasin, function(str){
#     gsub("\\([^()]*\\)", "", str)
#   })
#
#   # Return data --------------------------------------------------------------
#   cnames <- c("StationID", "Name", "WaterDivisionID", "WaterBasin",
#               "PoliticalDivision", "Owner", "Type")
#
#   stations[cnames]
#
# }
#
# # parse coords' data
# parse_coords <- function(url, stationID){
#
#   # parse url
#   doc <- XML::htmlParse(url, encoding = "UTF8")
#
#   # get table nodes
#   path <- "/html/body/div[3]/div/div[1]/div/div[2]/div/div[2]/table"
#   tableNodes <- XML::getNodeSet(doc, path)
#
#   # check if table nodes is NULL
#   if (is.null(tableNodes)) stop("")
#
#   # read table
#   stat_table <- XML::readHTMLTable(tableNodes[[1]], header = FALSE,
#                                    stringsAsFactors = FALSE)
#   # get values from table
#   values <- stat_table$V2
#   names(values) <- stat_table$V1
#
#   # convert Coords to Lat and Long
#   Elevation <- as.numeric(values["Altitude"])
#   Coords <- as.character(values["Co-ordinates"])
#   tmp <- stringr::str_split(string = Coords, pattern = ",|\n",
#                             simplify = TRUE)
#   Lat <- as.numeric(tmp[1])
#   Long <- as.numeric(tmp[2])
#
#   # return results as a dataframe
#   data.frame(StationID = stationID,
#              Long = Long,
#              Lat = Lat,
#              Elevation = Elevation)
#
# }
#
# # parse timeseries' data
# parse_timeseries <- function(url,stationID, translit = TRUE){
#
#
#   # parse url
#   doc <- XML::htmlParse(url, encoding = "UTF8")
#
#   # get table nodes
#   tableNodes <- XML::getNodeSet(doc, "//*[@id=\"timeseries\"]")
#
#   # check if table nodes is NULL
#   if (is.null(tableNodes)) stop("")
#
#   # read table
#   ts_table <- XML::readHTMLTable(tableNodes[[1]], header = TRUE,
#                                  stringsAsFactors = FALSE)
#   ts_table$StationID <- stationID
#
#   # check table dimensions
#   if (NROW(ts_table) == 0 | NCOL(ts_table) != 10) stop("")
#
#   # make names for table
#   names(ts_table) <- c("TimeSeriesID", "Name", "Variable", "TimeStep", "Unit",
#                        "Remarks", "Instrument", "StartDate", "EndDate",
#                        "StationID")
#
#   # Translations and transliterations ----------------------------------------
#   if (translit){
#     for (cname in c(names(ts_table))) {
#       ts_table[cname] <- greek2latin(ts_table[cname])
#     }
#
#     # translations
#     ts_table$Variable <- ts_variable(ts_table$Variable)
#     ts_table$TimeStep <- ts_timestep(ts_table$TimeStep)
#   }
#
#   # return dataframe
#   ts_table
#
# }
#
# # get data
# parse_data <-function(url, tmp) {
#
#   # download file
#   dl_code <- utils::download.file(url = url, destfile = tmp)
#   if (dl_code != 0) stop("")
#
#   # Count the number of fields in each line of a file
#   cf <- readr::count_fields(tmp,
#                             tokenizer = readr::tokenizer_csv(),
#                             n_max = 50)
#
#   # check the number of columns in hts file
#   if (any(cf == 3)) {
#
#     # read timeseries data
#     tmFormat <- "%Y-%m-%d %H:%M"
#     result <- suppressWarnings(readr::read_csv(file = tmp,
#                                                skip =  sum(cf < 3),
#                                                col_names = c("Date", "Value", "Comment"),
#                                                col_types = list(
#                                                  readr::col_datetime(format = tmFormat),
#                                                  readr::col_double(),
#                                                  readr::col_character())))
#
#     # remove NA Date values and return dataframe
#     result[!is.na(result$Date), ]
#
#   } else {
#     dataNA()
#   }
#
# }
