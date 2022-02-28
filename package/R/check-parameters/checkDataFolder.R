checkDataFolder <- function(folder) {
  if (!dir.exists(folder)) stop(paste("Data folder ", folder, " not found"))
}
