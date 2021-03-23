# Overview tab.


body_overview <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "#overview_map {height: 48vh !important;}"), # Displays a map.
    tags$style(type = "text/css", ".slider-animate-button { font-size: 20pt !important; }"), # Animation button.
    tags$style(type = "text/css", ".slider-animate-container { text-align: left !important; }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details {display: flex; flex-direction: column; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .map { order: 1; width: 100%; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .summary { order: 3; width: 100%; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .slider { order: 2; width: 100%; } }"),
  ),
  fluidRow(
    fluidRow(
      uiOutput("box_keyFigures") # Imp. for later on.
    ),
    fluidRow(
      class = "details",
      column(
        box(
          width = 12,
          leafletOutput("overview_map")
        ),
        class = "map",
        width = 8,
        style = 'padding:0px;'
      ),
      column(
        uiOutput("summaryTables"),
        class = "summary",
        width = 4,
        style = 'padding:0px;'
      ),
      column(
        sliderInput(
          "timeSlider",
          label = "Select date", # So user selects their own date.
          min = min(data_evolution$date),
          max = max(data_evolution$date),
          value = max(data_evolution$date), # This is the current value; which will obv. be the max.
          width = "100%", # Fill the page.
          timeFormat = "%d.%m.%Y",
          animate = animationOptions(loop = TRUE)
        ),
        class = "slider",
        width = 12
      )
    )
  )
)


page_overview <- dashboardPage(
  title = "Overview",
  header = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body = body_overview
)
  
  

