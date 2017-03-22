
get_session_info <- function(){
  shiny::renderPrint({

    cat("\n== R version ==\n")
    print(R.version)

    cat("\n== Date ==\n")
    print(date())

    cat("\n== session info ==")
    print(utils::sessionInfo())
  })

}
