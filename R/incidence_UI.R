
#'
#' Web interface for incidence
#'
#' This function opens up an application in a web browser for an interactive use
#' of RECON's incidence package.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @import shiny
#'
#' @export
#'
incidence_UI <- function(){
  shiny::runApp(system.file("shiny", package="incidence.ui"))
  return(invisible())
}
