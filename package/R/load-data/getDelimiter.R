getDelimiter <- function(delim) {
  sep <- NULL
  if (delim == "C") {
    sep <- ","
  }
  if (delim == "S") {
    sep <- ";"
  }
  if (delim == "T") {
    sep <- "\t"
  }
  sep
}
