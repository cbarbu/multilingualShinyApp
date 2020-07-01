multilingualShinyApp
====================

A way to build a multilingual Shiny app using a double list and renderUI.

This is a fork from https://github.com/chrislad/multilingualShinyApp 
switching to json for translation file and adding helper files.
 
Local test run : shiny::runApp()

If missing translations, the app saves missing information in missingTranslations.txt,

UpdateMissingTranslation() # to check for missing translations and update 'translation.json' 
UpdateTranslation() # to update 'translation.bin' after manual changes to 'translation.json'

To use in an other app, just copy this folder in then in app.R or server.R add: 

    source("myFolderTranslation/translationFunctions.R",chdir=TRUE)

and at the beginning of 'shinyServer(function(input,output)){' add :

    tr <- function(text){trInternal(text,input$language)}


Then, everything in server using tr("someKey") will look in 'translation.json' for the key in the language given by input$language. Alternatively, can use a 'language' variable set by the developper in place of 'input$language'.

In the UI, you can have things like 

    uiOutput("mykey")

refering in the server to :
    
    output$mykey <- renderText(tr("mykeyInJsonFile"))

