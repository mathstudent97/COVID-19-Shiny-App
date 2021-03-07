library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(DT)
library(fs)
library(wbstats)
library(plotly)



source("utils.R", local = T)



# FUNCTIONS.
# Read and load the data.

loadCovidData <- function() {
  download.file(
    url = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19_JH.zip"
  )
  
  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  unzip(
    zipfile = "data/covid19_JH.zip",
    files = paste0(data_path, c("confirmed_global.csv", "deaths_global.csv", "recovered_global.csv")),
    exdir = "data",
    junkpaths = T
  )
}

updateData <- function() {
  # Download data from John Hopkins site (https://github.com/CSSEGISandData/COVID-19) if the data is older than 1h
  if(!dir_exists("data")) {
    dir.create('data')
    loadCovidData()
  } else if ((!file.exists("data/covid19_JH.zip")) || (as.double(Sys.time() - file_info("data/covid19_JH.zip")$change_time,
                                                                 units = "hours") > 1)) { loadCovidData() }
  
}
