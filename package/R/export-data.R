# Export dataframe to CSV
export <- function(df) {
  write_csv(x = df, file = outputFilename, delim = ';')
  return(df)
}
