#' Create host name address using a subdomain
#' @noRd
server_address <- function(subdomain) {
  paste0(subdomain, ".hydroscope.gr")
}

#' Ping a remote server to see if its alive
#' @noRd
server_alive <- function(subdomain) {
  if (all(is.na(pingr::ping(server_address(subdomain), count = 3)))) {
    err_msg <- paste("The server for that data source is probably down,",
                     "get more info at hydroscope@hydroscope.gr or try",
                     "again later.")
    stop(err_msg, call. = FALSE)
  }
}

#' create coords from points
#' @noRd
create_coords <- function(str) {

  str_split <- stringr::str_split(string = str, pattern = "[\\(  \\)]",
                                  simplify = TRUE)
  if (NCOL(str_split) == 5) {
    tibble::tibble(long = as.numeric(str_split[, 3]),
                   lat = as.numeric(str_split[, 4]))
  } else {
    tibble::tibble(long = rep(NA, NROW(str)),
                   lat = rep(NA, NROW(str)))
  }
}
