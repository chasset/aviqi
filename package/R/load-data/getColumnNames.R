getColumnNames <- function(hasIds, table) {
  names <- NULL
  if (table == "catalog") names <- c("price", "name", "ean")
  if (table == "orders") names <- c("orderId", "date")
  if (table == "details") names <- c("orderId", "quantity", "ean")
  if (hasIds) names <- c("id", names)
  names
}
