#' @export
checkChosenPolicy <- function() {
  policy <- getOption("aviqi.chosenPolicy")
  if (policy > 0 && policy <= nrow(policies)) {
    message("Chosen policy: ", policies$policy[policy])
  } else {
    stop("Wrong policy index. Choose between 1 and ", nrow(policies))
  }
}

#' @export
checkDataFolder <- function()) {
  folder <- getOption("aviqi.dataFolder")
  if (!dir.exists(folder)) stop(paste("Data folder ", folder, " not found"))
}

#' @export
checkParametersFile <- function() {
  filename <- getOption("aviqi.parametersFile")
  if (!file.exists(filename)) stop(paste("Parameters file ", filename, " doesn’t exist"))
}
