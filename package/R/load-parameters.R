#' @export
filterCompleteSites <- function(files) {
  sites <- files %>% getSites()
  files %>% filter(site %in% sites$site)
}

#' @export
getFiles <- function() {
  parametersFile %>%
    loadParameters() %>%
    pivot_longer(cols = catalog:orders, names_to = "table") %>%
    mutate(
      filename = paste0(dataFolder, "/", site, "_", value, ".csv", sep = "")
    ) %>%
    rowwise() %>%
    mutate(exists = file.exists(filename))
}

getMissingSites <- function(files) {
  files %>%
    group_by(site) %>%
    summarise(nbrOfFiles = sum(exists)) %>%
    filter(nbrOfFiles < 3)
}

getSites <- function(files) {
  files %>%
    group_by(site) %>%
    summarise(nbrOfFiles = sum(exists)) %>%
    filter(nbrOfFiles == 3)
}

loadParameters <- function(filename) {
  # Load definition of sites
  col_types <- cols(
    site = col_character(),
    catalog = col_character(),
    details = col_character(),
    orders = col_character(),
    delimiter = col_character(),
    hasIds = col_logical(),
    isCents = col_logical()
  )

  # Load parameters
  df <- read_csv(parametersFile, col_types = col_types)
  message(paste("Found", nrow(df), "sites"))
  df
}

#' @export
loadSites <- function(files) {
  sites <- unique(files$site)
  all <- NULL
  for (site in fullSites$site) {
    if (is.null(all)) {
      all <- loadSite(site)
    } else {
      current <- loadSite(site)
      all <- all %>% bind_rows(current)
    }
  }
  all
}
