context("Internal functions")

test_that("greek2latin returns a character", {
  expect_is(greek2latin("one"), "character")
  expect_is(greek2latin(c("one", "two")), "character")
})

test_that("stations_types returns a list", {
  expect_is(stations_types("GEORGIKOS"), "character")
  expect_is(stations_types(c("GEORGIKOS", "x")), "character")
})
