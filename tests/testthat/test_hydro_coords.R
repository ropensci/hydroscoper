context("hydro_coords tests")

test_that("hydro_coords returns a tibble with lat and long values", {
  pnt <- c(
    "SRID=4326;POINT (22.41211 39.07562)",
    "POINT (25.91659 40.93200)",
    "POINT (35.24414242152967)",
    NA,
    "",
    "38.81464027659262",
    "POINT ()"
  )

  res <- tibble::tibble(
    long = c(22.41211, 25.91659, NA, NA, NA, NA, NA),
    lat = c(39.07562, 40.93200, NA, NA, NA, NA, NA)
  )
  expect_s3_class(hydro_coords(pnt), "tbl_df")
  expect_equal(hydro_coords(pnt), res)
})


testthat::test_that("POINT parsing handles whitespace and keeps its schema", {
  x <- c("POINT(23 38)", " POINT (23  38) ", "POINT (23\t38)",
         "SRID=4326;POINT (2.3e1 38)")
  testthat::expect_equal(hydro_coords(x),
                         tibble::tibble(long = rep(23, 4), lat = rep(38, 4)))
  testthat::expect_equal(hydro_coords(character()),
                         tibble::tibble(long = double(), lat = double()))
  testthat::expect_equal(hydro_coords(c(NA_character_, "", "JUNK (23 38)",
                                        "POINT (181 38)")),
                         tibble::tibble(long = rep(NA_real_, 4), lat = rep(NA_real_, 4)))
  testthat::expect_error(hydro_coords("SRID=2100;POINT (500000 4200000)"),
                         "Unsupported SRID")
  testthat::expect_error(hydro_coords(23), "character vector")
})
