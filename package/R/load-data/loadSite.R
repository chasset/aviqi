loadSite <- function(site) {
  message("Processing site ", site)

  # Load all tables of the site
  catalog <- loadTable(site, "catalog") %>% checkCatalog()
  details <- loadTable(site, "details") %>% checkDetails()
  orders <- loadTable(site, "orders") %>% checkOrders()

  # Build result table
  getFinalTable(orders, details, catalog)
}
