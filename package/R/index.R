library(tidyverse)
library(lubridate)
library(dotenv)

# Parameters
firstDayOfMonth <- as_date(Sys.getenv('FIRSTDAYOFMONTH'))
chosenPolicy <- Sys.getenv('CHOSENPOLICY')
outputFilename <- Sys.getenv('OUTPUTFILENAME')
dataFolder <- Sys.getenv('DATAFOLDER')
parametersFile <- Sys.getenv('SITES')

# Other global variables
policies <- data.frame(
  policy = c(
    'Skip all errors',
    'Stop if unsual values are encountered',
    'Stop if extreme values are encountered',
    'Stop if one file is missing for a site'
  ),
  hitted = c(NA, 0, 0, 0)
)

#-- Main --#

# Some checks
checkParametersFile(parametersFile)
checkDataFolder(dataFolder)
checkChosenPolicy(chosenPolicy)

# Prepare jobs
parametersFile %>%
  getFiles() %>%
  checkMissingSites() %>%
  filterCompleteSites() %>%
  select(-exists, -value) %>%
  stopOrGo(chosenPolicy) %>%
  loadSites() %>%
  export()
