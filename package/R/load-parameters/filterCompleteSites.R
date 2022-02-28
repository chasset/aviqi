filterCompleteSites <- function(files) {
  sites <- files %>% getSites()
  files %>% filter(site %in% sites$site)
}
