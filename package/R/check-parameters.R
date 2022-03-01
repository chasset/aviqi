#' Check policy choice
#'
#' Check if the choosen policy describes in .env file exists.
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

#' Check Data folder
#'
#' Check if the data folder exists.
checkDataFolder <- function() {
  folder <- getOption("aviqi.dataFolder")
  if (!dir.exists(folder)) stop(paste("Data folder ", folder, " not found"))
  return(NULL)
}

#' Check Parameter file
#'
#' Check if the parameter file exists.
checkParametersFile <- function() {
  filename <- getOption("aviqi.parametersFile")
  if (!file.exists(filename)) stop(paste("Parameters file ", filename, " doesn’t exist"))
  return(NULL)
}

#' Print loaded parameters
printParameters <- function() {
  message(
    "In '.env', parameters tell us that data are stored in '",
    getOption("aviqi.dataFolder"),
    "' and they will be agregated and filtered to the month ",
    getOption("aviqi.month"),
    " of the year ",
    getOption("aviqi.year"),
    " and exported to '",
    getOption("aviqi.outputFilename"),
    "'"
  )
}