checkChosenPolicy <- function(policy) {
  if (policy > 0 && policy <= nrow(policies)) {
    message("Chosen policy: ", policies$policy[policy])
  } else {
    stop("Wrong policy index. Choose between 1 and ", nrow(policies))
  }
}

checkParametersFile <- function(filename) {
  if (!file.exists(filename)) stop(paste("Parameters file ", filename, " doesn’t exist"))
}

checkDataFolder <- function(folder) {
  if (!dir.exists(folder)) stop(paste("Data folder ", folder, " not found"))
}

incErrorsPolicy <- function(policy) {
  # voir les erreurs du niveau supérieur
  l <- nrow(policies)
  policies$hitted[policy] <- policies$hitted[policy] + 1
}

stopOrGo <- function(df, policy) {
  if (policies$hitted[policy] > 0) stop(policies$policy[policy], "has been hitted ", policies$hitted[policy], " times")
  df
}
