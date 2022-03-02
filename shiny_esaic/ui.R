# https://grigorij-schleifer.shinyapps.io/FirstTutorial/

# ToDo

# KAI Logo einbauen rechts oben

library(shiny)
library(tidyverse)
library(ggpubr)
library(shiny.info)
library(rsconnect)
library(shinythemes)

survey_fragments <- read.csv("survey_fragments.csv")
# survey_fragments <- read.csv("/Users/grigorijschleifer/Desktop/R/Shiny/ESAIC-survey/ESAIC-KAI-survey-2021/data/survey_fragments.csv")

# renaming columns and removing dots in column names due to write_csv method
# will fix that later
colnames(survey_fragments) <-
    c(
        "expert.level",
        "country",
        "ASA.Class",
        "Apfel.Score",
        "NYHA.Score",
        "ARISCAT.Score",
        "rRCI",
        "POSPOM",
        
        "method.future.evaluation",
        "who.obtains",
        "online.legal",
        "online.possible.internet",
        "online.possible.telefon",
        
        "lack of contact",
        "impossible to observe behavior",
        "no relation",
        "no confidence",
        "legal requirenments",
        "unsure if illigal",
        "no anamnestic info",
        
        "Less stressful",
        "Less waiting",
        "Standardized questionaires",
        "More efficient than face-to-face",
        
        "Obtain.both.parents.complex",
        "Obtain.both.parents.simple",
        "parents.legal.online",
        "id.card",
        "id.card.needed"
    )

# survey_fragments <- read_csv("survey_fragments.csv")

countries = c("All", "Albania", "Austria", "Belarus", "Belgium", "Bosnia and Herzegovina", 
              "Bulgaria", "Croatia", "Cyprus", "Czechia", "Denmark", "Estonia", 
              "Finland", "France", "Germany", "Greece", "Hungary", "Iceland", 
              "Ireland", "Israel", "Italy", "Kazakhstan", "Kosovo", "Latvia", 
              "Liechtenstein", "Lithuania", "Malta", "Moldova", "Netherlands", 
              "Norway", "Poland", "Portugal", "Romania", "Russia", 
              "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", 
              "Turkey", "Ukraine", "United Kingdom (UK)", "Other")


ui <- fluidPage(
    theme = shinytheme("cerulean"),
    shiny.info::busy(),
    
    # img(src="Logo_KAI_RGB_Farbe.png", align = "right"),
    # tags$a(href="https://github.com/GrigorijSchleifer/ESAIC-KAI-survey-2021", 
    #        "Source code"),

    img(src="header.png", height="50%", width="100%", align="center"),
    

    br(),
    br(),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "country",
                label = "Select country:",
                choices = countries,
                selected = "All"),
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel(title = "Technical baseline",
                         br(),
                         plotOutput("who_obtains_consent", height = 500),
                         br(),
                         br(),
                         plotOutput("future_evaluation_plot", height = 500),
                         br(),
                         br(),
                         plotOutput("legal_online_plot", height = 500),
                         br(),
                         br(),
                         plotOutput("possible_online_plot", height = 500),
                         br(),
                         br()
                ),
                tabPanel(title = "Anesthesiological Evaluation",
                         br(),
                         plotOutput("risk_scores_plot", height = 500),
                         br(),
                         br(),
                         plotOutput("missing_out_if_online_plot", height = 500),
                         br(),
                         br(),
                         plotOutput("advantages_for_online", height = 500),
                         br(),
                         br()
                ),
                tabPanel(title = "Pediatrics",
                         br(),
                         plotOutput("both_parents_plot", height = 500),
                         br(),
                         br(),
                         plotOutput("parents_legal_online_counts", height = 500),
                         br(),
                         br(),
                         plotOutput("id_card", height = 500),
                         br(),
                         br(),
                         plotOutput("id_card_needed", height = 500),
                         br(),
                         br(),
                         )
            )
        )
    ),
)

