
## load required packages

require("shiny")
require("outbreaks")
require("DT")
require("incidence")
require("plotly")
require("shinyHelpers")
require("recon.ui")


## extensions of acceptable input files

extensions <- c("csv", "txt", "xlsx", "ods")
data_examples <- list(ebola_sim = ebola_sim$linelist,
                      mers_korea = mers_korea_2015$linelist,
                      flu_china_2013 = fluH7N9_china_2013,
                      hagelloch_1861 = measles_hagelloch_1861,
                      norovirus_uk_2001 = norovirus_derbyshire_2001_school)

shiny::addResourcePath("recon.ui", system.file("assets", package = "recon.ui"))

dataimport <- dataimportModule(
  "datasource", fileExt = extensions,
  sampleDataPackage = "outbreaks",
  sampleDatasets = data_examples
)
