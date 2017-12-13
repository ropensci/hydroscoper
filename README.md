
<!-- README.md is generated from README.Rmd. Please edit that file -->
hydroscoper
===========

The goal of **hydroscoper** is to provide an interface to the greek National Databank for Hydrological and Meteorological Information, [Hydroscope](http://kyy.hydroscope.gr/), with functions for stations, timeseries and raw data downloading.

The stations and timeseries lists in Hydroscope are in greek, so this package transforms the Unicode text to Latin. Also, translates various terms in english. Finally, the **hydroscoper** provides a function to get raw timeseries data into a tidy dataframe.

Installation
------------

You can install hydroscoper from github with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/hydroscoper")
```

Stations list
-------------

This is a basic example which shows you how to get the stations list from the Hydroscope database:

``` r
library(hydroscoper)
stations <- get_stations()
head(stations[c("ID", "WaterDivisionID", "Name", "Owner", "Type")])
#>       ID WaterDivisionID          Name Owner         Type
#> 1 501062            EL11       Peirama Other Meteorogical
#> 2 200251            EL12          ABAS   MEE Meteorogical
#> 3 200280            EL13 AG. BASILEIOS   MEE Meteorogical
#> 4 501032            EL13 AG. BASILEIOS Other   StreamGage
#> 5 200171            EL04   AG. BLASIOS   MEE Meteorogical
#> 6 200292            EL13  AG. GEORGIOS   MEE Meteorogical
```

The abbreviations in the Owner column are:

-   MEE: Ministry of Environment and Energy
-   NOA: National Observatory of Athens
-   Other owners are Universities, Prefectures of Greece etc.
