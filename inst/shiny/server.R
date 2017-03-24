

server <- function(input, output) {

  ## This function processes UI inputs and returns a data.frame which will be
  ## used as raw inputs.

  get_data <- dataimport$server()



  ## This function makes an incidence object

  make_incidence <- reactive({
    x <- get_data()

    dates <- x[[input$dates_column]]

    ## convert to dates if provided in yyyy-mm-dd
    if (!is.null(dates) && !is.numeric(dates)) {
      dates <- as.Date(dates, format = "%Y-%m-%d")
    }

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






  ## UI output: show input data table

  output$incidence_table <- DT::renderDataTable ({
    as.data.frame(make_incidence())
  })






  ## UI input: select variables of certain types
   variable_types <- mapcolumnsServer(
     data = get_data(),
     names = c("dates", "stratification")
   )

  output$choose_variable_groups <- renderUI(
    shinyHelpers::mapcolumnsUI(
      data = get_data(),
      names = c("dates", "stratification"),
      labels = c("Indicate which columns are dates",
                 "Indicate which columns are groups")
    )
  )






  ## UI input: choose column for dates

  output$choose_date_column <- renderUI({
    if(is.null(variable_types)) {
      choices <- "[none]"
    } else {
      choices <- variable_types$dates()
    }
    selectInput(
      inputId = "dates_column",
      label = "Select dates to use",
      choices = choices
    )
  })






  ## UI input: choose column for groups

  output$choose_groups_column <- renderUI({
    choices <- c("[none]", variable_types$stratification())

    selectInput(
      inputId = "groups_column",
      label = "Group data by",
      choices = choices
    )

  })






  ## UI input: choose fit interval

  output$choose_fit_interval <- renderUI({
    x <- make_incidence()
    lab <- sprintf("Indicate fitting interval (in %d days periods)",
                   x$interval)

    div(
      sliderInput(
        inputId = "fit_interval",
        label = lab,
        min = 0, max = length(x$dates),
        step = 1L,
        value = c(0, length(x$dates))
      ),
      a(paste0("current dates: ",
              as.character(min(x$dates)),
              " - ",
              as.character(max(x$dates)))
        )
    )


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






  ## This handles the download of the incidence table.

  output$download_incidence <- downloadHandler(
    filename = function() {
      paste('incidence_table_', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      write.csv(make_incidence(), con,
                row.names = FALSE)
    }
  )






  ## This handles the download of the R session.

  output$download_R_session <- downloadHandler(
    filename = function() {
      paste('incidence_R_session_', Sys.Date(), '.RData', sep='')
    },
    content = function(con) {
      x <- make_incidence()
      fit <- make_incidence_fit()
      save(x, fit, file = con)
    }
  )






  ## This creates a rendering of the R incidence object

  output$printed_incidence_object <- shiny::renderPrint({
    print(make_incidence())
  })






  ## This creates a rendering of the R incidence object

  output$printed_fit_object <- shiny::renderPrint({
    print(make_incidence_fit())
  })






  ## This returns some system info: date, sessionInfo, etc.

  output$systeminfo <- incidence.ui:::get_session_info()


}

