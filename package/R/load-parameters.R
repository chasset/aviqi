#' Filter complete sites
#'
#' Get files description of complete sites.
#' @param files Dataframe describing files to load
#' @return Dataframe of files to load
filterCompleteSites <- function(files) {
  sites <- files %>% getSites()
  files %>% dplyr::filter(site %in% sites$site)
}

#' Filter complete sites
#'
#' Get all files description and add a field showing
#' if the file exists or not.
#' @return Dataframe of files to load
getFiles <- function() {
  dataFolder <- getOption("aviqi.dataFolder")
  getOption("aviqi.parametersFile") %>%
    loadParameters() %>%
    tidyr::pivot_longer(cols = catalog:orders, names_to = "table") %>%
    dplyr::mutate(
      filename = paste0(dataFolder, "/", site, "_", value, ".csv", sep = "")
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(exists = file.exists(filename))
}

#' Get missing sites
#' @return Dataframe of missing sites
getMissingSites <- function(files) {
  files %>%
    dplyr::group_by(site) %>%
    dplyr::summarise(nbrOfFiles = sum(exists)) %>%
    dplyr::filter(nbrOfFiles < 3)
}

#' Get complete sites
#' @param files Dataframe describing files to load
#' @return Dataframe of files from site that are fully defined
getSites <- function(files) {
  files %>%
    dplyr::group_by(site) %>%
    dplyr::summarise(nbrOfFiles = sum(exists)) %>%
    dplyr::filter(nbrOfFiles == 3)
}

#' Load parameters of sites
#' @param filename Name of the file describing the files format
#' @return Dataframe of sites
loadParameters <- function(filename) {
  # Load definition of sites
  colTypes <- readr::cols(
    site = readr::col_character(),
    catalog = readr::col_character(),
    details = readr::col_character(),
    orders = readr::col_character(),
    delimiter = readr::col_character(),
    hasIds = readr::col_logical(),
    isCents = readr::col_logical()
  )

  # Load parameters
  df <- readr::read_csv(filename, col_types = colTypes)
  message(paste("Found", nrow(df), "sites"))
  return(df)
}

#' Load parameters of job
#' @return Side effects on options()
loadEnv <- function() {
  # Loading parameters from env file
  dotenv::load_dot_env()

  # Setting options with them
  op <- options()
  opAviqi <- list(
    aviqi.year = as.numeric(Sys.getenv("YEAR")),
    aviqi.month = as.numeric(Sys.getenv("MONTH")),
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
  options(opAviqi)

  # Some checks about parameters
  checkParametersFile()
  checkDataFolder()
  checkChosenPolicy()

  # Print
  printParameters()

  return(NULL)
}
