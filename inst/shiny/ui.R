
recon.ui::reconNavbarPage(
  "incidence.ui",






  ## ====================
  ## Data input panel
  ## ====================

  tabPanel(
    "Load data",
    fluidRow(
      column(
        4,
        h2("Choose data input"),
        dataimport$ui(),
        br(),
        uiOutput("choose_variable_groups")
      ),

      column(8,
             h2("Data view"),
             DT::dataTableOutput("input_data")
             )
    )
  ),






  ## ===================
  ## Data analysis panel
  ## ===================

  tabPanel(
    "Run analyses",
    fluidRow(
      column(
        4,
        h2("Settings"),

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
          value = FALSE
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
      ),


      column(
        8,
        ## h2("Analyses view"),
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

      )
    )
  ),






  ## ===================
  ## Documentation panel
  ## ===================

  tabPanel(
    "Help",
    HTML(paste(readLines("www/html/help.html"), collapse=" "))
  ),






  ## =================
  ## System info panel
  ## =================

  tabPanel(
    "System info",
    verbatimTextOutput("systeminfo")
  )

)
