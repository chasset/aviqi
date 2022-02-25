
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
  message(paste('Found', nrow(df), "sites"))

  return(df)
}

# From a parameter file, get a dataframe with all files involved
getFiles <- function(file) file %>%
  loadParameters() %>%
  pivot_longer(cols = catalog:orders, names_to = 'table') %>%
  mutate(
    filename = paste0(dataFolder, '/', site, '_', value, '.csv', sep = '')
  ) %>%
  rowwise() %>%
  mutate(exists = file.exists(filename))

checkIfOneSiteMissing <- function(missing) {
  if (nrow(missing) > 0) {
    message('Missing data for the following sites: ', paste(c(missing$site), collapse = ', '))
    incErrorsPolicy(4)
  }
}

getMissingSites <- function(files) files %>%
  group_by(site) %>%
  summarise(nbrOfFiles = sum(exists)) %>%
  filter(nbrOfFiles < 3)

checkMissingSites <- function(files) {
  files %>% getMissingSites() %>% checkIfOneSiteMissing()
  return(files)
}

getSites <- function(files) files %>%
  group_by(site) %>%
  summarise(nbrOfFiles = sum(exists)) %>%
  filter(nbrOfFiles == 3)

filterCompleteSites <- function(files) {
  sites <- files %>% getSites()
  completed <- files %>% filter(site %in% sites$site)
  return(completed)
}

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
  return(all)
}
