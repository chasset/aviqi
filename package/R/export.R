#' Get final table
#'
#' Make the whole job of filtering, joining and aggregating data
#' @export
joinAndAggregate <- function() {
  if (file.exists(".env")) {
    message("Version ", packageVersion("aviqi"), " loaded")

    # Loading parameters from env file
    dotenv::load_dot_env()

    # Setting options with them
    op <- options()
    opAviqi <- list(
      aviqi.firstDayOfMonth = lubridate::as_date(Sys.getenv("FIRSTDAYOFMONTH")),
      aviqi.chosenPolicy = as.numeric(Sys.getenv("CHOSENPOLICY")),
      aviqi.outputFilename = Sys.getenv("OUTPUTFILENAME"),
      aviqi.dataFolder = Sys.getenv("DATAFOLDER"),
      aviqi.parametersFile = Sys.getenv("SITES"),
      aviqi.policies = data.frame(
        policy = c(
          "Skip all errors",
          "Stop if unsual values are encountered",
          "Stop if extreme values are encountered",
          "Stop if one file is missing for a site"
        ),
        hitted = c(0, 0, 0, 0)
      )
    )
    toset <- !(names(opAviqi) %in% names(op))
    if (any(toset)) options(opAviqi[toset])

    # Some checks about parameters
    checkParametersFile()
    checkDataFolder()
    printParameters()
    checkChosenPolicy()

    getFiles() %>%
      checkMissingSites() %>%
      filterCompleteSites() %>%
      dplyr::select(-exists, -value) %>%
      stopOrGo() %>%
      loadSites() %>%
      stopOrGo() %>%
      exportOutput()
  } else {
    message(".env file is missing")
  }
}

#' Export dataframe to CSV
exportOutput <- function(df) {
  outputFilename <- getOption("aviqi.outputFilename")
  readr::write_delim(x = df, file = outputFilename, delim = ";")
  return(df)
}
