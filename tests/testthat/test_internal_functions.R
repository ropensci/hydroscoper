context("Internal functions")

test_that("Translations and transliterations return a character vector", {

  # greek2latin
  expect_is(greek2latin("one"), "character")
  expect_is(greek2latin(c("one", "two")), "character")

  # stations_types
  expect_is(stations_types("GEORGIKOS"), "character")
  expect_is(stations_types(c("KLIMATOLOGIKOS", "METEOROLOGIKOS")), "character")
  expect_is(stations_types(c("YDROMETEOROLOGIKOS","STATHMEMETRIKOS", "x")),
            "character")

  # add_wd_id
  expect_is(add_wd_id("DYTIKE.PELOPONNESOS "), "character")
  expect_is(add_wd_id(c("BOREIA.PELOPONNESOS", "ANATOLIKE.PELOPONNES")),
            "character")
  expect_is(add_wd_id(c("DYTIKE.STEREA.ELLADA","EPEIROS", "ATTIKE",
                        "DYTIKE.PELOPONNESOS", "d")),
            "character")
  expect_is(add_wd_id(c("ANATOLIKE.STEREA.ELL","THESSALIA", "DYTIKE.MAKEDONIA",
                        "KENTRIKE.MAKEDONIA", "ANATOLIKE.MAKEDONIA",
                        "THRAKE", "KRETE", "NESOI.AIGAIOU")),
            "character")

  expect_is(owner_names("DEMOSIA.EPICHEIRISE.ELEKTRISMOU"), "character")
  expect_is(owner_names(c("ETHNIKO.ASTEROSKOPEIO.ATHENAS",
                             "NOMARCHIAKE.AUTODIOIKESE")), "character")
  expect_is(
    owner_names(c("YPOURGEIO.AGROTIKES.ANAPTYXES.KAI.TROPHIMON",
                  "ETHNIKE.METEOROLOGIKE.YPERESIA",
                  "YPOURGEIO.PERIBALLONTOS..ENERGEIAS.KAI.KLIMATIKES.ALLAGES",
                  "x")), "character")

  expect_is(ts_variable("ASBESTIO"), "character")
  expect_is(ts_variable(c("ANEMOS..DIEUTHYNSE.", "ANEMOS..TACHYTETA.")),
            "character")
  expect_is(ts_variable(c("ANEMOS..TACHYTETA.MESE.", "x")), "character")
  expect_is(
    ts_variable(c("BATHOS.YGROU..CHIONOBROCHOMETRO.",
                  "BROCHOPTOSE",
                  "CHIONI",
                  "CHIONI...BROCHE..CHIONOBROCHOMETRO.",
                  "EXATMISE..EKTIMEMENE.",
                  "EXATMISE..PAROUSA.",
                  "PAROCHE",
                  "PIESE..ATMOSPHAIRIKE.",
                  "STATHME",
                  "STATHME..PLEMMYRA.",
                  "THERMOKRASIA..AERA.",
                  "THERMOKRASIA..EDAPHOUS.",
                  "THERMOKRASIA..EDAPHOUS.EL..",
                  "THERMOKRASIA..EDAPHOUS.MEG..",
                  "THERMOKRASIA..ELACHISTE.",
                  "THERMOKRASIA..MEGISTE.",
                  "YDROMETRESE",
                  "YGRASIA..APOLYTE.",
                  "YGRASIA..SCHETIKE.",
                  "x")), "character"
  )

  expect_is(ts_timestep("Emeresia...1.day.s."), "character")
  expect_is(ts_timestep(c("Meniaia...0.year.s.", "Variable.step")), "character")
  expect_is(ts_timestep(c("X10lepte...0.day.s.", "X30lepte...0.day.s.",
                          "X5lepte...0.day.s.", "Meniaia...0.year.s.", "x")),
            "character")
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

