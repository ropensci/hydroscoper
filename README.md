hydroscoper
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/kvantas/hydroscoper.svg?branch=master)](https://travis-ci.org/kvantas/hydroscoper)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/kvantas/hydroscoper?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/hydroscoper)
[![codecov](https://codecov.io/github/kvantas/hydroscoper/branch/master/graphs/badge.svg)](https://codecov.io/gh/kvantas/hydroscoper)
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.4.0-6666ff.svg)](https://cran.r-project.org/)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/hydroscoper)](https://cran.r-project.org/package=hydroscoper)
[![packageversion](https://img.shields.io/badge/Package%20version-0.1.0.9000-orange.svg?style=flat-square)](commits/master)
[![DOI](https://zenodo.org/badge/114094911.svg)](https://zenodo.org/badge/latestdoi/114094911)

<img src="man/figures/hydroscoper_hex.png" align="right" height="220"/>

`hydroscoper` is an R interface to the Greek National Data Bank for
Hydrological and Meteorological Information,
[Hydroscope](http://www.hydroscope.gr/). Hydroscope is the result of
long-standing efforts by numerous Greek scientists in collaboration with
various companies and associations. It was implemented in three phases,
funded by the Ministry of Development, the Ministry of Environment and
Energy and the European Union.

Hydroscope, provides several national data sources from various
organisations via a web interface. Each participating organisation keeps
its data on its own server using the Enhydris database system for the
storage and management of hydrological and meteorological data. These
organisations are:

  - Ministry of Environment and Energy.
  - Ministry of Rural Development and Food.
  - National Meteorological Service.
  - National Observatory of Athens.
  - Greek Prefectures.
  - Public Power Corporation.

The data are structured as tables and space separated text files, but
are in Greek, thus limiting their usefulness.

`hydroscoper` covers Hydroscope’s data sources using the [Enhydris
API](http://enhydris.readthedocs.io/en/latest/index.html) and provides
functions to:

1.  Transform the available tables and data sets into tidy data frames.
2.  Transliterate the Greek Unicode names to Latin.
3.  Translate various Greek terms to English.

## Data sources

  - Ministry of Environment and Energy, National Observatory of Athens
    and Greek Prefectures, <http://kyy.hydroscope.gr/>
  - Ministry of Rural Development and Food, <http://ypaat.hydroscope.gr>
  - National Meteorological Service, <http://emy.hydroscope.gr>
  - Greek Public Power Corporation, <http://deh.hydroscope.gr>

Note that only the two Ministries allow to download time series values
freely.

## Installation

Install the stable release from CRAN with:

``` r
install.packages("hydroscoper")
```

You can install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/hydroscoper")
```

## Using hydroscoper

The available functions that are provided by `hydroscoper` are:

  - `get_stations` to retrieve a tidy data frame with stations’ data for
    a given data source.
  - `get_timeseries` to retrieve a tidy data frame with a time series’
    data for a given data source.
  - `get_data` to retrieve a tidy data frame with a time series’ values.

## Example

This is a basic example which shows you how to get a data frame with
stations from the Ministry of Environment and Energy:

``` r
library(hydroscoper)
stations <- get_stations(subdomain = "kyy")
tail(stations)
#>     station_id                    last_modified           name water_basin
#> 420     200241 2013-09-24T12:55:22.704612+03:00        CHRANOI        1011
#> 421     200106 2013-09-24T12:55:22.710704+03:00    CHRYSOMELIA        1184
#> 422     200247 2013-09-24T12:55:22.717817+03:00    CHRYSOUPOLE        1251
#> 423     200146 2013-09-24T12:55:22.724113+03:00          PSARI        1037
#> 424     501044 2013-11-28T11:06:51.578776+02:00 PSYCHRO PEGADI          NA
#> 425     200353 2013-09-24T12:55:22.731119+03:00    ORAIOKASTRO        1222
#>     water_division political_division altitude     long      lat
#> 420            501                410    508.4 22.03255 37.32187
#> 421            508                417    911.1 21.50098 39.60826
#> 422            512                436     20.4 24.70687 40.98499
#> 423            502                408    811.1 22.52671 37.86526
#> 424            513                 NA    948.0 24.04400 35.39400
#> 425            510                427     71.5 22.93811 40.68622
```

To get the time series from the same station run:

``` r

ts_data <- get_timeseries(subdomain = "kyy")
tail(ts_data)
#>       id                    last_modified name name_alt hidden precision
#> 1608 739                             <NA>                FALSE        NA
#> 1609 464 2013-10-10T13:33:06.168457+03:00                FALSE        NA
#> 1610 741                             <NA>                FALSE        NA
#> 1611 742                             <NA>                FALSE        NA
#> 1612 910                             <NA>                FALSE        NA
#> 1613 911                             <NA>                FALSE        NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                           remarks
#> 1608                                                                                                                                                                                                                                                                                                                                                                                                                             
#> 1609 <U+03A4>a ded<U+03BF>µ<U+03AD><U+03BD>a ap<U+03CC> 2002-01-01 00:00 <U+03C9><U+03C2> 2009-12-31 00:00 <U+03C8><U+03B7>f<U+03B9><U+03BF>p<U+03BF><U+03B9><U+03AE><U+03B8><U+03B7><U+03BA>a<U+03BD> ap<U+03CC> ENVECO <U+03BA>a<U+03B9> e<U+03B9>s<U+03AE><U+03C7><U+03B8><U+03B7>sa<U+03BD> st<U+03B7> ß<U+03AC>s<U+03B7> ded<U+03BF>µ<U+03AD><U+03BD><U+03C9><U+03BD> t<U+03BF> Sept<U+03AD>µß<U+03C1><U+03B9><U+03BF> 2013.
#> 1610                                                                                                                                                                                                                                                                                                                                                                                                                             
#> 1611                                                                                                                                                                                                                                                                                                                                                                                                                             
#> 1612                                                                                                                                                                                                                                                                                                                                                                                                                             
#> 1613                                                                                                                                                                                                                                                                                                                                                                                                                             
#>      remarks_alt timestamp_rounding_minutes timestamp_rounding_months
#> 1608                                     NA                        NA
#> 1609                                     NA                        NA
#> 1610                                     NA                        NA
#> 1611                                     NA                        NA
#> 1612                                     NA                        NA
#> 1613                                     NA                        NA
#>      timestamp_offset_minutes timestamp_offset_months
#> 1608                       NA                      NA
#> 1609                        0                       0
#> 1610                        0                       0
#> 1611                        0                       0
#> 1612                        0                       0
#> 1613                       NA                      NA
#>                                       datafile            start_date_utc
#> 1608 http://kyy.hydroscope.gr/media/0000000739 1951-01-04T08:00:00+02:00
#> 1609 http://kyy.hydroscope.gr/media/0000000464 1950-05-01T08:00:00+02:00
#> 1610 http://kyy.hydroscope.gr/media/0000000741 1987-06-01T09:00:00+03:00
#> 1611 http://kyy.hydroscope.gr/media/0000000742 1975-01-06T08:00:00+02:00
#> 1612 http://kyy.hydroscope.gr/media/0000000910 1950-09-01T08:00:00+02:00
#> 1613 http://kyy.hydroscope.gr/media/0000000911 1950-09-04T08:00:00+02:00
#>                   end_date_utc gentity variable unit_of_measurement
#> 1608 1998-05-29T09:00:00+03:00  200194        2                   1
#> 1609 2009-12-31T00:00:00+02:00  200119       52                   3
#> 1610 1995-07-31T09:00:00+03:00  200195       14                   3
#> 1611 1997-06-30T09:00:00+03:00  200195       12                   3
#> 1612 1997-08-31T09:00:00+03:00  200249       52                   3
#> 1613 1974-08-31T08:00:00+02:00  200249        2                   1
#>      time_zone instrument time_step interval_type
#> 1608         1   20019403        NA            NA
#> 1609         1   20011902         5            NA
#> 1610         1   20019505         5            NA
#> 1611         1   20019505         5            NA
#> 1612         1   20024903         5            NA
#> 1613         1   20024904        NA            NA
```

You can get the time series **912** to a tidy data frame with:

``` r
df <- get_data(subdomain = "kyy", time_id = 912)
```

Let’s create a plot for these data:

``` r
library(ggplot2)
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
    
      - All code is licenced MIT.
      - All data are from the public data sources in
        <http://www.hydroscope.gr/>.

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
