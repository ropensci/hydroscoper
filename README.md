
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
crete_coords
#>        ID     Long      Lat Elevation
#> 1  200280 24.45425 35.24414     298.6
#> 2  200292 25.48357 35.16758     836.4
#> 3  200288 25.03400 35.14504     563.6
#> 4  200281 24.58291 35.16440     511.7
#> 5  200291 25.16082 35.23747     392.3
#> 6  200282 24.45970 35.30145     373.3
#> 7  200283 24.66241 35.24278     332.2
#> 8  200297 24.15358 35.45939       6.3
#> 9  200296 23.95707 35.40594     183.3
#> 10 200298 25.15380 35.04143     224.9
#> 11 200289 25.38611 35.09526     438.6
#> 12 200276 24.18705 35.34493     271.7
#> 13 200284 24.33280 35.33222     100.0
#> 14 200293 26.21945 35.11235     224.1
#> 15 200294 25.65611 35.07620     502.2
#> 16 200285 24.79503 35.31258     551.5
#> 17 200278 23.74697 35.33133     436.6
#> 18 200277 23.96612 35.39890     200.0
#> 19 200286 24.73157 35.17029     460.7
#> 20 200287 24.70429 35.37428      53.7
#> 21 200295 23.93114 35.47415      42.3
#> 22 200290 25.08788 35.00749     322.4
#> 23 200279 23.66429 35.36214     515.2
```
