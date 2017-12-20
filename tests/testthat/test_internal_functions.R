context("Internal functions")

test_that("Translations and transliterations return a character vector", {

  expect_is(greek2latin("one"), "character")
  expect_is(greek2latin(c("one", "two")), "character")

  expect_is(stations_types("GEORGIKOS"), "character")
  expect_is(stations_types(c("GEORGIKOS", "STATHMEMETRIKOS")), "character")
  expect_is(stations_types(c("GEORGIKOS", "x")), "character")

  expect_is(add_wd_id("EPEIROS"), "character")
  expect_is(add_wd_id(c("ATTIKE", "KRETE")), "character")
  expect_is(add_wd_id(c("ATTIKE", "d")), "character")

  expect_is(owner_names("DEMOSIA.EPICHEIRISE.ELEKTRISMOU"), "character")
  expect_is(owner_names(c("DEMOSIA.EPICHEIRISE.ELEKTRISMOU",
                             "NOMARCHIAKE.AUTODIOIKESE")), "character")
  expect_is(owner_names(c("DEMOSIA.EPICHEIRISE.ELEKTRISMOU", "x")), "character")

  expect_is(ts_variable("CHIONI"), "character")
  expect_is(ts_variable(c("CHIONI", "PAROCHE")), "character")
  expect_is(ts_variable(c("CHIONI", "x")), "character")

  expect_is(ts_timestep("Emeresia...1.day.s."), "character")
  expect_is(ts_timestep(c("Emeresia...1.day.s.", "Variable.step")), "character")
  expect_is(ts_timestep(c("Variable.step", "x")), "character")
})

test_that("hydroscope_url returns a character vector", {
  expect_is(hydroscope_url("kyy"), "character")
})

test_that("NA functions return dataframe with NA values", {

  expect_is(stationsNA(), "data.frame")
  expect_equal(NCOL(stationsNA()), 7)
  expect_true(all(is.na(stationsNA())))

  expect_error(timeserNA())
  expect_is(timeserNA(1), "data.frame")
  expect_equal(NCOL(timeserNA(1)), 10)
  expect_true(all(is.na(timeserNA(1)[-10])))

  expect_is(dataNA(), "data.frame")
  expect_equal(NCOL(dataNA()), 3)
  expect_true(all(is.na(dataNA())))

  expect_error(coordsNA())
  expect_is(coordsNA(1), "data.frame")
  expect_equal(NCOL(coordsNA(1)), 4)
  expect_true(all(is.na(coordsNA(1)[-1])))

})

