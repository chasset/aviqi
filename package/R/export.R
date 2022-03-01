#' Get month
#'
#' Make the whole job of filtering, joining and aggregating data of all sites.
#' Before execution, it loads the parameters describe in the .env file,
#' checks the parameters and launch the whole process.
#' @return Dataframe of the month report and an output file
#' @export
monthReport <- function() {
  if (file.exists(".env")) {
    message("Version ", packageVersion("aviqi"), " loaded")
    loadEnv()
    getReport()
  } else {
    message(".env file is missing")
  }
}

#' get monthly sales report
#'
#' Export dataframe to a CSV file
#' @return Dataframe of the sales monthly report
getReport <- function() {
  getFiles() %>%
    checkMissingSites() %>%
    filterCompleteSites() %>%
    dplyr::select(-exists, -value) %>%
    stopOrGo() %>%
    loadSites() %>%
    stopOrGo() %>%
    exportOutput()
}

#' Export month report
#'
#' Export dataframe to a CSV file
#' @param df Dataframe to export
#' @return Dataframe of the month report
exportOutput <- function(df) {
  outputFilename <- getOption("aviqi.outputFilename")
  readr::write_delim(x = df, file = outputFilename, delim = ";")
  return(df)
}
