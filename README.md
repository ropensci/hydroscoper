
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/kvantas/hydroscoper.svg?branch=master)](https://travis-ci.org/kvantas/hydroscoper) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/kvantas/hydroscoper?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/hydroscoper) [![codecov](https://codecov.io/github/kvantas/hydroscoper/branch/master/graphs/badge.svg)](https://codecov.io/gh/kvantas/hydroscoper)

hydroscoper
===========

The goal of **hydroscoper** is to provide an interface to the Greek National Databank for Hydrological and Meteorological Information, [Hydroscope](http://www.hydroscope.gr/). It provides functions for downloading stations and time series data.

The stations and time series data in Hydroscope are in Greek, so this package transliterates the Unicode text to Latin, and translates various Greek terms to English. Finally, the **hydroscoper** provides a function to convert raw time series' data into a tidy dataframe.

Installation
------------

You can install **hydroscoper** from github with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/hydroscoper")
```

Stations list
-------------

This is a basic example which shows you how to get the stations list from the Hydroscope's Ministry of Environment and Energy database (subdomain *kyy*):

``` r
library(hydroscoper)
stations <- get_stations(subdomain = "kyy")
head(stations[c("StationID", "WaterDivisionID", "Name", "Owner", "Type")])
#>   StationID WaterDivisionID          Name   Owner          Type
#> 1    501062            GR11       Peirama   other meteo_station
#> 2    200251            GR12          ABAS min_env meteo_station
#> 3    200280            GR13 AG. BASILEIOS min_env meteo_station
#> 4    501032            GR13 AG. BASILEIOS min_rur   stream_gage
#> 5    200171            GR04   AG. BLASIOS min_env meteo_station
#> 6    200292            GR13  AG. GEORGIOS min_env meteo_station
```

Stations coordinates
--------------------

With the following code you can get the coordinates and the elevation for the meteorological stations from Ministry of Environment and Energy (min\_env) in the Water Division of Crete, GR13:

``` r
library(plyr)
crete_stations <-subset(stations, WaterDivisionID == 'GR13' & Owner == 'min_env')
crete_coords <- ldply(crete_stations$StationID, function(x) {
  get_coords(subdomain = "kyy", stationID = x)})
head(crete_coords)
#>   StationID     Long      Lat Elevation
#> 1    200280 24.45425 35.24414     298.6
#> 2    200292 25.48357 35.16758     836.4
#> 3    200288 25.03400 35.14504     563.6
#> 4    200281 24.58291 35.16440     511.7
#> 5    200291 25.16082 35.23747     392.3
#> 6    200282 24.45970 35.30145     373.3
```

Time series list
----------------

To get the time series list in a dataframe from a specific station you can use the following code:

``` r

ts_data <- get_timeseries(subdomain = "kyy", stationID = 200292)
ts_data
#>   TimeSeriesID Name   Variable TimeStep Unit
#> 1         1023            snow      day   mm
#> 2         1024      wind_direc variable    °
#> 3         1022        rainfall      day   mm
#> 4           78        rainfall    30min   mm
#>                                                                                                                                                    Remarks
#> 1                                                                                                                                                         
#> 2                                                                                                                                                         
#> 3 MONADES (mm)\n\nTa dedomena apo 1997-09-01 00:00 os 2001-08-31 00:00 psephiopoiethekan apo Lekka kai eisechthesan ste base dedomenon to Septembrio 2013.
#> 4                                                                                                                                             MONADES (mm)
#>   Instrument           StartDate             EndDate StationID
#> 1   20029203 1954-09-01 08:00:00 1996-12-31 08:00:00    200292
#> 2   20029204 1964-05-01 08:00:00 1996-12-31 08:00:00    200292
#> 3   20029201 1954-09-01 08:00:00 2001-08-31 01:00:00    200292
#> 4   20029202 1954-08-30 07:30:00 1996-12-29 22:00:00    200292
```

Raw data
--------

With the following code you can get the time series values from using a time series ID

``` r
ts_raw <- get_data(subdomain = "kyy", timeID = 1022)
```

Let's create a plot for the rainfall data:

``` r
suppressPackageStartupMessages(library(ggplot2))
ggplot(data = ts_raw, aes(x = Date, y = Value))+
  geom_line()+
  labs(title="Daily rainfall for station 200292",
       x="Date", y = "Rain (mm)")+
  theme_classic()
```

![](README-plot%20data-1.png)
