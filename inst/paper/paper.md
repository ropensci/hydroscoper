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

The  Greek National Databank for Hydrological and Meteorological Information, 
Hydroscope, provides several national data sources via a web interface 
[@hydroscope], with each participating organisation keeping its data on its own
server. These organisations are: The Ministry of Environment and Energy, the 
Ministry of Rural Development and Food, the National Meteorological Service,
the National Observatory of Athens, Greek Prefectures and the Public Power 
Corporation. The Hydroscope's data sets are in Greek, thus limiting their 
usefulness, and raw time series values  are well structured as space seperated 
text files.
_hydroscoper_ provides functionality for a) automatic retrieval and parsing [@xml], 
translation and transliteration [@sringi] of the stations' and time series' tables 
b) automatic retrieval and parsing of the available time series' values, into 
data frames for use in R[@R-base].
The available functions that are provided by _hydroscoper_ are `get_stations`,
`get_coords`, `get_timeseries` and `get_data` which can be utilized to easily
download data from Hydroscope and create tidy data frames [@Wickham2014].
These data support a) enigneers, manufacturers and consultants, for the 
development of water resources and environmental studies and the implementation 
of related projects, b)researchers and other scientists to promote their studies
and c) Greek organisations to submit data, reports  and other deliverables to 
the European Union and other domestic and international organizations.

Examples: energy, environmental modelling, water resources studies.

# References

