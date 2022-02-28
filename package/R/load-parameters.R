#' @export
filterCompleteSites <- function(files) {
  sites <- files %>% getSites()
  files %>% dplyr::filter(site %in% sites$site)
}

#' @export
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

getMissingSites <- function(files) {
  files %>%
    dplyr::group_by(site) %>%
    dplyr::summarise(nbrOfFiles = sum(exists)) %>%
    dplyr::filter(nbrOfFiles < 3)
}

getSites <- function(files) {
  files %>%
    dplyr::group_by(site) %>%
    dplyr::summarise(nbrOfFiles = sum(exists)) %>%
    dplyr::filter(nbrOfFiles == 3)
}

loadParameters <- function(filename) {
  # Load definition of sites
  col_types <- readr::cols(
    site = readr::col_character(),
    catalog = readr::col_character(),
    details = readr::col_character(),
    orders = readr::col_character(),
    delimiter = readr::col_character(),
    hasIds = readr::col_logical(),
    isCents = readr::col_logical()
  )

  # Load parameters
  df <- readr::read_csv(filename, col_types = col_types)
  message(paste("Found", nrow(df), "sites"))
  return(df)
}
