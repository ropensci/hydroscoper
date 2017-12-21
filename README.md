hydroscoper
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/kvantas/hydroscoper.svg?branch=master)](https://travis-ci.org/kvantas/hydroscoper)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/kvantas/hydroscoper?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/hydroscoper)
[![codecov](https://codecov.io/github/kvantas/hydroscoper/branch/master/graphs/badge.svg)](https://codecov.io/gh/kvantas/hydroscoper)
[![DOI](https://zenodo.org/badge/114094911.svg)](https://zenodo.org/badge/latestdoi/114094911)

`hydroscoper` is an R interface to the Greek National Databank for
Hydrological and Meteorological Information,
[Hydroscope](http://www.hydroscope.gr/). It covers most of Hydroscope’s
sources and provides functions to transform these untidy data sets into
tidy dataframes.

The Hydroscope’s data sets are in Greek, thus limiting their usefulness.
`hydroscoper` transliterates the Greek Unicode text to Latin, and
translates various Greek terms to English.

## Data sources in hydroscoper

  - Ministry of Environment and Energy, <http://kyy.hydroscope.gr/>
  - Ministry of Rural Development and Food,
    <http://ypaat.hydroscope.gr/>
  - National Meteorological Service, <http://emy.hydroscope.gr/>

The front end for the data sources of Greek Public Power Corporation,
<http://deh.hydroscope.gr/>, uses an old format and it is not currently
supported.

Note that only the two Ministries allow to download time series values
freely.

## Installation

You can install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/hydroscoper")
```

## Using hydroscoper

The available functions that are provided by `hydroscoper` are:

  - `get_stations` to retrieve a tidy dataframe with stations’ data for
    a given data source.
  - `get_coords` to retrieve the coordinates and elevation for a given
    station.
  - `get_timeseries` to retriece a tidy dataframe with a station’s time
    series.
  - `get_data` to retriece a tidy dataframe with a time series’ values.

## Example

This is a basic example which shows you how to get a dataframe with
stations from the Ministry of Environment and Energy:

``` r
library(hydroscoper)
stations <- get_stations(subdomain = "kyy")
head(stations[c("StationID", "WaterDivisionID", "Name", "Owner", "Type")])
#>   StationID WaterDivisionID          Name   Owner          Type
#> 1    501062            GR11       Peirama   other meteo_station
#> 2    200251            GR12          ABAS min_env meteo_station
#> 3    200280            GR13 AG. BASILEIOS min_env meteo_station
#> 4    501032            GR13 AG. BASILEIOS min_rur  stream_gauge
#> 5    200171            GR04   AG. BLASIOS min_env meteo_station
#> 6    200292            GR13  AG. GEORGIOS min_env meteo_station
```

Using the above data you can get the coordinates and the elevation for a
specific station, **200251**:

``` r
crds <-  get_coords(subdomain = "kyy", stationID = 200251)
crds
#>   StationID     Long    Lat Elevation
#> 1    200251 25.91659 40.932       114
```

To get the time series from the same station run:

``` r

ts_data <- get_timeseries(subdomain = "kyy", stationID = 200251)
ts_data[c("TimeSeriesID", "Variable", "TimeStep", "Unit", "StartDate","EndDate")]
#>   TimeSeriesID   Variable TimeStep Unit           StartDate
#> 1          913       snow      day   mm 1960-11-01 08:00:00
#> 2          914 wind_direc variable    ° 1967-01-01 08:00:00
#> 3          912   rainfall      day   mm 1960-11-01 08:00:00
#> 4         1451   rainfall variable   mm                <NA>
#> 5         2173   rainfall    month   mm 1980-10-01 00:00:00
#>               EndDate
#> 1 1997-03-31 09:00:00
#> 2 1997-03-31 09:00:00
#> 3 2011-04-30 09:00:00
#> 4                <NA>
#> 5 2001-03-01 00:00:00
```

You can get the time series **912** to a tidy dataframe with:

``` r
df <- get_data(subdomain = "kyy", timeID = 912)
```

Let’s create a plot for these data:

``` r
suppressPackageStartupMessages(library(ggplot2))
ggplot(data = df, aes(x = Date, y = Value))+
  geom_line()+
  labs(title="Dailly rainfall data for station 200251",
       x="Date", y = "Rain (mm)")+
  theme_classic()
```

![](man/figures/README-plot_timeseries-1.png)<!-- -->

## Meta

  - Please [report any issues or
    bugs](https://github.com/kvantas/hydroscoper/issues).

  - Licence:
    
      - All code is licenced MIT
      - All data are from the public data sources in
        <http://www.hydroscope.gr/>

  - To cite `hydroscoper`, please
        use:
    
        Konstantinos Vantas (2017). hydroscoper: Interface to Hydroscope. R package version 0.1.0.
        https://github.com/kvantas/hydroscoper
    
    A BibTeX entry for LaTeX users is
    
    ``` 
     @Manual{,
      title = {hydroscoper: Interface to Hydroscope},
      author = {Konstantinos Vantas},
      year = {2017},
      note = {R package version 0.1.0},
      url = {https://github.com/kvantas/hydroscoper},
    }
    ```

  - Please note that this project is released with a [Contributor Code
    of Conduct](/CONDUCT.md). By participating in this project you agree
    to abide by its terms.

## References

[Hydroscope](http://www.hydroscope.gr/)
