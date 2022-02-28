getFiles <- function(file) {
  file %>%
    loadParameters() %>%
    pivot_longer(cols = catalog:orders, names_to = "table") %>%
    mutate(
      filename = paste0(dataFolder, "/", site, "_", value, ".csv", sep = "")
    ) %>%
    rowwise() %>%
    mutate(exists = file.exists(filename))
}
