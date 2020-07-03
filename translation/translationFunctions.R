
########################
# 
# Script: translationFunctions.R
#
# Purpose: functions to translate applications in R
# Details:
#
# Author: Corentin M. Barbu (canonical corentin period barbu working at inra in fr)
# Version: 0.1
#
# Website: https://ecosys.versailles-grignon.inra.fr/SpatialAgronomy/
#
# Copyright (c) GNU GPL v2
# (Modify this template at: ~/.vim/templates/vimodel1.R)
#########################

## easy debugging options
# options(error=browser)
# options(warn=2)
library("data.table")
library("jsonlite")
library(plyr)

translationFolder <- "translation"
translationBin <- file.path(translationFolder,"translation.bin")
translationMis <- file.path(translationFolder,"missingTranslations.txt")
translationJson <- file.path(translationFolder,"translation.json")

importBin <- try(load(translationBin),silent=TRUE) # contains the dictionary, parsed as a double list

if(class(importBin)=="try-error"){
    translation <-list() 
}

SignalMissing <- function(text,lang){
    warning(paste0("Missing translation of '",text,"' to '",lang,"'\n"))
    cat(text,",",lang,"\n",file=translationMis,append=TRUE,sep="")
}
trInternal <- function(text,lang){ # translates text into current language
    text <- as.character(text)
    if(is.null(text)||text==""){
        return("")
    }

    out <- sapply(text,function(s) translation[[s]][[lang]], USE.NAMES=FALSE)

    # handling missing translations
    if(is.null(out[[1]])|| is.na(out[[1]])){
        out <- sapply(text,function(s) translation[[s]][["en"]], USE.NAMES=FALSE)
        # SignalMissing(text,lang) # not needed as detected automatically by updateMissingTranslation.R if other translations not missing
        if(is.null(out[[1]])|| is.na(out[[1]])){
            SignalMissing(text,"en")
            out <- text
        }
    }
    return(out)
}

Rjson <- function(file){
    out <- try(fromJSON(file),silent=TRUE)
    if(class(out)=="try-error"){
        out <- data.frame(key=NULL)
    }
    return(out)
}
UpdateMissingTranslation <- function(
                                     translationFile=translationJson,
                                     missingTranslationFile=translationMis){

    misTrad <- try(read.csv(missingTranslationFile,header=FALSE),silent=TRUE)
    if(class(misTrad)=="try-error"){
        misTrad <- data.frame(key=NULL,lang=NULL)
    }else{
        misTrad <- unique(misTrad)
        names(misTrad) <- c("key","lang")
    }

    translationContent <- Rjson(translationFile)

    toAdd <- data.frame(key=setdiff(misTrad$key,translationContent$key))

    newTranslationContent <- data.frame(data.table::rbindlist(list(translationContent,toAdd),fill=TRUE))
    toAddCols <- setdiff(unique(misTrad$lang),names(newTranslationContent))
    for(lang in toAddCols){
        newTranslationContent[,lang] <- NA
    }

    nMissingTrans <- lapply(newTranslationContent,function(x){length(which(is.na(x)))})
    for(lang in names(nMissingTrans)){
        if(nMissingTrans[[lang]]>0){
            cat("Missing",nMissingTrans[[lang]],"translation(s) for",lang,".\n")
        }
    }

    cat("",file=missingTranslationFile)

    write_json(newTranslationContent,na="null",null="null",path=translationFile,pretty=TRUE)

    if(sum(unlist(nMissingTrans))>0){
        cat("Check for 'null', in '",translationFile,"' for missing translations.\n")
        cat("To add new languages, simply add the language in one of the keys.\n")

        cat("Do you want to directly edit in vim?\n")
        userIn <- readline("[y/N]")
        if(userIn=="y"){
            system(paste("vim",translationFile))
        }
        UpdateTranslation()
    }else{
        cat("Great, nothing missing.\n")
    }

    return(invisible(translationContent))
}
UpdateTranslation <- function(translationFile=translationJson,
                              translationBinFile=translationBin
                              ){
    # translationContent <- read.delim("dictionary.csv", header = TRUE, sep = "\t", as.is = TRUE) 
    translationContent <- Rjson(translationFile)

    if(length(translationContent)>0){
        translation <- dlply(translationContent ,.(key), function(s) key = as.list(s))
    }else{
        translation <- list()
    }

    cat("Translation updated for the app.\n")

    save(translation, file = translationBinFile)
}
