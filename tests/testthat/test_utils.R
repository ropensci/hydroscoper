context("utils tests")

test_that("degrees are converted to rads", {
  degr <- 180
  expect_equal(object = deg_to_rads(degr), pi)
})

test_that("computing distance with Haversine Formula", {
  expect_equal(haversine(37.5, 22, 37.5, 23), 88.244145)
})
