hydroscoper
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/ropensci/hydroscoper.svg?branch=master)](https://travis-ci.org/ropensci/hydroscoper)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/ropensci/hydroscoper?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/hydroscoper)
[![codecov](https://codecov.io/github/ropensci/hydroscoper/branch/master/graphs/badge.svg)](https://codecov.io/gh/ropensci/hydroscoper)
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.4-6666ff.svg)](https://cran.r-project.org/)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/hydroscoper)](https://cran.r-project.org/package=hydroscoper)
[![packageversion](https://img.shields.io/badge/Package%20version-1.1.1-orange.svg?style=flat-square)](https://github.com/ropensci/hydroscoper)
[![](https://cranlogs.r-pkg.org/badges/grand-total/hydroscoper)](http://cran.rstudio.com/web/packages/hydroscoper/index.html)
[![ropensci](https://badges.ropensci.org/185_status.svg)](https://github.com/ropensci/onboarding/issues/185)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1196540.svg)](https://doi.org/10.5281/zenodo.1196540)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00625/status.svg)](https://doi.org/10.21105/joss.00625)

<img src="https://github.com/ropensci/hydroscoper/raw/master/man/figures/hydroscoper_hex.png" align = "right" width = 120/>

`hydroscoper` is an R interface to the Greek National Data Bank for
Hydrological and Meteorological Information,
[Hydroscope](http://www.hydroscope.gr/). For more details checkout the
package’s [website](https://ropensci.github.io/hydroscoper/) and the
vignettes:

  - [An introduction to
    `hydroscoper`](https://ropensci.github.io/hydroscoper/articles/intro_hydroscoper.html)
    with details about the Hydroscope project and the package.
  - [Using `hydroscoper`’s data
    sets](https://ropensci.github.io/hydroscoper/articles/stations_with_data.html)
    with a simple example of how to use the package’s internal data
    sets.

## Installation

Install the stable release from CRAN with:

``` r
install.packages("hydroscoper")
```

You can install the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("ropensci/hydroscoper")
```

## Using hydroscoper

The functions that are provided by `hydroscoper` are:

  - `get_stations, get_timeseries, ..., etc.` family functions, to
    retrieve tibbles with Hydroscope’s data for a given data source.
  - `get_data`, to retrieve a tibble with time series’ values.  
  - `hydro_coords`, to convert Hydroscope’s points’ raw format to a
    tibble.
  - `hydro_translate` to translate various terms and names from Greek to
    English.

The data sets that are provided by `hydroscoper` are:

  - `stations` a tibble with stations’ data from Hydroscope.
  - `timeseries` a tibble with time series’ data from Hydroscope.
  - `greece_borders` a tibble with the borders of Greece.

## Example

This is a minimal example which shows how to get the station’s
[200200](\(http://kyy.hydroscope.gr/stations/d/200200/\)) precipitation
time series [56](http://kyy.hydroscope.gr/timeseries/d/56/) from the
[kyy](http://kyy.hydroscope.gr) sub-domain.

Load libraries and get data:

``` r
library(hydroscoper)
library(tibble)
library(ggplot2)

ts_raw <- get_data(subdomain = "kyy", time_id = 56)
ts_raw
#> # A tibble: 147,519 x 3
#>    date                value comment
#>    <dttm>              <dbl> <chr>  
#>  1 1985-05-06 08:00:00     0 1      
#>  2 1985-05-06 08:30:00     0 1      
#>  3 1985-05-06 09:00:00     0 1      
#>  4 1985-05-06 09:30:00     0 1      
#>  5 1985-05-06 10:00:00     0 1      
#>  6 1985-05-06 10:30:00     0 1      
#>  7 1985-05-06 11:00:00     0 1      
#>  8 1985-05-06 11:30:00     0 1      
#>  9 1985-05-06 12:00:00     0 1      
#> 10 1985-05-06 12:30:00     0 1      
#> # ... with 147,509 more rows
```

Let’s create a plot:

``` r
ggplot(data = ts_raw, aes(x = date, y = value))+
  geom_line()+
  labs(title= "30 min precipitation for station 200200",
       x="Date", y = "Rain height (mm)")+
  theme_classic()
```

![](man/figures/README-plot_time_series-1.png)<!-- -->

## Meta

  - Bug reports, suggestions, and code are welcome. Please see
    [Contributing](/CONTRIBUTING.md).
  - Licence:
      - All code is licensed MIT.
      - All data are from the public data sources in
        <http://www.hydroscope.gr/>.
  - To cite `hydroscoper` please
    use:

<!-- end list -->

    Vantas Konstantinos, (2018). hydroscoper: R interface to the Greek National Data Bank for
    Hydrological and Meteorological Information. Journal of Open Source Software,
    3(23), 625 DOI:10.21105/joss.00625

or the BibTeX entry:

    @Article{kvantas2018,
    author = {Konstantinos Vantas},
    title = {{hydroscoper}: R interface to the Greek National Data Bank for Hydrological and Meteorological Information},
    doi = {10.21105/joss.00625},
    year = {2018},
    month = {mar},
    publisher = {The Open Journal},
    volume = {2},
    number = {23},
    journal = {The Journal of Open Source Software}
    }

## References

[Hydroscope](http://www.hydroscope.gr/)

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
