

## load required packages

require("shiny")
require("outbreaks")
require("DT")
require("incidence")
require("plotly")
require("shinyHelpers")


## extensions of acceptable input files

## extensions <- c("csv", "txt", "xlsx", "ods")
extensions <- c("csv", "txt")




shinyUI(
  fluidPage(

    titlePanel(
      img(src = "img/logo.png", width = "200")
    ),

    sidebarLayout(
      sidebarPanel(

        ## shinyHelpers::dataimportUI("datasource",
        ##                            fileExt = extensions,
        ##                            label = "Select input data"),

        radioButtons(
          inputId = "datasource",
          label = "Choose data",
          choices = c(
            "Ebola simulation" = "ebola_sim",
            "MERS South Korea" = "mers_korea",
            "Upload data")
        ),

        conditionalPanel(
          condition = "input.datasource == 'Upload data'",
          fileInput(
            inputId = "inputfile",
            label = "Choose a linelist file to upload",
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              'text/tab-separated-values',
              'text/plain',
              '.csv',
              '.tsv'
            )
          )
        ),

        conditionalPanel(
          condition = "$('li.active a').first().html()== 'Incidence view'",

          uiOutput("choose_date_column"),

          uiOutput("choose_interval"),

          uiOutput("choose_groups_column"),

          checkboxInput(
            inputId = "NA_as_group",
            label = "Use unknown group (NA)?",
            value = TRUE
          ),

          checkboxInput(
            inputId = "ISO_weeks",
            label = "Use ISO weeks?",
            value = TRUE
          ),

          radioButtons(
            inputId = "fit_type",
            label = "Choose model fit",
            choices = c("[none]", "single fit", "double fit")
          ),

          conditionalPanel(
            condition = "input.fit_type!='[none]'",
            uiOutput("choose_fit_interval")
          )

        )

      ),





      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(

          ## Panel: view data

          tabPanel(
            title = "Input data view",
            DT::dataTableOutput("input_data")
          ),


          ## Panel: incidence view

          tabPanel(
            title = "Incidence view",
            plotly::plotlyOutput("plot"),
            verbatimTextOutput("printed_incidence_object")
          ),


          ## Panel: help

          tabPanel(
            title = "Help",
            HTML(paste(readLines("www/html/help.html"), collapse=" "))
          ),


          ## Panel: system info

          tabPanel(
            title = "System info",
            verbatimTextOutput("systeminfo"))

        )
      )
    )
  )
)
