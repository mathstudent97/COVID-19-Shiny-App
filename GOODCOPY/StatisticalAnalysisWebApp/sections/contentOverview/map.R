library(htmltools)



addLabel <- function(data) { # Takes data.
  data$label <- paste0( # Creates new col. named label.
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>Deceased:</td><td align="right">', data$deceased, '</td></tr>
    <tr><td>Estimated Recoveries:</td><td align="right">', data$recovered, '</td></tr>
    <tr><td>Active:</td><td align="right">', data$active, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)
  
  return(data)
}



map <- leaflet(addLabel(data_latest)) %>%
  setMaxBounds(-180, 0, 180, 0) %>%
  setView(0, 20, zoom = 2) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
  addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
  addLayersControl(
    baseGroups    = c("Light", "Satellite"),
    #overlayGroups = c("Confirmed", "Deceased", "Active")
    overlayGroups = c("Confirmed", "Confirmed (per capita)", "Estimated Recoveries", "Deceased", "Active", "Active (per capita)")
  ) %>%
  hideGroup("Confirmed (per capita)") %>%
  hideGroup("Estimated Recoveries") %>%
  hideGroup("Deceased") %>%
  #hideGroup("Active") %>%
  hideGroup("Confirmed") %>%
  hideGroup("Active (per capita)") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([20, 0], 2); }"))) %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-map-marker", title = "Locate Me",
    onClick = JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }")))



# Will add a slider that is adjustable by the user.

observe({
  req(input$timeSlider, input$overview_map_zoom)
  zoomLevel               <- input$overview_map_zoom
  data                    <- data_atDate(input$timeSlider) %>% addLabel()
  data$confirmedPerCapita <- data$confirmed / data$population * 100000
  data$activePerCapita    <- data$active / data$population * 100000
  
  leafletProxy("overview_map", data = data) %>%
    clearMarkers() %>% # Clear the markers everytime you move the slider.
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      #radius       = ~log(confirmed^(zoomLevel / 2)),
      radius       = zoomLevel/2,
      color        = "#00b3ff", #Color of the marker.
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmedPerCapita^(zoomLevel)),
      stroke       = FALSE,
      color        = "#00b3ff",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed (per capita)"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(recovered^(zoomLevel)),
      stroke       = FALSE,
      color        = "#000000",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group = "Estimated Recoveries"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(deceased^(zoomLevel)),
      stroke       = FALSE,
      color        = "#EEEEEE",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Deceased"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(active^(zoomLevel / 2)),
      stroke       = FALSE,
      color        = "#000000",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(activePerCapita^(zoomLevel)),
      stroke       = FALSE,
      color        = "#EEEEEE",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active (per capita)"
    )
})

output$overview_map <- renderLeaflet(map)



