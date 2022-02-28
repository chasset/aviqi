#' @export
checkChosenPolicy <- function() {
  policy <- getOption("aviqi.chosenPolicy")
  policies <- getOption("aviqi.policies")
  if (policy > 0 && policy <= nrow(policies)) {
    message("Chosen policy: ", policies$policy[policy])
  } else {
    stop("Wrong policy index. Choose between 1 and ", nrow(policies))
  }
  return(NULL)
}

#' @export
checkDataFolder <- function() {
  folder <- getOption("aviqi.dataFolder")
  if (!dir.exists(folder)) stop(paste("Data folder ", folder, " not found"))
  return(NULL)
}

#' @export
checkParametersFile <- function() {
  filename <- getOption("aviqi.parametersFile")
  if (!file.exists(filename)) stop(paste("Parameters file ", filename, " doesn’t exist"))
  return(NULL)
}

printParameters <- function() {
  message(
    "In ",
    getOption("aviqi.parametersFile"),
    ", parameters tell us that data are stored in ",
    getOption("aviqi.dataFolder"),
    " and they will be agregated and filtered to the month ",
    getOption("aviqi.firstDayOfMonth"),
    " and exported to ",
    getOption("aviqi.outputFilename")
  )
}