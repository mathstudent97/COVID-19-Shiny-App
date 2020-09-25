body_table <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "@media (min-width: 700 px) {.full-table { margin-top: -30px; } }" )
  ),
  fluidPage(
    fluidPage(
      h3(paste0("Table(", strftime(current_date, format = "%d/%m/%Y")),
      class = "box-title", style = "margin-top: 10 px; font-size: 15px"),
    div(
      dataTableOutput("fullTable"),
      class = "full-table"
    ),
    div(
      tags$h4("Growth Rate Coloring", style = "margin-left: 5px; "),
      tags$ul(class = "legend",
              tags$li(tags$span(class = "pos1"), "0 % to 10 %"),
              tags$li(tags$span(class = "pos2"), "10 % to 20 %"),              
              tags$li(tags$span(class = "pos3"), "20 % to 33 %"),
              tags$li(tags$span(class = "pos4"), "33 % to 50 %"),
              tags$li(tags$span(class = "pos5"), "50 % to 75 %"),
              tags$li(tags$span(class = "pos6"), "> 75 %"),  
              tags$br()
      ),
      tags$ul(class = "legend",
              tags$li(tags$span(class = "neg1"), "0 % to 10 %"),
              tags$li(tags$span(class = "neg2"), "10 % to 20 %"),
              tags$li(tags$span(class = "pos1"), "20 % to 33 %"),
              tags$li(tags$span(class = "pos1"), "> 33 %"),
      )
    ),
    width = 12
    )
  )
)

page_fullTable <- dashboardPage(
  title = "Table",
  header = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body = body_table
)