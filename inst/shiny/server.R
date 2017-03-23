
extensions <- c("csv", "txt", "xlsx", "ods")





server <- function(input, output) {

  ## This function processes UI inputs and returns a data.frame which will be
  ## used as raw inputs.

  get_data <- reactive({
    if (input$datasource == "ebola_sim") {
      return(ebola_sim_clean$linelist)
    } else if (input$datasource == "mers_korea") {
      return(mers_korea_2015$linelist)
    } else {

      return(read.csv(input$inputfile$datapath))
      ## dataimportServer("datasource",
      ##                  fileExt = extensions)
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

    NA_as_group <- input$NA_as_group

    use_iso_weeks <- input$ISO_weeks

    req(input$dates_column)
    out <- incidence(dates,
                     interval = input$interval,
                     groups = groups,
                     na_as_group = NA_as_group,
                     iso_week = use_iso_weeks)

    return(out)
  })






  ## This function makes an incidence_fit object; the time window to be used for
  ## the fit is defined by the user in input$fit_interval.

  make_incidence_fit <- reactive({
    x <- make_incidence()

    x <- subset(x,
                from = min(input$fit_interval),
                to = max(input$fit_interval)
                )

    if (input$fit_type == "single fit") {
      out <- fit(x)
    }

    if (input$fit_type == "double fit") {
      out <- fit_optim_split(x)$fit
    }


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






  ## UI input: choose fit interval

  output$choose_fit_interval <- renderUI({
    x <- make_incidence()

    sliderInput(
      inputId = "fit_interval",
      label = "Indicate fitting interval (in days)",
      min = 0, max = x$timespan, step = x$interval,
      value = c(0, x$timespan))
  })






  ## This creates a plotly version of the plot

  output$plot <- plotly::renderPlotly({
    pdf(NULL) # hack to avoid R graphical window to pop up
    x <- make_incidence()

    if (input$fit_type != "[none]") {
      fit <- make_incidence_fit()
    } else {
      fit <- NULL
    }

    out <- plot(x, fit = fit)
    dev.off()
    out
  })






  ## This creates a rendering of the R incidence object

  output$printed_incidence_object <- shiny::renderPrint({
    print(make_incidence())
  })


  ## This returns some system info: date, sessionInfo, etc.

  output$systeminfo <- incidence.ui:::get_session_info()


}

