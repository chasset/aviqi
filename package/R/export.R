# Export dataframe to CSV
#' @export
exportOutput <- function(df) {
  outputFilename <- getOption("aviqi.outputFilename")
  readr::write_delim(x = df, file = outputFilename, delim = ";")
  return(df)
}
