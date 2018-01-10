---
title: 'hydroscoper: R interface to the Greek National Data Bank for 
Hydrological and Meteorological Information'
authors:
- affiliation: 1
  name: Konstantinos Vantas
  orcid: 0000-0001-6387-8791
date: "10 Jan 2017"
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
  name: Aristotle University of Thessaloniki
---

# Summary

The Greek National Data bank for Hydrological and Meteorological Information, Hydroscope [@hydroscope2018] is the result of long-standing efforts by numerous Greek scientists in collaboration with various companies and associations [@vafiadis1994hydroscope]. Its main purpose is the formation of the basic infrastructure for the implementation of the European Community Directives: a) 2000/60/EC, about the establishing of a framework for Community action in the field of water policy and c) 2007/60/EC, about the assessment and management of flood risks.
Hydroscope provides several national data sources in HTML and plain text files, via a web interface, using the Enhydris database system [@christofides2011enhydris]. These data are well structured but are in Greek, thus limiting their usefulness. Fully reproducible research [@peng2011reproducible], can be tedious and error-prone using Hydroscope's web interface. On the contrary, using the Enhydris API for reproducibility requires external programs and scripting to import the data.

_hydroscoper_ provides functionality for automatic retrieval and parsing, translation and transliteration of Hydroscope's data to English, for use in R [@Rbase].  The main functions that can be utilized are a) a family of functions, `get_stations`, `get_timeseries`, `get_data`, etc. to easily download json files to tidy data frames [@Wickham2014] and b) the function `hydro_translate` to translate various Greek terms and names, such as meteorological variables, units and owners, to English. The internal databases of the package can be used to run queries on the Hydroscope's stations and time series, reducing the time needed for downloading and data wrangling [kandel2011research], as these data are rarely modificated.

The data can support a) engineers, manufacturers and consultants, for the development of water resources and environmental studies and the implementation of related projects [@chow1988applied], b) researchers and other scientists to forward their studies using the R environment for statistical computing and graphics [@vantas_sid2017] and c) Greek organizations to submit data and reports to the European Union for the Implementation of the Water Framework Directive (2000-2027) [@WFD].

# References

