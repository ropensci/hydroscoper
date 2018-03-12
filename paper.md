---
title: 'hydroscoper: R interface to the Greek National Data Bank for Hydrological and Meteorological Information'
authors:
- affiliation: 1
  name: Konstantinos Vantas
  orcid: 0000-0001-6387-8791
date: "01 Mar 2017"
output:
  html_document: default
  pdf_document: default
bibliography: paper.bib
tags:
- R
- tidy data
- Hydrology
- Meteorology
- Greece
affiliations:
- index: 1
  name: Faculty of Engineering, Aristotle University of Thessaloniki, Greece
---

# Summary

The Greek National Data bank for Hydrological and Meteorological Information, Hydroscope [@hydroscope2018], is the result of long-standing efforts by numerous Greek scientists in collaboration with various companies and associations. Its main purpose is the formation of the basic infrastructure for the implementation of the European Community Directives 2000/60/EC (i.e. establishment of a framework for Community action in the field of water policy) and 2007/60/EC, (i.e. assessment and management of flood risks).

Hydroscope offers several national data sources in HTML and plain text files via a web interface, using the Enhydris database system [@christofides2011enhydris]. These data are well structured but are in Greek, thus limiting their usefulness. Furthermore, fully reproducible research [@peng2011reproducible] can be tedious and error-prone using Hydroscope's web interface. On the contrary, using the Enhydris API for reproducibility requires external programs and scripting to import the data.

`hydroscoper` [@hydroscoper2018] provides functionality for automatic retrieval and translation of Hydroscope's data to English for use in R [@Rbase]. The main functions that can be utilized is the family of functions, `get_stations`, `get_timeseries`, `get_data`, etc., to easily download JSON and TXT files as tidy data frames [@Wickham2014]. The internal databases of the package can be used to run queries on the available stations and time series, reducing the time needed for downloading and data wrangling [@kandel2011research], as these data are rarely modified.

The data have many applications. In general, availability of meteorological and hydrological information is essential for water resources management, water quality assessment and global change studies [@vafiadis1994hydroscope]. Also, these data can be used by researchers to forward their studies when specific requirements of time series are required, such as the estimation of rainfall erosivity [@vantas_sid2017]. Finally, the data are crucial to Greek organizations for the implementation of the Water Framework Directive 2000-2027 [@WFD].


# References

