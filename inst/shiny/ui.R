

## load required packages

require("shiny")
require("outbreaks")
require("DT")
require("incidence")
require("plotly")
require("shinyHelpers")


## extensions of acceptable input files

extensions <- c("csv", "txt", "xlsx", "ods")
data_examples <- list(ebola_sim = ebola_sim$linelist,
                      mers_korea = mers_korea_2015$linelist,
                      flu_china_2013 = fluH7N9_china_2013,
                      hagelloch_1861 = measles_hagelloch_1861,
                      norovirus_uk_2001 = norovirus_derbyshire_2001_school)


fluidPage(

  titlePanel(
    img(src = "img/logo.png", width = "200")
  ),

  sidebarLayout(
    sidebarPanel(

      shinyHelpers::dataimportUI(
        "datasource",
        fileExt = extensions,
        sampleDatasets = data_examples
      ),


      conditionalPanel(
        condition = "$('li.active a').first().html()== 'Input data view'",
        br(),
        uiOutput("choose_variable_groups")
       ),






      conditionalPanel(
        condition = "$('li.active a').first().html()== 'Incidence view'",

        uiOutput("choose_date_column"),

        sliderInput(
          inputId = "interval",
          label = "Choose a time interval (in days)",
          min = 1, max = 31, step = 1, value = 1),

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

          br(), br(),


          ## Display R object

          checkboxInput(
            inputId = "show_R_object",
            label = "Show incidence object",
            value = FALSE
          ),

          conditionalPanel(
            condition = "input.show_R_object",
            verbatimTextOutput("printed_incidence_object")
          ),


          ## Display incidence table

          checkboxInput(
            inputId = "show_incidence_table",
            label = "Show incidence table",
            value = FALSE
          ),

          conditionalPanel(
            condition = "input.show_incidence_table",
            DT::dataTableOutput("incidence_table", width = "60%")
          ),


          ## Display fit object

          conditionalPanel(
            condition = "input.fit_type!='[none]'",
            checkboxInput(
              inputId = "show_fit_object",
              label = "Show fit object",
              value = FALSE
            )
          ),

          conditionalPanel(
            condition = "input.show_fit_object",
            verbatimTextOutput("printed_fit_object")
          ),


          ## Downloads

          downloadButton("download_incidence",
                         label = "Save incidence table (.csv)"),

          downloadButton("download_R_session",
                         label = "Save R session (.RData)"),

          br(), br(), br()

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
