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
