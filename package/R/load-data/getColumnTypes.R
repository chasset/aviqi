getColumnTypes <- function(hasIds, table) {
  types <- NULL
  if (table == "catalog") types <- "dcc"
  if (table == "orders") types <- "cD"
  if (table == "details") types <- "cdc"
  if (hasIds) types <- paste("i", types, sep = "")
  types
}
