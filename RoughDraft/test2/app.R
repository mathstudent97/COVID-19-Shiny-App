#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
ody_about <- dashboardBody(
    fluidRow(
        fluidRow(
            column(
                box(
                    title = div("About", style = "padding-right: 10px", class = "h3"),
                    column("This dashboard demonstrates some recent news about the Coronavirus pandemic. 
            This App is a simulator, that reads from the John Hopkins dataset, and shows some data related to mortality,  
            recovery, infected, and etc..",
                           tags$br(),
                           h3("COVID-19 Social Distancing"),
                           "Please stay safe and respect social distancing, which can be tough on people and could disrupt the social and economic loop of life.C",
                           tags$br(),
                           width = 12
                    ),
                    width = 6,
                ),
                width = 12,
                style = "padding: 15px"
            )
        )
    )
)


page_about <- dashboardPage(
    title = "About",
    header = dashboardHeader(disable = TRUE),
    sidebar = dashboardSidebar(disable = TRUE),
    body = body_about
)


