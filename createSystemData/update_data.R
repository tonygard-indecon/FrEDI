## Update Data
library(tidyverse)
library(lubridate)
library(piggyback)

projectPath      <- "./createSystemData/"
dataOutPath      <- projectPath %>% file.path("data")

## Get latest updated data
latest_release_fredi_Data <- piggyback::pb_releases(repo = "USEPA/FrEDI_data") |>
                             filter(published_at == max(published_at))

## Grab data from latest release
pb_download(repo = "USEPA/FrEDI_data",
            tag = latest_release_fredi_Data$release_name,
            dest = tempdir())

file.copy(
  from = file.path(tempdir(),"sysdata.rda"),
  to = dataOutPath
)
