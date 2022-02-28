require(readr)

# Export dataframe to CSV
#' @export
export <- function(df) {
  readr::write_csv(x = df, file = outputFilename, delim = ";")
  df
}
