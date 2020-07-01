multilingualShinyApp
====================

# Purpose

A way to build a multilingual Shiny app using a double list and renderUI.

This is a fork from https://github.com/chrislad/multilingualShinyApp 
**switching to json for translation file** and **adding helper functions**.
 

# Testing

Local test run : shiny::runApp()

If missing translations, the app saves missing information in missingTranslations.txt,

UpdateMissingTranslation() # to check for missing translations and update 'translation.json', offers direct editing in vim
UpdateTranslation() # to update 'translation.bin' after manual changes to 'translation.json'

# Use in an other R program (shiny or other)

Just copy 'translationFunctions.R' in a 'translation' folder of the app (default can be changed : `translationFolder` in 'translationFunctions.R'. 

Then, in your script (for example 'app.R') : 

    source(file.path("translation","translationFunctions.R",chdir=TRUE)

## Non interactive change of language 

You can use directly `trInternal(text,lang)` where lang is set by the developper.

## Interactive change of the language (ex: shiny)

For shiny apps, at the beginning of 'shinyServer(function(input,output)){' add :

    tr <- function(text){trInternal(text,input$language)}

Then, everything in server using tr("someKey") will look in 'translation.json' for the key in the language given by input$language. 

In the UI, you can have things like 

    uiOutput("mykey")

refering in the server to :
    
    output$mykey <- renderText(tr("mykeyInJsonFile"))

