
#'
#' Web interface for incidence
#'
#' This function opens up an application in a web browser for an interactive use
#' of RECON's incidence package.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' The incidence package: \url{http://www.repidemicsconsortium.org/incidence/}
#'
#'
#' @import shiny
#'
#' @export
#'
incidence_ui <- function(){
  shiny::runApp(system.file("shiny", package="incidence.ui"))
  return(invisible())
}
