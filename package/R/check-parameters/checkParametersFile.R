checkParametersFile <- function(filename) {
  if (!file.exists(filename)) stop(paste("Parameters file ", filename, " doesn’t exist"))
}
