

## load required packages

require("shiny")
require("outbreaks")
require("DT")
require("incidence")
require("plotly")



shinyUI(
  fluidPage(

    titlePanel(
      img(src = "img/logo.png", width = "200")
    ),

    sidebarLayout(
      sidebarPanel(

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

          uiOutput("choose_groups_column")
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






## shinyUI(
##   navbarPage(
##     "",position="fixed-top", collapsible = TRUE,
##     theme = "bootstrap.simplex.css",

##     tabPanel(
##       "Input data",
##       tags$link(rel = 'stylesheet', type = 'text/css', href = 'styles.css'),
##       tags$style(type="text/css", "body {padding-top: 40px;}"),
##       pageWithSidebar(
##         ##  TITLE ##
##         headerPanel(
##           img(src = "img/logo.png", height = "60")
##         ),


##         ## SIDE PANEL CONTENT ##
##         sidebarPanel(
##           tags$head(tags$style(
##             type = 'text/css',
##             'form.well { max-height: 1600px; overflow-y: auto; }'
##           )),


##           ## Input data
##           conditionalPanel(
##             condition = "$('li.active a').first().html()== 'Input data",

##             h2(HTML('<font color="#6C6CC4" size="6"> > Input </font>')),

##             radioButtons(
##               "datasource", HTML('<font size="4"> Choose data file:</font>'),
##               list("example: Ebola simulation" = "ebola_sim",
##                    "example: MERS" = "mers_korea",
##                    "Use input file" = "file")),

##             ## choice of dataset if source is a file
##             conditionalPanel(
##               condition = "input.datasource=='file'",
##               fileInput("datafile",
##                         p(HTML(' <font size="4"> Choose input file:</font>'), br(),
##                           strong("accepted formats:", ".csv / .txt / .xls / .ods")),
##                         accept = c(
##                           'text/csv',
##                           'text/comma-separated-values',
##                           'text/tab-separated-values',
##                           'text/plain',
##                           '.csv',
##                           '.tsv'
##                         )
##                         ),
##               ),


##             br(), br(), br(), br(), br(), br(), br(),
##             width = 4)
##         ), # end conditional panel and sidebarPanel; width is out of 12
##         ## MAIN PANEL
##         mainPanel("",

##                   # TITLE #
##                   h2(HTML('<font color="#6C6CC4" size="6"> Input data </font>')),
##                   br(),br(),

##                   DT::dataTableOutput("input_data")



##                   ) # end mainPanel
##       ) # end page with sidebar
##     ), # end of tabPanel


##     ## HELP SECTION
##     tabPanel("Help",
##              tags$style(type="text/css", "body {padding-top: 40px;}"),
##              HTML(paste(readLines("www/html/help.html"), collapse=" "))
##              ),

##     ## SERVER INFO ##
##     tabPanel("System info",
##              tags$style(type="text/css", "body {padding-top: 40px;}"),
##              verbatimTextOutput("systeminfo"))
##   ) # end of tabsetPanel
## ) # end of Shiny UI
