---
title: 'hydroscoper: R interface to the Greek National Data Bank for 
Hydrological and Meteorological Information'
authors:
- affiliation: 1
  name: Konstantinos Vantas
  orcid: 0000-0001-6387-8791
date: "22 Dec 2017"
output:
  html_document: default
  pdf_document: default
bibliography: paper.bib
tags:
- R
- tidy data
- hydrology
- Meteorology
- Greece
affiliations:
- index: 1
  name: Aristotle University of Thessaloniki
---

# Summary

The  Greek National Databank for Hydrological and Meteorological Information, Hydroscope, provides several national data sources in HTML and plain text files, via a web interface to multiple data bases [@hydroscope, @enidrys].
The data are structured as tables and space separated text files, but are in Greek, thus limiting their usefulness. Also, the ability to run querries in Hydroscope is problematic.
_hydroscoper_ in an R package [@R] that provides  functionality for automatic retrieval and parsing of data and translation and transliteration of Greek terms and names from Hydroscope. 
The available functions that can be utilized from _hydroscoper_ are `get_stations`, `get_coords`, `get_timeseries` and `get_data` to easily
download data from Hydroscope and create a tidy dataframe [@tidy]. The internal databases of the package can be used to run querries on the stations and timeseries values, reducing the time needed to gather information, as these data are rarely modificated.

These data support a) enigneers, manufacturers and consultants, for the 
development of water resources and environmental studies and the implementation 
of related projects, b)researchers and other scientists to promote their studies
and c) Greek organisations to submit data, reports  and other deliverables to  the European Union and other domestic and international organizations.


# References

