# hydroscoper 0.2.1 (Release date: 2018-01-10)

* General 

  - This is a minor update. All the functions return now a tibble.


# hydroscoper 0.2.0 (Release date: 2018-01-09)

* General 

  - This is a major update. All the functions were rewritten utilizing the Enhydris API.
  - The included data in the package cover all Hydroscope's databases.
  - Added vignettes  "Getting Hydroscope's data" and "Hydroscope's stations with available data". Removed the vignette "Using hydroscoper to get stations' and time-series' data".
  - Added package documentation page.

* New functionality:

  - `get_instruments()` returns a data frame with the instruments' data.
  - `get_water_basins()` returns a data frame with the Water Basins' data.
  - `get_water_divisions()` returns a data frame with the Water Divisions' data.
  - `get_political_divisions()` returns a data frame with the Political Divisions' data.
  - `get_variables()` returns a data frame with the Variables' data.
  - `get_units_of_measurement()` returns a data frame with the Units' data.
  - `get_time_steps()` returns a data frame with the Time Steps' data.
  - `get_owners()` returns a data frame with the Owners' data.
  - `get_instruments_type()`returns a data frame with the Instruments' type data.
  - `get_station_type()` returns a data frame with the Water Basins data.
  - `get_database()` returns a data frame with the Water Basins data.
  - `hydro_coords` returns a data frame with the stations' longitudes and latitudes using as input the variable `point` from `get_stations` function.
  - `hydro_translate()` translates various Greek terms to English.

* Changes

  - `get_stations` and `get_timeseries` use the Enhydris API and are considerably faster, because the older versions used web scrapping.

* Defuncs

  - `get_coords` has been removed from the package. Please use `hydro_coords` to convert Hydroscope's points` raw format to a tidy data frame.

--------------------------------------------------------------------------------

# hydroscoper 0.1.0 (Release date: 2017-12-22)

* Initial submission to CRAN.



