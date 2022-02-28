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
