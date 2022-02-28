# Export dataframe to CSV
#' @export
export <- function(df) {
  write_csv(x = df, file = outputFilename, delim = ";")
  df
}
