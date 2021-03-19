


body_about <- dashboardBody(
  fluidRow(
    fluidRow(
      column(
        box(
          title = div("About this web app", style = "padding-right: 10px", class = "h3"),
          column(
            h3("COVID-19 Statistical Analysis Dashboard"),
            "This dashboard displays recent stats about the COVID-19 Pandemic.
            This web app reads public data retrieved from the John Hopkins website, and shows data related to positive cases,
            mortality, recoveries, etc...",
            tags$br(),
            h3("COVID-19 & Social Distancing"),
            "Please stay safe, keeping in mind to keep your distance towards others.",
            tags$br(),
            h4("Disclaimer"),
            "This app has been created for educational purposes only.",
            width = 12
          ),
          width = 6,
        ),
        width = 12,
        style = "padding: 15 px"
      )
    )
  )
)


# About page should be part of the dashboard page.
page_about <- dashboardPage(
  title = "About",
  header = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body = body_about
)


