# DEH did not resolve, so a full live rebuild could lose historical metadata.

snapshot <- new.env(parent = emptyenv())
load("data/timeseries.rda", envir = snapshot)
original <- snapshot$timeseries
timeseries <- original
replacements <- c(humidity_rmintive = "humidity_relative",
                  levminflood = "level_flood", minophaneia_duration = "sunshine_duration",
                  pressure_levminsea = "pressure_level_sea")
observed <- vapply(names(replacements), function(label) {
  sum(timeseries$variable == label, na.rm = TRUE)
}, integer(1))
# Reviewed snapshot or an already-repaired snapshot; fail on unexpected data.
stopifnot(identical(unname(observed), c(255L, 79L, 8L, 114L)) ||
            all(observed == 0L))
matched <- match(timeseries$variable, names(replacements))
change <- !is.na(matched)
timeseries$variable[change] <- unname(replacements[matched[change]])
stopifnot(identical(timeseries[names(timeseries) != "variable"],
                    original[names(original) != "variable"]))
usethis::use_data(timeseries, overwrite = TRUE)
