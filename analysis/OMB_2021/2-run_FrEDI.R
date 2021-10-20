# Run FrEDI  with CONUS temperatures relative to 1986-2005

# CH
# 10/20/2021

# install.packages("devtools")
# remove.packages("") 

library(devtools)
library(dplyr)

install.packages("C:/Users/chartin/OneDrive - Environmental Protection Agency (EPA)/Documents/GitHub/FrEDI/", repo=NULL, type = "source")

require(FrEDI)

scenariosPath <- system.file(package="FrEDI") %>% 
  file.path("extdata","scenarios")
scenariosPath %>% 
  list.files
tempInputFile <- "1-rcp26.csv"
popInputFile  <- scenariosPath %>% 
  file.path("pop_scenario.csv")

### Import inputs
example_inputsList <- import_inputs(
  tempfile = tempInputFile,
)

customScenarioInputs <- import_inputs(tempfile = tempInputFile)
run_fredi(inputsList= customScenarioInputs, aggLevels="none")  %>% 
  write.csv(file = "2-FrEDI_rcp26.csv", row.names = F)

#### Scenario #2 ####
tempInputFile <- "1-rcp45.csv"

example_inputsList <- import_inputs(
  tempfile = tempInputFile,
)

customScenarioInputs <- import_inputs(tempfile = tempInputFile)
run_fredi(inputsList= customScenarioInputs, aggLevels="none") %>% 
  write.csv(file = "2-FrEDI_rcp45.csv", row.names = F)

#### Scenario #3 ####
tempInputFile <- "1-rcp60.csv"

example_inputsList <- import_inputs(
  tempfile = tempInputFile,
)

customScenarioInputs <- import_inputs(tempfile = tempInputFile)
run_fredi(inputsList= customScenarioInputs, aggLevels="none") %>% 
  write.csv(file = "2-FrEDI_rcp60.csv", row.names = F)


#### Scenario #3 ####
tempInputFile <- "1-rcp85.csv"

example_inputsList <- import_inputs(
  tempfile = tempInputFile,
)

customScenarioInputs <- import_inputs(tempfile = tempInputFile)
run_fredi(inputsList= customScenarioInputs, aggLevels="none") %>% 
  write.csv(file = "2-FrEDI_rcp85.csv", row.names = F)






