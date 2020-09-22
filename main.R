library("shiny")
library("shinydashboard")
library("DT")
library("fs")
library("wbstats")
library("leaflet")
library("plotly")
library("tidyverse")

source("utils.R") # how to import this
# SourceDirectory is a fcn that appears in Global Environment :)

# Extract data; Read data 
DownloadTheCOVIDData <- function(){
  download.file(
    url = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip", 
    destfile = "data/covid19JH.zip"
    )
  
  data_path <-  "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  
  unzip(
    zipfile = "data/covid19JH.zip",
    files = paste0(data_path, c("confirmed_global.csv", 
                                  "deaths_global.csv", 
                                  "recovered_global.csv")),
    exdir = "data",
    junkpaths = T
  )
}

UpdateMyData <- function(){
  T_refresh = 10 # 0.5 half an hour; if set to say 0.00001 it'll download
  if(!dir_exists("data")){
    dir.create("data")
    DownloadTheCOVIDData()
  }
  else if ((!file.exists("data/covid19JH.zip")) 
           || as.double(Sys.time() - file_info("data/covid19JH.zip")$change_time, 
                        units ="hours") > T_refresh ){
    DownloadTheCOVIDData()
  }
}
UpdateMyData() # now notice, the data has been created within 'Files'
# 71.4 MB 06/30/2020 geeeeez

# 'destfile' - destination file to throw the downloaded contents
  # When it downloads, it will create a folder named 'data...'
# 'data_path' After I unzip, I need a data path to throw the 
# unzipped data
#... listen to video..

# NOTE: data is updated frequently, so will create another function regarding 
# that updated data

## CSV DATA ##

data_confirmed <- read_csv("data/time_series_covid19_confirmed_global.csv")
data_deceased <- read.csv("data/time_series_covid19_deaths_global.csv")
data_recovered <- read.csv("data/time_series_covid19_recovered_global.csv")


## LATEST DATA ##
current_date <- as.Date(names(data_confirmed)[ncol(data_confirmed)],
                        format = "%m/%d/%y")
changed_date <- file_info("data/covid19JH.zip")$change_time


# Get evolution data by country
data_confirmed_sub <- data_confirmed %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_confirmed)) %>%
  group_by('Province/State', 'Country/Region', date, Lat, Long) %>%
  summarise("confirmed" = sum(value, na.rm = T))

# data_recovered_sub <- data_recovered %>%
#   pivot_longer(names_to = "date", cols = 5:ncol(data_recovered)) %>%
#   group_by('Province/State', 'Country/Region', date, Lat, Long) %>%
#   summarise("recovered" = sum(value, na.rm = T))

data_deceased_sub <- data_deceased %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_deceased)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("deceased" = sum(value, na.rm = T))

data_evolution <- data_confirmed_sub %>%
  full_join(data_deceased_sub) %>%
  ungroup() %>%
  mutate(date = as.Date(date, "%m/%d/%y")) %>%
  arrange(date) %>%
  group_by(`Province/State`, `Country/Region`, Lat, Long) %>%
  mutate(
    recovered = lag(confirmed, 14, default = 0) - deceased,
    recovered = ifelse(recovered > 0, recovered, 0),
    active = confirmed - recovered - deceased
  ) %>%
  pivot_longer(names_to = "var", cols = c(confirmed, recovered, deceased, active)) %>%
  ungroup()


rm(data_confirmed, data_confirmed_sub, data_recovered, data_deceased, data_deceased_sub)





  
  
  
                  






