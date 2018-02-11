# hydroscoper 0.2.3 (Release date: 2018-02-11)

* General

  - This is a major update. All the functions were rewritten utilizing the Enhydris API.
  - The included data in the package cover all Hydroscope's databases.
  - Added vignettes  "Hydroscoper's data-sets".
  - Added package documentation page.
  - Use pingr package to check if a sub-domain is alive.
  - All the functions return a tibble.
  - Added `greece_borders` dataset.

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

  - `get_stations` and `get_timeseries` use the Enhydris API and are considerably faster.
  - `get_data` uses lower case variable naming: `dates, values, comments`

* Defuncs

  - `get_coords` has been removed from the package. Please use `hydro_coords` to convert Hydroscope's points` raw format to a tidy data frame.

--------------------------------------------------------------------------------

# hydroscoper 0.1.0 (Release date: 2017-12-22)

* Initial submission to CRAN.



