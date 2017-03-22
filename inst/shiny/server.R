

server <- function(input, output) {

  ## This function processes UI inputs and returns a data.frame which will be
  ## used as raw inputs.

  get_data <- reactive({
    if (input$datasource == "ebola_sim") {
      return(ebola_sim_clean$linelist)
    } else if (input$datasource == "mers_korea") {
      return(mers_korea_2015$linelist)
    } else {

      req(input$inputfile)

      return(read.csv(input$inputfile$datapath))
    }

  })






  ## This function makes an incidence object

  make_incidence <- reactive({
    x <- get_data()

    dates <- x[[input$dates_column]]

    if (input$groups_column != "[none]") {
      groups <- x[[input$groups_column]]
    } else {
      groups <- NULL
    }

    req(input$dates_column)
    out <- incidence(dates,
                     interval = input$interval,
                     groups = groups)

    return(out)
  })






  ## UI output: show input data table

  output$input_data <- DT::renderDataTable ({
    get_data()
  })






  ## UI input: choose column for dates

  output$choose_date_column <- renderUI({
    selectInput(
      inputId = "dates_column",
      label = "Select dates to use",
      choices = names(get_data())
    )
  })




  ## UI input: choose time interval

  output$choose_interval <- renderUI({
    sliderInput(
      inputId = "interval",
      label = "Choose a time interval (in days)",
      min = 1, max = 31, step = 1, value = 1)
  })






  ## UI input: choose column for groups

  output$choose_groups_column <- renderUI({

    choices <- c("[none]", names(get_data()))

    selectInput(
      inputId = "groups_column",
      label = "Group data by",
      choices = choices
    )

  })










  ## This creates a plotly version of the plot

  output$plot <- plotly::renderPlotly({
    pdf(NULL) # hack to avoid R graphical window to pop up
    x <- make_incidence()
    out <- plot(x)
    out
  })






  ## This creates a rendering of the R incidence object

  output$printed_incidence_object <- shiny::renderPrint({
    print(make_incidence())
  })


  ## This returns some system info: date, sessionInfo, etc.

  output$systeminfo <- incidence.ui:::get_session_info()


}

