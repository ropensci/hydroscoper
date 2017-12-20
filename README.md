
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

This is a basic example which shows you how to get the stations list from the Hydroscope's Ministry of Environment and Energy database (subdomain **kyy**):

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

With the following code you can get the coordinates and the elevation for the stations from the Water Division of Crete, GR13:

``` r
library(plyr)
crete_stations <-subset(stations, WaterDivisionID == "GR13")
crete_coords <- ldply(crete_stations$StationID, function(x) {
  get_coords(subdomain = "kyy", stationID = x)})
#> Warning in value[[3L]](cond): Failed to parse url: http://kyy.hydroscope.gr/stations/d/501032/
head(crete_coords)
#>   StationID     Long      Lat Elevation
#> 1    200280 24.45425 35.24414     298.6
#> 2    501032       NA       NA        NA
#> 3    200292 25.48357 35.16758     836.4
#> 4    501054 24.13917 35.44500     850.0
#> 5    200288 25.03400 35.14504     563.6
#> 6    501033 25.71472 35.19940      30.0
```

Time series list
----------------

To get the time series list in a dataframe from the station **200292** you can use the following code:

``` r

ts_data <- get_timeseries(subdomain = "kyy", stationID = 200292)
ts_data[c("TimeSeriesID", "Variable", "TimeStep", "Unit", "StartDate","EndDate")]
#>   TimeSeriesID   Variable TimeStep Unit           StartDate
#> 1         1023       snow      day   mm 1954-09-01 08:00:00
#> 2         1024 wind_direc variable    ° 1964-05-01 08:00:00
#> 3         1022   rainfall      day   mm 1954-09-01 08:00:00
#> 4           78   rainfall    30min   mm 1954-08-30 07:30:00
#>               EndDate
#> 1 1996-12-31 08:00:00
#> 2 1996-12-31 08:00:00
#> 3 2001-08-31 01:00:00
#> 4 1996-12-29 22:00:00
```

Raw data
--------

You can get the time series **1022** rainfall data using:

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
