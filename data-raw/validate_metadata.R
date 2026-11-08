# Use the constructed timeseries object or load the bundled dataset first.
audit <- timeseries[c("subdomain", "time_id", "start_date", "end_date")]
start <- suppressWarnings(readr::parse_datetime(audit$start_date))
end <- suppressWarnings(readr::parse_datetime(audit$end_date))
cutoff <- as.POSIXct(Sys.Date() + 1, tz = "UTC")
audit$invalid_start <- !is.na(audit$start_date) & is.na(start)
audit$invalid_end <- !is.na(audit$end_date) & is.na(end)
audit$future_start <- !is.na(start) & start > cutoff
audit$future_end <- !is.na(end) & end > cutoff
audit$reversed <- !is.na(start) & !is.na(end) & end < start
issue <- rowSums(audit[c("invalid_start", "invalid_end", "future_start",
                         "future_end", "reversed")]) > 0
print(audit[issue, ])
utils::write.csv(audit[issue, ], "data-raw/metadata_date_issues.csv",
                 row.names = FALSE, na = "")
validated <- timeseries
validated$start_date[audit$invalid_start | audit$future_start | audit$reversed] <- NA_character_
validated$end_date[audit$invalid_end | audit$future_end | audit$reversed] <- NA_character_
# Use validated for analysis; keep the original dates in the distributed data.

