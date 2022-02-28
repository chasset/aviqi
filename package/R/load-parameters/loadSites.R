loadSites <- function(files) {
  sites <- unique(files$site)
  all <- NULL
  for (site in fullSites$site) {
    if (is.null(all)) {
      all <- loadSite(site)
    } else {
      current <- loadSite(site)
      all <- all %>% bind_rows(current)
    }
  }
  all
}
