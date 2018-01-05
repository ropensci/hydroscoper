context("Translitetation and translation functions")

test_that("greek2latin retrurns string", {

  expect_is( greek2latin("hello"), "character")
  expect_is( greek2latin(NA), "character")
  expect_is( greek2latin(NULL), "character")
})

test_that("Organizations translations", {

  orgs <- c(
    "DEMOSIA EPICHEIRISE ELEKTRISMOU          ",
    "ETHNIKE METEOROLOGIKE YPERESIA           ",
    "ETHNIKO ASTEROSKOPEIO ATHENAS             ",
    "ETHNIKO IDRYMA AGROTIKES EREUNAS ",
    "MOUSEIO PHYSIKES ISTORIAS KRETES",
    "NOMARCHIAKE AUTODIOIKESE",
    "POLYTECHNEIO KRETES",
    "YPOURGEIO AGROTIKES ANAPTYXES KAI TROPHIMON                      ",
    "YPOURGEIO PERIBALLONTOS, ENERGEIAS KAI KLIMATIKES ALLAGES"
  )

  res <- c("public_power_corp", "natio_meteo_service", "natio_observ_athens",
           "natio_argic_resear", "crete_natural_museum", "greek_perfectures",
           "crete_eng_faculty", "min_agricult", "min_envir_energy")

  expect_error(hydro_translate())
  expect_equal(hydro_translate(orgs, "owner"), res)


})

test_that("Variables are translated", {

  vars <- c( "THERMOKRASIA (EDAPHOUS)",
             "AMMONIA",
             "ANEMOS (TACHYTETA)",
             "THERMOKRASIA (EDAPHOUS BATHOS5)",
             "AGNOSTO",
             "TASE YDRATMON",
             "STEREO-YDROMETRESE",
             "CHIONI (ISODYNAMO YPSOS)",
             "YGRASIA (APOLYTE)")

  res <- c("temperature_ground",
           "ammonia",
           "wind_speed",
           "temperature_ground_depth5",
           "unknown",
           "vapour_pressure",
           "sediment_flow_gauge",
           "snow_water_equivalent",
           "humidity_absol")

  expect_equal(hydro_translate(vars, "variable"), res)

})

test_that("Time steps are translated", {

ts_raw <- c("10lepte", "30lepte", "5lepte", "Etesia", "Emeresia", "Meniaia",
        "Oriaia")

tr_trans <- c("10_minutes", "30_minutes", "5_minutes", "annual", "daily",
              "monthly", "hourly")
expect_equal(hydro_translate(ts_raw, "timestep"), tr_trans)

})

test_that("Water Divisions are translated", {

wd_raw <- c("ANATOLIKE MAKEDONIA ", "ANATOLIKE PELOPONNES",
            "ANATOLIKE STEREA ELL", "ATTIKE              ",
            "BOREIA PELOPONNESOS ", "DYTIKE MAKEDONIA    ",
            "DYTIKE PELOPONNESOS ", "DYTIKE STEREA ELLADA",
            "EPEIROS             ", "THESSALIA            ", "THRAKE",
            "KENTRIKE MAKEDONIA  ", "KRETE               ",
            "NESOI AIGAIOU       ")

wd_trans <- c("GR11", "GR03", "GR07", "GR06", "GR02", "GR09", "GR01", "GR04",
              "GR05", "GR08", "GR12", "GR10", "GR13", "GR14")

expect_equal(hydro_translate(wd_raw, "division"), wd_trans)

})