#' Check values in catalog
#'
#' Process multiple checks on the table.
#' @param catalog A dataframe describing the catalog
#' @param site Source of the data (usually a website)
#' @return Dataframe of the catalog
checkCatalog <- function(catalog, site) {
  # EAN are usually all defined
  naS <- catalog %>%
    dplyr::filter(is.na(ean)) %>%
    nrow()
  if (naS > 0) {
    incErrorsPolicy(3)
    message("EAN are not all defined in catalog of site ", site)
  }

  # EAN are always unique
  l <- catalog %>% nrow()
  u <- catalog %>%
    dplyr::distinct(ean) %>%
    nrow()
  if (l == u) {
    message("EAN in ", site, " catalog are unique")
  } else {
    incErrorsPolicy(3)
    message("Multiple definition of EAN in ", site, " catalog")
  }

  # Usually, prices are more than 0€ and less than 300€
  highPriceWarn <- catalog %>%
    dplyr::filter(price > 300, price < 1000) %>%
    nrow()
  if (highPriceWarn > 0) {
    incErrorsPolicy(3)
    message("In ", site, " catalog, ", highPriceWarn, " prices are between 300 and 1000€")
  }

  # All EAN has always a price
  # Prices are never negative, nor greater than 1000€
  neverPriceWarn <- catalog %>%
    dplyr::filter(price < 0 | price > 1000) %>%
    nrow()
  if (neverPriceWarn > 0) {
    incErrorsPolicy(3)
    message("In ", site, " catalog, ", neverPriceWarn, " prices are below 0€ or greater than 1000€")
  }

  return(catalog)
}

#' Check values in orders
#'
#' Process multiple checks on the table.
#' @param orders A dataframe describing the orders
#' @param site Source of the data (usually a website)
#' @return Dataframe of the orders
checkOrders <- function(orders, site) {
  #-- orders --#
  # ordersId are always defined
  # ordersId are always unique
  if (orders %>% nrow() != orders %>%
    dplyr::distinct(orderId) %>%
    nrow()) {
    stop("Multiple definition of orders in ", site, " orders")
  }
  # orders has always a date
  # date are never less than 2000, nor greater than today
  # date are usually from one year before until today
  return(orders)
}

#' Check values in order details
#'
#' Process multiple checks on the table.
#' @param details A dataframe describing the order details
#' @return Dataframe of the order details
checkDetails <- function(details) {
  return(details)
}

#' Check files of one site
#'
#' Identify the files missing some sites.
#' @param missing A dataframe describing missing sources
checkIfOneSiteMissing <- function(missing) {
  if (nrow(missing) > 0) {
    message(
      "Missing data for the following sites: ",
      paste(c(missing$site), collapse = ", ")
    )
    incErrorsPolicy(4)
  }
  return(NULL)
}

#' Check all files
#'
#' Identify the files missing some sites.
#' @param files Dataframe describing files to load
#' @return Dataframe describing files to load
checkMissingSites <- function(files) {
  files %>%
    getMissingSites() %>%
    checkIfOneSiteMissing()
  return(files)
}

