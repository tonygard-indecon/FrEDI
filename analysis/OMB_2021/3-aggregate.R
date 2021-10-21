# Aggregate FrEDI impacts to level we are interested in
# National Totals
# Physical Impacts

# CH
# 10/21/2021


temp_rcp26 <- read.csv("2-FrEDI_rcp26.csv", sep = ",") %>% 
  aggregate_impacts(columns = c("physical_impacts","annual_impacts"), 
                    aggLevels = c("national", "modelAverage", 'impactyear')) %>% 
  filter(adaptation %in% c("2011 Emissions",  "N/A", "Adaptation")) %>% 
  filter(region == "National Total") %>% 
  filter(model == "Average") %>% 
  filter(sector %in% c("Air Quality", "Extreme Temperature","Southwest Dust", "Valley Fever","Wildfire")) %>% 
  select(sector, impactType,physicalmeasure, year, physical_impacts, annual_impacts) %>% 
  mutate(scenario = "RCP26")


temp_rcp45 <- read.csv("2-FrEDI_rcp45.csv", sep = ",") %>% 
  aggregate_impacts(columns = c("physical_impacts","annual_impacts"), 
                    aggLevels = c("national", "modelAverage", "impactyear")) %>% 
  filter(adaptation %in% c("2011 Emissions", "N/A", "Adaptation")) %>% 
  filter(region == "National Total") %>% 
  filter(model == "Average") %>% 
  filter(sector %in% c("Air Quality", "Extreme Temperature","Southwest Dust", "Valley Fever","Wildfire")) %>% 
  select(sector, impactType,physicalmeasure, year, physical_impacts, annual_impacts) %>% 
  mutate(scenario = "RCP45")


temp_rcp60 <- read.csv("2-FrEDI_rcp60.csv", sep = ",") %>% 
  aggregate_impacts(columns = c("physical_impacts","annual_impacts"), 
                    aggLevels = c("national", "modelAverage","impactyear")) %>% 
  filter(adaptation %in% c("2011 Emissions", "N/A", "Adaptation")) %>% 
  filter(region == "National Total") %>% 
  filter(model == "Average") %>% 
  filter(sector %in% c("Air Quality", "Extreme Temperature","Southwest Dust", "Valley Fever","Wildfire")) %>% 
  select(sector, impactType,physicalmeasure, year, physical_impacts, annual_impacts) %>% 
  mutate(scenario = "RCP60")


temp_rcp85 <- read.csv("2-FrEDI_rcp85.csv", sep = ",") %>% 
  aggregate_impacts(columns = c("physical_impacts","annual_impacts"), 
                    aggLevels = c("national", "modelAverage","impactyear")) %>% 
  filter(adaptation %in% c("2011 Emissions", "N/A", "Adaptation")) %>% 
  filter(region == "National Total") %>% 
  filter(model == "Average") %>% 
  filter(sector %in% c("Air Quality", "Extreme Temperature","Southwest Dust", "Valley Fever","Wildfire")) %>% 
  select(sector, impactType,physicalmeasure, year, physical_impacts, annual_impacts) %>% 
  mutate(scenario = "RCP85")


# Combine dfs, convert to billions

combined <- as_tibble(rbind(temp_rcp26,temp_rcp45, temp_rcp60, temp_rcp85)) %>% 
  mutate(annual_impacts = annual_impacts/10^9) 

write.csv(combined, "3-RCP_impacts.csv", row.names=F)
