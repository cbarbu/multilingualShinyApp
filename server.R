
library(shiny)
source(file.path("translation","translationFunctions.R"))

shinyServer(function(input, output) {
  tr <- function(text){trInternal(text,input$language)}

  output$titlePanel <- renderText(tr("titlePanel"))

  output$distPlot <- renderPlot({
      inputObs <- input$obs
      if(length(inputObs)<1){
          inputObs <- 1
      }
    plot(1:inputObs,1:inputObs, main = tr("plotTitle"))
    
  })
   
  output$description <- renderText({
    paste(tr("You have selected:"), 
          paste(tr(input$weekdays), collapse = ', '),
          tr("test_text"),
          tr("another_text")
          )
  })
  
  # UI
  output$uiObs <- renderUI({
    sliderInput("obs", tr("numberOfObservations"),  
                  min = 1, max = 100, value = 50)
  })
  
  output$uiWeekdays <- renderUI({
    # Using a named list in order to pass the same value regardless of the label (which changes with the language)
    daysValue <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
    days <- structure(daysValue, .Names = tr(daysValue))
    
    selectInput(inputId   = "weekdays",
                label     = tr("Selection:"),
                choices   = days,
                multiple  = TRUE)
  })
})
