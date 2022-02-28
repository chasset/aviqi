checkCatalog <- function(catalog, site) {
  # EAN are usually all defined
  check <- catalog %>%
    filter(is.na(ean)) %>%
    nrow()
  if (check > 0) {
    if (policy > 2) {
      stop("")
    }
  }
  # EAN are always unique
  if (check == catalog %>%
    distinct(ean) %>%
    nrow()) {
    message("EAN in ", site, " catalog are unique")
  } else {
    stop("Multiple definition of EAN in ", site, " catalog")
  }
  # All EAN has always a price
  # Prices are never negative, nor greater than 1000€
  neverPriceWarn <- catalog %>%
    filter(price < 0 | price > 1000) %>%
    nrow()
  if (neverPriceWarn > 0) {
    stop("In ", site, " catalog, ", neverPriceWarn, " prices are below 0€ or greater than 1000€")
  }
  # Usually, prices are more than 0€ and less than 300€
  highPriceWarn <- catalog %>%
    filter(price > 300, price < 1000) %>%
    nrow()
  if (highPriceWarn > 0) {
    warning("In ", site, " catalog, ", highPriceWarn, " prices are between 300 and 1000€")
  }
  catalog
}
