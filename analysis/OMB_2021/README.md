The data provided in this folder corresponds to the inputs and outputs for Scott Burgess OMB EOP using FrEDI v2.0. October 2021.

Temperature inputs from the climate emulator FaIR v1.6.2 for the 4 RCPs (RCP26, RCP45, RCP60, RCP85)
https://github.com/OMS-NetZero/FAIR

For more information on FrEDI: www.epa.gov/cira/fredi

5 sectors:
Air Quality - Premature Mortality from Ozone and PM2.5
Extreme Temperature - Premature Mortality from cold and hot
Southwest Dust - Premature Mortality, Hospitalization costs (cardiovasular, respiratory, asthma)
Valley Fever - Premature Mortality, Morbidity (cost of illness)
Wildfire - Premature Mortality, Morbidity (hospitalization costs)

Premature Mortality - valuation measure is VSL

Adaptation Assumptions:
Air Quality - 2011 Air Pollutant Emissions Level
Extreme Temperature - Adaptation
Southwest Dust, Valley Fever, Wildfire - No Adaptation

Output 3-RCP_impacts.csv
sector, impactType, physicalmeasure, year, physical_impact, annual_impact, scenario

impactType = are the different categories of impacts (e.g., Ozone, PM2.5, Asthma, etc.) 
physicalmeasure = Premature Mortality and acres burned for wildfire
physical_impact = # of deaths
annual_imapct = billions of 2015$US
