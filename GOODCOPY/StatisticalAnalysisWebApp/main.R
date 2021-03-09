# ---- Loading libraries ----
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")
library("wbstats")




source("utils.R", local = T)


downloadGithubData <- function() {
  download.file(
    url      = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19_data.zip"
  )
  
  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  unzip(
    zipfile   = "data/covid19_data.zip",  
    files     = paste0(data_path, c("confirmed_global.csv", "deaths_global.csv", "recovered_global.csv")),
    exdir     = "data",
    junkpaths = T
  )
}


updateData <- function() {
  # Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 0.5h.
  if (!dir_exists("data")) {
    dir.create('data')
    downloadGithubData()
  } else if ((!file.exists("data/covid19_data.zip")) || (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 0.5)) {
    downloadGithubData()
  }
}

# Update with start of app.
updateData()


# CSV Files needed.
data_confirmed <- read_csv("data/time_series_covid19_confirmed_global.csv")
data_deceased  <- read_csv("data/time_series_covid19_deaths_global.csv")
data_recovered <- read_csv("data/time_series_covid19_recovered_global.csv")


# Get the upddated data.
current_date <- as.Date(names(data_confirmed)[ncol(data_confirmed)], format = "%m/%d/%y")
changed_date <- file_info("data/covid19_data.zip")$change_time


# Get evolution data by country.
data_confirmed_sub <- data_confirmed %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_confirmed)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("confirmed" = sum(value, na.rm = T))

data_recovered_sub <- data_recovered %>%
   pivot_longer(names_to = "date", cols = 5:ncol(data_recovered)) %>%
   group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
   summarise("recovered" = sum(value, na.rm = T))

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


# Calculating new cases
data_evolution <- data_evolution %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 4, default = 0)) %>%
  ungroup()

# data_evolution table is all we need.
rm(data_confirmed, data_confirmed_sub, data_recovered, data_recovered_sub, data_deceased, data_deceased_sub)


