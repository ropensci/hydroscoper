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


test_that("Organizations are tranlated", {

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
