getColumnNames <- function(hasIds, table) {
  names <- NULL
  if (table == "catalog") names <- c("price", "name", "ean")
  if (table == "orders") names <- c("orderId", "date")
  if (table == "details") names <- c("orderId", "quantity", "ean")
  if (hasIds) names <- c("id", names)
  names
}

getColumnTypes <- function(hasIds, table) {
  types <- NULL
  if (table == "catalog") types <- "dcc"
  if (table == "orders") types <- "cD"
  if (table == "details") types <- "cdc"
  if (hasIds) types <- paste("i", types, sep = "")
  types
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
  sep
}

getFinalTable <- function(orders, details, catalog) {
  orders %>%
    filter(year(date) == year(firstDayOfMonth), month(date) == month(firstDayOfMonth)) %>%
    right_join(details, by = c("orderId")) %>%
    group_by(ean) %>%
    summarise(
      quantity = sum(quantity)
    ) %>%
    left_join(catalog, by = c("ean")) %>%
    mutate(
      amount = quantity * price,
      site = site
    ) %>%
    select(site, ean, name, quantity, price, amount)
}

loadSite <- function(site) {
  message("Processing site ", site)

  # Load all tables of the site
  catalog <- loadTable(site, "catalog") %>% checkCatalog()
  details <- loadTable(site, "details") %>% checkDetails()
  orders <- loadTable(site, "orders") %>% checkOrders()

  # Build result table
  getFinalTable(orders, details, catalog)
}

loadTable <- function(site, table) {
  filter <- data$site == site & data$table == table
  delim <- getDelimiter(data$delimiter[filter])
  hasIds <- data$hasIds[filter]
  isCents <- data$isCents[filter]
  filename <- data$filename[filter]
  columns <- getColumnNames(hasIds, table)
  select <- selectColumns(table)
  types <- getColumnTypes(hasIds, table)
  df <- read_delim(
    file = filename,
    delim = delim,
    col_names = columns,
    col_select = all_of(select),
    col_types = types,
    skip = 1
  )
  if (isCents && table == "catalog") {
    df <- df %>% mutate(price = price / 100)
  }
  df
}

selectColumns <- function(table) {
  getColumnNames(F, table)
}
