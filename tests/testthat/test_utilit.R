context("Utility functions")

test_that("get_coords returns a data frame with lat and long values", {

  pnt <- c("SRID=4326;POINT (22.41211 39.07562)",
           "POINT (25.91659 40.93200)",
           "POINT (35.24414242152967)",
           NA,
           "",
           "38.81464027659262",
           "POINT ()")

  res <- data.frame(long = c(22.41211, 25.91659, NA, NA, NA, NA, NA),
                    lat =  c(39.07562, 40.93200, NA, NA, NA, NA, NA))
  expect_is(get_coords(pnt), "data.frame")
  expect_equal(get_coords(pnt), res)

})

