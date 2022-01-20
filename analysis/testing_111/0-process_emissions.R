# Process Emissions for Power Sector Strategy

# 1/19/2021
# CH

library(readxl)
library(tidyr)
library(dplyr)
library(ggplot2)

#### Import data

ref <- read_xlsx("EPA620_BC_1k State Emissions.xlsx", sheet = "All Units" ) %>%
  slice(5,56,)  # pull out the year and nationwide values
#column 42-49 CO2 values
  ref <- t(ref[ , 42:49]) %>% 
    as.data.frame() %>% 
    mutate(scenario = "ref") %>% 
    rename("value"= "V2") %>% 
    rename("year" = "V1")
  
scen_6g <- read_xlsx("EPA620_Scoping_6g State Emissions v2.xlsx", sheet = "All Units" ) %>%
  slice(5,56,)  # pull out the year and nationwide values
#column 42-49 CO2 values
scen_6g <- t(scen_6g[ , 42:49]) %>% 
  as.data.frame() %>% 
  mutate(scenario = "scen_6g") %>% 
  rename("value"= "V2") %>% 
  rename("year" = "V1")

scen_14c <- read_xlsx("EPA620_Scoping_14c State Emissions v2.xlsx", sheet = "All Units" ) %>%
  slice(5,56,)  # pull out the year and nationwide values
#column 42-49 CO2 values
scen_14c <- t(scen_14c[ , 42:49]) %>% 
  as.data.frame() %>% 
  mutate(scenario = "scen_14c") %>% 
  rename("value"= "V2") %>% 
  rename("year" = "V1")

scenarios = rbind(ref, scen_6g, scen_14c)
scen <- scenarios %>% 
  select(scenario)
scenarios <- scenarios %>% 
  select(-scenario) %>% 
  sapply(as.numeric) %>%  
  cbind(scen)


############
# Convert units
############
# million short tons CO2 to GtC * 10^6
# 1 short-ton equals 9.0718474E-10 gigatonne

scenarios <- scenarios %>% 
  mutate(mill_st = value *10^6) %>% 
  mutate(GtCO2 = mill_st * 9.0718474E-10) %>% 
  mutate(GtC = GtCO2 * (12/44)) #convert C to CO2

############
# Subtract 
# policy from ref
############

diff <- scenarios %>% 
  select(year, GtC, scenario) %>% 
  pivot_wider(values_from = "GtC",
              names_from = "scenario") %>% 
  mutate(diff_scen6g = ref - scen_6g) %>% 
  mutate(diff_scen14c = ref - scen_14c) 

# next up run Hector under 3ECS values
# can i set via code the values in the SSP370 file. 
