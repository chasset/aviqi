getColumnNames <- function(hasIds, table) {
  names <- NULL
  if (table == "catalog") names <- c("price", "name", "ean")
  if (table == "orders") names <- c("orderId", "date")
  if (table == "details") names <- c("orderId", "quantity", "ean")
  if (hasIds) names <- c("id", names)
  return(names)
}

getColumnTypes <- function(hasIds, table) {
  types <- NULL
  if (table == "catalog") types <- "dcc"
  if (table == "orders") types <- "cD"
  if (table == "details") types <- "cdc"
  if (hasIds) types <- paste("i", types, sep = "")
  return(types)
}

getDelimiter <- function(delim) {
  sep <- NULL
  if (delim == "C") {
    sep <- ","
  }
  if (delim == "S") {
    sep <- ";"
  }
  if (delim == "T") {
    sep <- "\t"
  }
  return(sep)
}

selectColumns <- function(table) {
  getColumnNames(F, table)
}

getFinalTable <- function(orders, details, catalog, site) {
  firstDayOfMonth <- getOption("aviqi.firstDayOfMonth")
  orders %>%
    dplyr::filter(
      lubridate::year(date) == lubridate::year(firstDayOfMonth), 
      lubridate::month(date) == lubridate::month(firstDayOfMonth)
    ) %>%
    dplyr::right_join(details, by = c("orderId")) %>%
    dplyr::group_by(ean) %>%
    dplyr::summarise(
      quantity = sum(quantity)
    ) %>%
    dplyr::left_join(catalog, by = c("ean")) %>%
    dplyr::mutate(
      amount = quantity * price,
      site = site
    ) %>%
    dplyr::select(
      site,
      ean,
      name,
      quantity,
      price,
      amount
    )
}

loadTable <- function(files, site, table) {
  filter <- files$site == site & files$table == table
  delim <- getDelimiter(files$delimiter[filter])
  hasIds <- files$hasIds[filter]
  isCents <- files$isCents[filter]
  filename <- files$filename[filter]
  columns <- getColumnNames(hasIds, table)
  select <- selectColumns(table)
  types <- getColumnTypes(hasIds, table)
  df <- readr::read_delim(
    file = filename,
    delim = delim,
    col_names = columns,
    col_select = all_of(select),
    col_types = types,
    skip = 1
  )
  if (isCents && table == "catalog") {
    df <- df %>% dplyr::mutate(price = price / 100)
  }
  return(df)
}

loadSite <- function(files, site) {
  message("Processing site ", site)

  # Load all tables of the site
  catalog <- loadTable(files, site, "catalog") %>% checkCatalog(site)
  details <- loadTable(files, site, "details") %>% checkDetails()
  orders <- loadTable(files, site, "orders") %>% checkOrders()

  # Build result table
  getFinalTable(orders, details, catalog, site)
}

#' @export
loadSites <- function(files) {
  sites <- unique(files$site)
  all <- NULL
  for (site in sites) {
    if (is.null(all)) {
      all <- loadSite(files, site)
    } else {
      current <- loadSite(files, site)
      all <- all %>% dplyr::bind_rows(current)
    }
  }
  return(all)
}
