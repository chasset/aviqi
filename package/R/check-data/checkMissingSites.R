checkMissingSites <- function(files) {
  files %>%
    getMissingSites() %>%
    checkIfOneSiteMissing()
}
