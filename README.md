
<!-- README.md is generated from README.Rmd. Please edit that file -->
hydroscoper
===========

The goal of **hydroscoper** is to provide an interface to the Greek National Databank for Hydrological and Meteorological Information, [Hydroscope](http://kyy.hydroscope.gr/). It provides functions for downloading stations and timeseries data.

The stations and timeseries data in Hydroscope are in Greek, so this package transforms the Unicode text to Latin, and translates various Greek terms to English. Finally, the **hydroscoper** provides a function to convert raw timeseries' data into a tidy dataframe.

Installation
------------

You can install **hydroscoper** from github with:

``` r
# install.packages("devtools")
# devtools::install_github("kvantas/hydroscoper")
```

Stations list
-------------

This is a basic example which shows you how to get the stations list from the Hydroscope database:

``` r
library(hydroscoper)
stations <- get_stations()
head(stations[c("ID", "WaterDivisionID", "Name", "Owner", "Type")])
#>       ID WaterDivisionID          Name Owner         Type
#> 1 501062            EL11       Peirama Other MeteoStation
#> 2 200251            EL12          ABAS   MEE MeteoStation
#> 3 200280            EL13 AG. BASILEIOS   MEE MeteoStation
#> 4 501032            EL13 AG. BASILEIOS Other   StreamGage
#> 5 200171            EL04   AG. BLASIOS   MEE MeteoStation
#> 6 200292            EL13  AG. GEORGIOS   MEE MeteoStation
```

The abbreviations in the Owner column are:

-   MEE: Ministry of Environment and Energy
-   NOA: National Observatory of Athens
-   Other owners are Universities, Prefectures of Greece etc.

Stations coordinates
--------------------

With the following code you can get the coordinates and the elevation for the meteorological stations from Ministry of Environment and Energy in the Water Division of Crete, EL13:

``` r
library(plyr)
crete_stations <-subset(stations, WaterDivisionID == 'EL13' & Owner == 'MEE')
crete_coords <- ldply(crete_stations$ID, function(x) {get_coords(x)})
head(crete_coords)
#>       ID     Long      Lat Elevation
#> 1 200280 24.45425 35.24414     298.6
#> 2 200292 25.48357 35.16758     836.4
#> 3 200288 25.03400 35.14504     563.6
#> 4 200281 24.58291 35.16440     511.7
#> 5 200291 25.16082 35.23747     392.3
#> 6 200282 24.45970 35.30145     373.3
```
