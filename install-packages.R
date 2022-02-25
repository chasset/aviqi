args <- commandArgs(trailingOnly=TRUE)

depot <- args[1]

packages <- args[2:length(args)]

for (package in packages) {
    if (!require(package, character.only = T)) {
        message(paste('Package install', package))
        if (depot == "GITHUB") {
            library(devtools)
            install_github(package)
        }
        if (depot == "CRAN") {
            install.packages(pkgs = package, repos = "https://cloud.r-project.org/", dependencies = TRUE)
            if (!require(package, character.only = T))
                stop(paste("Problem followint package", package, "install"))
        }
    } else {
        message(paste(package, 'is already installed'))
    }
}
