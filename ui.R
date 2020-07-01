library(shiny)

shinyUI(fluidPage(
  
  titlePanel(uiOutput("titlePanel")),
  

  radioButtons(inputId = "language", label = "",
               choices = c("English" = "en",
                           "Français" = "fr",
                           "Español" = "es"
                           ),
               selected = "en"),
  
  sidebarLayout(
    
    sidebarPanel(
      uiOutput("uiObs"),
      uiOutput("uiWeekdays")
      ),
    
    mainPanel(
      plotOutput("distPlot"),
      textOutput("description")      
    )
  )
))
