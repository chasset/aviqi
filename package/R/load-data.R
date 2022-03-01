#' Get column names
#'
#' Identify column names based on the table type.
#' @param hasIds A boolean identifying a table with a column id
#' @param table The table type
#' @return Vector of column names
getColumnNames <- function(hasIds, table) {
  names <- NULL
  if (table == "catalog") names <- c("price", "name", "ean")
  if (table == "orders") names <- c("orderId", "date")
  if (table == "details") names <- c("orderId", "quantity", "ean")
  if (hasIds) names <- c("id", names)
  return(names)
}

#' Get column types
#'
#' Identify column types based on the table type: c for character, i for integer…
#' @param hasIds A boolean identifying a table with a column id
#' @param table The table type
#' @return Vector of column types
getColumnTypes <- function(hasIds, table) {
  types <- NULL
  if (table == "catalog") types <- "dcc"
  if (table == "orders") types <- "cD"
  if (table == "details") types <- "cdc"
  if (hasIds) types <- paste("i", types, sep = "")
  return(types)
}

#' Get delimiter
#'
#' Identify delimiter used in the CSV file
#' @param delim Delimiter code defined in parameters
#' @return Character used to delimit fields in a file
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

#' Get column names (without id field)
#'
#' Identify column names based on the table type. Removed id fields if it exists.
#' @param table The table type
#' @return Vector of column names
selectColumns <- function(table) {
  getColumnNames(FALSE, table)
}

#' Merge tables of a site
#'
#' Take the 3 files of a site - catalog, orders and details -
#' and apply a filter, a join and an agregation.
#' @param orders Dataframe describing orders
#' @param details Dataframe describing order details
#' @param catalog Dataframe describing products catalog
#' @param site Source of the data (usually a website)
#' @return Dataframe of the site
getFinalTable <- function(orders, details, catalog, site) {
  orders %>%
    dplyr::right_join(details, by = c("orderId")) %>%
    dplyr::filter(
      lubridate::year(date) == getOption("aviqi.year"),
      lubridate::month(date) == getOption("aviqi.month")
    ) %>%
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

#' Load CSV file
#'
#' The output has the right column names, types and units.
#' @param files Dataframe describing files to load
#' @param site Source of the data (usually a website)
#' @return Dataframe of the file content
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
  # Correct prices described in cents
  if (isCents && table == "catalog") {
    df <- df %>% dplyr::mutate(price = price / 100)
  }
  return(df)
}

#' Load a site
#'
#' Load the 3 files of a site: catalog, orders and details.
#' @param files Dataframe describing files to load
#' @param site Source of the data (usually a website)
#' @return Dataframe of the site
loadSite <- function(files, site) {
  message("Processing site ", site)

  # Load all tables of the site
  catalog <- loadTable(files, site, "catalog") %>% checkCatalog(site)
  details <- loadTable(files, site, "details") %>% checkDetails()
  orders <- loadTable(files, site, "orders") %>% checkOrders()

  # Build result table
  getFinalTable(orders, details, catalog, site)
}

#' Load all sites
#'
#' Load all sites described in parameters.
#' @param files Dataframe describing files to load
#' @return Dataframe of all sites
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
