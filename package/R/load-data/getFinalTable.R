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
