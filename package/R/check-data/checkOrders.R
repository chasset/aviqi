checkOrders <- function(orders) {
  #-- orders --#
  # ordersId are always defined
  # ordersId are always unique
  if (orders %>% nrow() != orders %>%
    distinct(orderId) %>%
    nrow()) {
    stop("Multiple definition of orders in ", site, " orders")
  }
  # orders has always a date
  # date are never less than 2000, nor greater than today
  # date are usually from one year before until today
  orders
}
