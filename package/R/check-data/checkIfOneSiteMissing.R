checkIfOneSiteMissing <- function(missing) {
  if (nrow(missing) > 0) {
    message(
      "Missing data for the following sites: ",
      paste(c(missing$site), collapse = ", ")
    )
    incErrorsPolicy(4)
  }
  missing
}
