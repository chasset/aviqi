getMissingSites <- function(files) {
  files %>%
    group_by(site) %>%
    summarise(nbrOfFiles = sum(exists)) %>%
    filter(nbrOfFiles < 3)
}
