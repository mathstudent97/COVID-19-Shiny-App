library(shiny)
library(shinythemes)


# Define UI for the application 

ui <- fluidPage(theme = shinytheme("cerulean"), 
                # can try "united" or "yeti" or "superhero" theme; 
                # just look up "shiny themes" for more
               navbarPage(
        # theme = "cerulean", # <--- To use a theme, will uncomment 
                  "Intro to Shiny Web App / My first App Tutorial",
                  tabPanel("Navbar 1",
                          sidebarPanel(
                            tags$h3("Input:"), #h3 is 3rd level heading
                            textInput("txt1", "Given Name:", ""), #default is empty          
                            ##NOTE: "txt1" WILL BE SENT TO THE SERVER
                            textInput("txt2", "Surname:", ""), #default is empty            
                            ##NOTE: "txt2" WILL BE SENT TO THE SERVER
                   
                          ), # Contents of sidebarPanel under "Navbar 1"
                          mainPanel(
                   
                                        h1("Header 1"), #"h1" is the biggest tag available
                            
                                        h4("Output 1"), #"h4" is the smallest tag available
                                        verbatimTextOutput("txtout"), #this is a simple textbox 
                            ##NOTE: "txtout" IS GENERATED FROM THE SERVER
                            # UI will basically display "txtout"
                         
                         ) # Contents of the mainPanel under "Navbar 1"

             
                  ), # ALL tabPanel contents under "Navbar 1"
                  tabPanel("Navbar 2", "This panel is intentionally left blank"),
                  tabPanel("Navbar 3", "This panel is intentionally left blank"),
    
            ) # navbar page 
 ) # fluid page


# Define server function
# Goal: To pretty much show results
# Q: How do UI & server interact?
#how do they send info from & to eachother?
#UI -> info to server; how does server accept this/ these input values?
server <- function(input, output) {
    
    output$txtout <- renderText({
        # the "output$..." will be used to paste fcn, to combine
        #"txt1" & "txt2" & sep it by an empty space
        #then it will produce the result as the concatenated text
        #of "txt1" & "txt2" INSIDE the "txtout" variable
        #then this variable will be called within the "verbatimTextOutput"
        #above
        #then it will dispalay the text within the text above
        # there are several other render functions i.e. "renderTable"
        paste( input$txt1, input$txt2, sep = " ")
        # basically "txt1" & "txt2" will be sent to the server 
    })
} # server


#Create Shiny project 
shinyApp(ui = ui, server = server)










            


