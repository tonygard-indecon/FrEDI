# Process FaIR temperature data

# 10/20/2021
# CH

library(tidyr)
library(dplyr)
library(ggplot2)
#### Import data


rcp85 <- as_tibble(read.csv("input/temp_data_85.csv")) %>%
                  pivot_longer(col = starts_with("X"),
                 names_to = "year",
                 names_prefix = "X",
                 values_to = "value" ) %>%
  mutate(scenario = "RCP85")

rcp85$year <- as.integer(rcp85$year)


rcp60 <- as_tibble(read.csv("input/temp_data_60.csv")) %>%
  pivot_longer(col = starts_with("X"),
               names_to = "year",
               names_prefix = "X",
               values_to = "value" ) %>%
  mutate(scenario = "RCP60")

rcp60$year <- as.integer(rcp60$year)

rcp45 <- as_tibble(read.csv("input/temp_data_45.csv")) %>%
  pivot_longer(col = starts_with("X"),
               names_to = "year",
               names_prefix = "X",
               values_to = "value" ) %>%
  mutate(scenario = "RCP45")

rcp45$year <- as.integer(rcp45$year)

rcp26 <- as_tibble(read.csv("input/temp_data_26.csv")) %>%
  pivot_longer(col = starts_with("X"),
               names_to = "year",
               names_prefix = "X",
               values_to = "value" ) %>%
  mutate(scenario = "RCP26") 
 
  rcp26$year <- as.numeric(rcp26$year)

 #### Plot up Temperature  ####
 combine <- rbind(rcp26,rcp45, rcp60, rcp85)
  
temps <- ggplot(combine, aes(year, value,  color = scenario)) +
  geom_line(size = 2) +
  xlim(2015,2100)+
   ylim(0, 5.5) +
  scale_color_manual(values=c("Blue2","Green3", "Orange3", "Red2")) +
   theme_minimal() +
   theme(text = element_text(size = 15))
temps 

ggsave("GMT.png", width = 5, height = 4)

#### Convert to CONUS ####
#  Global to CONUS mean temperature change estimated as CONUS Temp = 1.42*GMT
rcp85 <- mutate(rcp85, value = (value * 1.42))
rcp60 <- mutate(rcp60, value = (value * 1.42))
rcp45 <- mutate(rcp45, value = (value * 1.42))
rcp26 <- mutate(rcp26, value = (value * 1.42))

 #### Temperature relative to 1986-2005 ####
avg <- filter(rcp26, year %in% c(1986:2005)) 
avg <- mean(avg$value)

 rcp26 <- mutate(rcp26, value = value - avg) %>% 
   filter(year >1996 & year < 2101)
 rcp45 <- mutate(rcp45, value = value - avg) %>% 
   filter(year >1996 & year < 2101)
 rcp60 <- mutate(rcp60, value = value - avg)%>% 
   filter(year >1996 & year < 2101)
 rcp85 <- mutate(rcp85, value = value - avg)%>% 
   filter(year >1996 & year < 2101)
 
 #### Save outputs ####
write.csv(rcp26, file = "1-rcp26.csv", row.names = F)
write.csv(rcp45, file = "1-rcp45.csv", row.names = F)
write.csv(rcp60, file = "1-rcp60.csv", row.names = F)
write.csv(rcp85, file = "1-rcp85.csv", row.names = F)
