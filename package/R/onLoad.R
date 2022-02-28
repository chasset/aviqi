.onLoad <- function(libname, pkgname) {
  if (file.exists(".env")) {
    dotenv::load_dot_env()
    op <- options()
    opAviqi <- list(
      aviqi.firstDayOfMonth = as_date(Sys.getenv("FIRSTDAYOFMONTH")),
      aviqi.chosenPolicy = as.numeric(Sys.getenv("CHOSENPOLICY")),
      aviqi.outputFilename = Sys.getenv("OUTPUTFILENAME"),
      aviqi.dataFolder = Sys.getenv("DATAFOLDER"),
      aviqi.parametersFile = Sys.getenv("SITES"),
      aviqi.policies = data.frame(
        policy = c(
          "Skip all errors",
          "Stop if unsual values are encountered",
          "Stop if extreme values are encountered",
          "Stop if one file is missing for a site"
        ),
        hitted = c(0, 0, 0, 0)
      )
    )
    toset <- !(names(opAviqi) %in% names(op))
    if (any(toset)) options(opAviqi[toset])
  } else {
    stop("No .env file found. Please reload the library in the right folder")
  }
}
