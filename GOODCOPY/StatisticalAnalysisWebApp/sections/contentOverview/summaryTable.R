output$summaryTables <- renderUI({
  tabBox(
    tabPanel("Country/Region",
             div(
               dataTableOutput("summaryDT_country"),
               style = "margin-top: -10px")
    ),
    tabPanel("Province/State",
             div(
               dataTableOutput("summaryDT_state"),
               style = "margin-top: -10px"
             )
    ),
    width = 12
  )
})