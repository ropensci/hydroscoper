shape <- sf::st_read("data-raw/greece_shp/greece.shp", quiet = TRUE)
stopifnot(!is.na(sf::st_crs(shape)), sf::st_crs(shape) == sf::st_crs(2100))
shape <- sf::st_set_crs(shape, 2100)
geometry <- sf::st_cast(sf::st_geometry(sf::st_transform(
  shape, 4258, allow_ballpark = FALSE)),
  "MULTIPOLYGON")
xy <- sf::st_coordinates(geometry)
# L1=ring, L2=polygon, L3=feature for MULTIPOLYGON coordinates.
stopifnot(all(c("X", "Y", "L1", "L2", "L3") %in% colnames(xy)))
rings <- interaction(xy[, "L3"], xy[, "L2"], xy[, "L1"], drop = TRUE)
greece_borders <- tibble::tibble(long = xy[, "X"], lat = xy[, "Y"],
                                 order = as.integer(ave(seq_len(nrow(xy)), rings, FUN = seq_along)),
                                 hole = xy[, "L1"] > 1,
                                 piece = interaction(xy[, "L3"], xy[, "L2"], drop = TRUE), group = rings)
usethis::use_data(greece_borders, overwrite = TRUE)
