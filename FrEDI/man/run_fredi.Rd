% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_fredi.R
\name{run_fredi}
\alias{run_fredi}
\title{Project annual average climate change impacts throughout the 21st century for available sectors}
\usage{
run_fredi(
  inputsList = list(tempInput = NULL, slrInput = NULL, gdpInput = NULL, popInput = NULL),
  sectorList = NULL,
  aggLevels = c("national", "modelaverage", "impactyear", "impacttype"),
  elasticity = 1,
  maxYear = 2090,
  thru2300 = FALSE,
  outputList = FALSE,
  allCols = FALSE,
  silent = TRUE
)
}
\arguments{
\item{inputsList=NULL}{A list of named elements named elements (\code{names(inputsList) = c( "tempInput", "slrInput", "gdpInput", "popInput" )}), each containing data frames of custom temperature, global mean sea level rise (GMSL), gross domestic product (GDP), and/or population scenarios, respectively, over a continuous period in the range 2010 to 2300. Temperature and sea level rise inputs should start in 2000 or earlier. Values for population and GDP scenarios can start in 2010 or earlier. Values for each scenario type must be within reasonable ranges. For more information, see \code{\link[=import_inputs]{import_inputs()}}.}

\item{sectorList=NULL}{A character vector indicating a selection of sectors for which to calculate results (see \code{\link[=get_sectorInfo]{get_sectorInfo()}}). If \code{NULL}, all sectors are included (i.e., \code{sectorList=get_sectorInfo()}).}

\item{aggLevels="all"}{Levels of aggregation at which to summarize data: one or more of \verb{c("national"}, \code{"modelaverage"}, \code{"impactyear"}, \code{"impacttype"}, \code{"all"}, \verb{"none")}. Defaults to all levels (i.e., \code{aggLevels= "all"}). Uses the same aggregation levels as \code{\link[=aggregate_impacts]{aggregate_impacts()}}. Note that, if \code{"impacttype"} is in \code{aggLevels} (e.g., \code{aggLevels= "all"}), columns \code{"physical_measure"} and \code{"physical_impacts"} will be dropped from the results data frame. This is because aggregating over impact types for some sectors requires summing costs over different types of physical impacts, so reporting the physical impacts would be nonsensical.}

\item{elasticity=1}{A numeric value indicating an elasticity to use for adjusting VSL for applicable sectors and impacts (defaults to \code{elasticity=1}). Applicable sectors and impacts are: \strong{Climate-Driven Changes in Air Quality} (all impact types), \strong{ATS Temperature-Related Mortality}  (\code{impactType="N/A"}; i.e., all impact types), \strong{CIL Temperature-Related Mortality}, \strong{Extreme Temperature} (all impact types), \strong{Suicide} (\code{impactType = "N/A"}; i.e., all impact types), \strong{Southwest Dust} (\code{impactType= "All Mortality"}), \strong{Valley Fever} (\code{impactType= "Mortality"}), \strong{Vibriosis} (\code{impactType="N/A"}; i.e., all impact types), and \strong{Wildfire} (\code{impactType = "Mortality"}).}

\item{maxYear=2090}{A numeric value indicating the maximum year for the analysis. The range for \code{maxYear} is \verb{[2011, 2300]. }Defaults to \code{maxYear=2090}.}

\item{thru2300=FALSE}{A \code{ TRUE/FALSE} shortcut that overrides the maxYear argument to run the model to 2300. Defaults to \code{thru2300=FALSE}.}

\item{outputList=FALSE}{A \code{ TRUE/FALSE} value indicating whether to output results as a data frame object (\code{outputList = FALSE}, default) or to return a list of objects (\code{outputList = TRUE}) that includes information about model provenance (including input arguments and input scenarios) along with the data frame of results.}

\item{allCols=FALSE}{A \code{TRUE/FALSE} value indicating whether to include intermediate column values in results (e.g., physical and economic multipliers). Used in testing. Note that aggregation levels must be set to \code{aggLevels="none"} to properly return the intermediate columns. Defaults to \code{allCols=FALSE}).}

\item{silent=TRUE}{A \code{TRUE/FALSE} value indicating the level of messaging desired by the user (default=\code{TRUE}).}
}
\value{
If \code{outputList=FALSE}, the output of \code{\link[=run_fredi]{run_fredi()}} is a dataframe object (described above) containing annual average impacts over the analysis period, for each sector, variant, impact type, impact year, region, state, and model (GCM name for temperature-driven sectors and "Interpolation" for SLR-driven sectors).

If \code{outputList=TRUE}, \code{\link[=run_fredi]{run_fredi()}} returns a list object containing the following:
\itemize{
\item \strong{\code{statusList}}. A list with values for the arguments passed to \code{\link[=run_fredi]{run_fredi()}} (including defaults if unspecified).
\item \strong{\code{argsList}}. A list with elements named after \code{\link[=run_fredi]{run_fredi()}} arguments, containing the values of the arguments passed to \code{\link[=run_fredi]{run_fredi()}} (or default values if unspecified).
\item \strong{\code{scenarios}}. A list with named elements \code{"temp"}, \code{"slr"}, \code{"gdp"}, and \code{"pop"} -- each containing the scenarios for temperature, SLR, GDP, and population as used by the model in calculating impacts.
\item \strong{\code{results}}. Containing a data frame of annual impacts (i.e., the same data frame returned if \code{outputList=FALSE}).
}
}
\description{
This function allows users to project annual average climate change impacts through 2090 (2010-2090) for available sectors (see \code{\link[=get_sectorInfo]{get_sectorInfo()}}), with the option to extend results to 2300 (2010-2300). Users may specify custom temperature, U.S. population, and GDP scenarios. The output is an R data frame object containing annual average impacts, by year, for each sector, variant, impact type, region, state, and model.

As of FrEDI Version 4.0.1, \code{\link[=run_fredi]{run_fredi()}} calculates impacts at the state-level for the following sectors: \strong{ATS Temperature-Related Mortality}, \strong{Asphalt Roads}, \strong{Climate-Driven Changes in Air Quality}, \strong{Electricity Transmission and Distribution}, \strong{Labor}, \strong{Suicide}, \strong{Transportation Impacts from High Tide Flooding}, \strong{Urban Drainage}, \strong{Wildfire}, \strong{Wind Damage}. Eventually, all sectors will be converted to state-level. Sectors that have only region-level impacts will have values in the \code{"state"} and \code{"postal"} columns of the outputs data frame set to \code{"N/A"}.
}
\details{
This function allows users to project annual average climate change impacts through 2300 (2010-2300) for available sectors. \code{\link[=run_fredi]{run_fredi()}} is the main function in the \link{FrEDI} R package, described elsewhere (See \url{https://epa.gov/cira/FrEDI} for more information).

Users can specify an optional list of custom scenarios with \code{inputsList} (for more information on the format of inputs, see \code{\link[=import_inputs]{import_inputs()}}). The function \code{\link[=import_inputs]{import_inputs()}} can be used to importing custom scenarios from CSV files. \code{\link[=import_inputs]{import_inputs()}} returns a list with elements \code{tempInput}, \code{slrInput}, \code{gdpInput}, and \code{popInput}, with each containing a data frame with a custom scenario for temperature, GMSL, GDP, and state-level population, respectively. If a user imports scenarios using \code{\link[=import_inputs]{import_inputs()}}, they can pass the outputs of \code{\link[=import_inputs]{import_inputs()}} directly to the \code{\link[=run_fredi]{run_fredi()}} argument \code{inputsList}. Note that the documentation for \code{\link[=import_inputs]{import_inputs()}} can also provide additional guidance and specification on the formats for each scenario type.

If \code{inputsList=NULL}, \code{\link[=run_fredi]{run_fredi()}} uses defaults for temperature, SLR, GDP, and population. Otherwise, \code{\link[=run_fredi]{run_fredi()}} looks for a list object passed to the argument \code{inputsList}. Within that list, \code{\link[=run_fredi]{run_fredi()}} looks for list elements \code{tempInput}, \code{slrInput}, \code{gdpInput}, and \code{popInput} containing data frames with custom scenarios for temperature, GMSL, GDP, and regional population, respectively. \code{\link[=run_fredi]{run_fredi()}} will default back to the default scenarios for any list elements that empty or \code{NULL} (in other words, running \code{run_fredi( inputsList = list() )} returns the same outputs as running \code{\link[=run_fredi]{run_fredi()}}).
\itemize{
\item \strong{Temperature Inputs.} The input temperature scenario requires CONUS temperatures in degrees Celsius relative to 1995 (degrees of warming relative to the baseline year--i.e., the central year of the 1986-2005 baseline). CONUS temperature values must be greater than or equal to zero degrees Celsius.
\itemize{
\item Users can convert global temperatures to CONUS temperatures using \link{convertTemps}\code{(from="global")} (or by specifying \link{import_inputs}\code{( temptype = "global" )} when using \code{\link[=import_inputs]{import_inputs()}} to import a temperature scenario from a CSV file).
\item \code{tempInput} requires a data frame object with two columns with names \code{"year"}, and \code{"temp_C"} containing the year and CONUS temperatures in degrees Celsius, respectively.
\item Temperature inputs must have at least one non-missing value in 2000 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item If the user does not specify an input scenario for temperature (i.e., \code{inputsList=list(tempInput=NULL)}, \code{\link[=run_fredi]{run_fredi()}} uses a default temperature scenario.
}
\item \strong{SLR Inputs.} The input SLR scenario requires values for changes in global mean sea level rise (GMSL) heights in centimeters (cm). GMSL heights must be greater than or equal to zero.
\itemize{
\item \code{slrInput} requires a data frame object with two columns with names \code{"year"}, \code{"slr_cm"} containing the year and global mean sea level rise (GMSL) in centimeters, respectively.
\item SLR inputs must have at least one non-missing value in 2000 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item If the user does not specify an input scenario for SLR (i.e., \code{inputsList=list(slrInput=NULL)}, \code{\link[=run_fredi]{run_fredi()}} first converts the input or default CONUS temperature scenario to global temperatures (using \code{\link[=convertTemps]{convertTemps()}}) and then converts the global temperatures to a global mean sea level rise (GMSL) height in centimeters (using \code{\link[=temps2slr]{temps2slr()}}).
}
\item \strong{GDP Inputs.} The input scenario for gross domestic product (GDP) requires national GDP values in 2015$. GDP values must be greater than or equal to zero.
\itemize{
\item \code{gdpInput} requires a data frame object with five columns with names \code{"year"}, and \code{"gdp_usd"} containing the year and the national GDP, respectively. GDP values must be greater than or equal to zero.
\item GDP inputs must have at least one non-missing value in 2010 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item If the user does not specify an input scenario for GDP (i.e., \code{inputsList=list(gdpInput=NULL)}, \code{\link[=run_fredi]{run_fredi()}} uses a default GDP scenario.
}
\item \strong{Population Inputs.} The input population scenario requires state-level population values. Population values must be greater than or equal to zero.
\itemize{
\item \code{popInput} requires a data frame object with five columns with names \code{"year"}, \code{"region"}, \code{"state"}, \code{"postal"}, and \code{"state_pop"} containing the year, the NCA region name, and the state, the postal code abbreviation, and the state population, respectively.
\item Population inputs must have at least one non-missing value in 2010 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item If the user does not specify an input scenario for population (i.e., \code{inputsList=list(popInput=NULL)}, \code{\link[=run_fredi]{run_fredi()}} uses a default population scenario.
}
}

\code{\link[=run_fredi]{run_fredi()}} linearly interpolates missing annual values for all input scenarios using non-missing values (each scenario requires at least two non-missing values as detailed above for each scenario type). After interpolation of the input scenarios, \code{\link[=run_fredi]{run_fredi()}} subsets the input scenarios to values within the analysis period.
\itemize{
\item Temperatures are interpolated using 1995 as the baseline year (i.e., the central year of the 1986-2005 baseline) and GMSL is interpolated using 2000 as the baseline year. In other words, temperature (in degrees Celsius) is set to zero for the year 1995, whereas GMSL is set to zero for the year 2000. The interpolated temperature and GMSL scenarios are combined into a column called \code{driverValue}, along with additional columns for year, the driver unit (column \code{"driverUnit"}, with \code{driverUnit= "degrees Celsius"} and \code{driverUnit= "cm"} for temperature- and SLR-driven sectors, respectively), and the associated model type (column \code{"model_type"}, with \code{model_type="GCM"} and \code{model_type="SLR"} for temperature- and SLR-driven sectors, respectively
\item \code{\link[=run_fredi]{run_fredi()}} calculations national population from state-level values and then calculates GDP per capita from values for GDP and national population. Values for state population, national population, national GDP (in 2015$), and national per capita GDP (in 2015$/capita) are provided in the results data frame in columns \code{"state_pop"}, \code{"national_pop"}, \code{"gdp_usd"}, and \code{"gdp_percap"}, respectively.
}

By default, \code{\link[=run_fredi]{run_fredi()}} will calculate impacts for all sectors included in the tool. Alternatively, users can pass a character vector specifying a single sector or a subset of sectors using the \code{sectorList} argument. To see a list of sectors included within \link{FrEDI}, run \code{\link[=get_sectorInfo]{get_sectorInfo()}}. If \code{sectorList= NULL} (default), all sectors are included.

By default, \code{\link[=run_fredi]{run_fredi()}} calculates impacts starting in the year 2010 and ending in 2090. Specify an alternative end year for the analysis using the \code{maxYear} argument. \code{maxYear} has a default value of \code{2090} and minimum and maximum values of \code{2011} and \code{2300}, respectively. Alternatively, users can set argument \code{thru2300=TRUE} to override the \code{maxYear} argument and set \code{maxYear=2300}. Note that the default scenarios included within \link{FrEDI} stop in the year 2090; users must provide custom input scenarios out to the desired end year \strong{and} specify a \code{maxYear>=2090} (and \code{maxYear<=2300}) in order to return non-missing values for years after 2090.

Annual impacts for each sector, variant, impact type, and impact year combination included in the model are calculated by multiplying scaled climate impacts by a physical scalar and economic scalars and multipliers. Some sectors use Value of a Statistical Life (VSL) to adjust the value non-linearly over time. \code{\link[=run_fredi]{run_fredi()}} uses a default value of \code{elasticity=1}to adjust VSL for applicable sectors and impacts (the default value of \code{elasticity=1} keeps VSL constant over time). A custom elasticity can be passed to the \code{elasticity} argument.Applicable sectors and impacts are *\strong{Climate-Driven Changes in Air Quality} (all impact types), \strong{ATS Temperature-Related Mortality}  (\code{impactType="N/A"}; i.e., all impact types), \strong{CIL Temperature-Related Mortality}, \strong{Extreme Temperature} (all impact types), \strong{Suicide} (\code{impactType = "N/A"}; i.e., all impact types), \strong{Southwest Dust} (\code{impactType= "All Mortality"}), \strong{Valley Fever} (\code{impactType= "Mortality"}), \strong{Vibriosis} (\code{impactType="N/A"}; i.e., all impact types), and \strong{Wildfire} (\code{impactType = "Mortality"}).

\code{\link[=run_fredi]{run_fredi()}} aggregates or summarizes results to level(s) of aggregation specified by the user (passed to \code{aggLevels}) using the post-processing helper function \code{\link[=aggregate_impacts]{aggregate_impacts()}}. Users can specify all aggregation levels at once by specifying \code{aggLevels= "all"} (default) or no aggregation levels (\code{aggLevels= "none"}). Users can specify a single aggregation level or multiple aggregation levels by passing a single character string or character vector to \code{aggLevels}. Options for aggregation include calculating national totals (\code{aggLevels= "national"}), averaging across model types and models (\code{aggLevels= "modelaverage"}), summing over all impact types (\code{aggLevels= "impacttype"}), and interpolating between impact year estimates (\code{aggLevels= "impactYear"}).

If the user specifies \code{aggLevels= "none"}, \code{\link[=run_fredi]{run_fredi()}} returns a data frame with columns: \code{"sector"}, \code{"variant"}, \code{"impactType"}, \code{"impactYear"}, \code{"region"}, \code{"state"}, \code{"postal"}, \code{"model_type"}, \code{"model"}, \code{"sectorprimary"}, \code{"includeaggregate"}, \code{"physicalmeasure"}, \code{"driverType"}, \code{"driverUnit"}, \code{"driverValue"}, \code{"gdp_usd"}, \code{"national_pop"}, \code{"gdp_percap"}, \code{"state_pop"}, \code{"year"}, \code{"physical_impacts"}, and \code{"annual_impacts"}.
\itemize{
\item Columns \code{"sector"}, \code{"variant"}, \code{"impactType"}, \code{"impactYear"}, \code{"region"}, \code{"state"}, \code{"postal"}, \code{"model_type"}, and \code{"model"} all contain observation identifiers (sector name, variant (i.e., sector variant or adaptation name), impact type, impact year, region, state, state postal code, model type, and model, respectively).
\item Column \code{"sectorprimary"} contains values indicating which variant (i.e., sector variant or adaptation name) is the primary one for the sector (\code{sectorprimary=1}for primary variants and \code{sectorprimary=0} for non-primary variants). This column can be used to filter the outputs of \code{\link[=run_fredi]{run_fredi()}} (e.g., as might be done before aggregating impacts over sectors).
\item Column \code{"includeaggregate"} contains values indicating which sectors should be included when aggregating over sectors (\code{includeaggregate=1}for primary sectors and \code{includeaggregate=0} for non-primary sectors). For instance, sectors \strong{ATS Temperature-Related Mortality}, \strong{CIL Temperature-Related Mortality}, and \strong{Extreme Temperature} have values for temperature-related mortality. To avoid double counting, outputs of \code{\link[=run_fredi]{run_fredi()}} should be filtered to values for which \code{sectorprimary==1} and \code{includeaggregate=1}.
\item Columns \code{"driverType"}, \code{"driverUnit"}, and \code{"driverValue"} contain information about the temperature and SLR scenarios.
\item Columns \code{"gdp_usd"}, \code{"national_pop"}, \code{"gdp_percap"}, and \code{"state_pop"} contain information about the GDP and population scenarios.
\item Columns \code{"physicalmeasure"} and \code{"physical_impacts"} contain information about physical impacts.
\item Column \code{"annual_impacts"} contains information on the economic value associated with annual impacts.
}

If the user specifies \code{aggLevels= "all"} or other combinations of aggregation levels, \code{\link[=run_fredi]{run_fredi()}} passes the results data frame and the \code{aggLevels} argument to the \code{\link[=aggregate_impacts]{aggregate_impacts()}} function. \code{\link[=aggregate_impacts]{aggregate_impacts()}} then performs the following calculations, using the default grouping columns for the \code{\link[=aggregate_impacts]{aggregate_impacts()}}: \code{"sector"}, \code{"variant"}, \code{"impactType"}, \code{"impactYear"}, \code{"region"}, \code{"state"}, \code{"postal"}, \code{"model_type"}, \code{"model"}, \code{"sectorprimary"}, \code{"includeaggregate"}, \code{"physicalmeasure"}, and \code{"year"} (note that the \code{"variant"} column referred to below contains information about the variant name (or \verb{“N/A”}), as applicable).

\tabular{ll}{
\strong{Aggregation Level} \tab \strong{Description} \cr
\emph{\code{impactyear}} \tab To aggregate over impact years, \code{\link[=aggregate_impacts]{aggregate_impacts()}} first separates results for sectors with only one impact year estimate (i.e., \code{impactYear= "N/A"}) from from observations with multiple impact year estimates (i.e., sectors with results for both \code{impactYear= "2010"} and \code{impactYear= "2090"}). For these sectors with multiple impact years, physical impacts and annual costs (columns \code{"physical_impacts"} and \code{"annual_impacts"}) are linearly interpolated between impact year estimates. For any model run years above 2090, annual results for sectors with multiple impact years return the 2090 estimate. The interpolated values are then row-bound to the results for sectors with a single impact year estimate, and column \code{impactYear} set to \code{impactYear= "Interpolation"} for all values. If \code{"impactyear"} is included in \code{aggLevels} (e.g., \code{aggLevels= "all"}), \code{\link[=aggregate_impacts]{aggregate_impacts()}} aggregates over impact years before performing other types of aggregation. \cr

\emph{\code{modelaverage}} \tab To aggregate over models for temperature-driven sectors, \code{\link[=aggregate_impacts]{aggregate_impacts()}} averages physical impacts and annual costs (columns \code{"physical_impacts"} and \code{"annual_impacts"}, respectively) across all GCM models present in the data. \code{\link[=aggregate_impacts]{aggregate_impacts()}} drops the column \code{"model"} from the grouping columns when averaging over models. Averages exclude observations with missing values. However, If all values within a grouping are missing, the model average is set to \code{NA}. The values in column \code{"model"} are set to \code{"Average"} for model averages and the model averages data frame is then row-bound to the main results data frame. For SLR-driven sectors, there is no need for additional model aggregation; these values already have \code{model="Interpolation"}. If \code{"modelaverage"} is included in \code{aggLevels} (e.g., \code{aggLevels= "all"}), \code{\link[=aggregate_impacts]{aggregate_impacts()}} first aggregates over impact years  (if \code{"impactyear"} present in \code{aggLevels} or if \code{aggLevels="all"}) before aggregating over models.\cr

\emph{\code{national}} \tab To aggregate values to the national level, \code{\link[=aggregate_impacts]{aggregate_impacts()}} sums physical impacts and annual costs (columns \code{"physical_impacts"} and \code{"annual_impacts"}, respectively) across all regions present in the data. \code{\link[=aggregate_impacts]{aggregate_impacts()}} drops the columns \code{"region"}, \code{"state"}, and \code{"postal"} when summing over states and regions. Years which have missing column data for all regions return as \code{NA}. Values for column \code{"region"} are set to \code{"National Total"}; values for column \code{"state"} are set to \code{All}, and values for column \code{"postal"} are set to \code{US}. The data frame with national totals is then row-bound to the main results data frame. If \code{"national"} is included in \code{aggLevels} (e.g., \code{aggLevels= "all"}), \code{\link[=aggregate_impacts]{aggregate_impacts()}} first aggregates over impact years and/or models (if \code{"impactyear"} and/or \code{"modelaverage"} are present in \code{aggLevels} or if \code{aggLevels= "all"}) before aggregating over models.\cr

\emph{\code{impacttype}} \tab To aggregate values over impact types, \code{\link[=aggregate_impacts]{aggregate_impacts()}} sums annual impacts (column \code{"annual_impacts"}) across all impact types for each sector. \code{\link[=aggregate_impacts]{aggregate_impacts()}} drops the column \code{"impactType"} and \code{"physicalmeasure"} from the grouping columns when summing over impact types. Years which have missing column data for all impact types return as \code{NA}. All values in column \code{"impactType"} are set to \code{"all"}. Aggregating over impact types, drops columns related to physical impacts (i.e., columns \code{"physicalmeasure"} and \code{"physical_impacts"}). These columns are dropped since aggregating over impact types for some sectors requires summing costs over different types of physical impacts, so reporting the physical impacts would be nonsensical.\cr
}

After aggregating values, \code{\link[=aggregate_impacts]{aggregate_impacts()}} joins the data frame of impacts with information about \code{"driverType"}, \code{"driverUnit"}, \code{"driverValue"}, \code{"gdp_usd"}, \code{"national_pop"}, \code{"gdp_percap"}, and \code{"state_pop"}.

If \code{outputList=FALSE} (default), \code{\link[=run_fredi]{run_fredi()}} returns a data frame of annual average impacts over the analysis period, for each sector, variant, impact type, impact year, region, state, model type (\code{"GCM"} or \code{"SLR"}), and model. If \code{outputList=TRUE}, in addition to the data frame of impacts, \code{\link[=run_fredi]{run_fredi()}} returns a list object containing information about values for function arguments, driver scenarios, and population and GDP scenarios.
}
\examples{
### Load FrEDI
require(FrEDI)

### Run function with defaults (same as `defaultResults` dataset)
run1 <- run_fredi()

### Load climate scenarios and glimpse data
data("gcamScenarios")
gcamScenarios |> glimpse()

### Load population scenario and glimpse data
data(popScenario)
popScenario |> glimpse()

### Subset climate scenario
temps1 <- gcamScenarios |> filter(scenario=="ECS_3.0_ref_0") |> select(year, temp_C)

### Run custom scenario
run2 <- run_fredi(inputsList=list(tempInput=temps1, popInput=popScenario))

### Load scenarios from file:
scenariosPath <- system.file(package="FrEDI") |> file.path("extdata","scenarios")
scenariosPath |> list.files()


### SLR Scenario File Name
slrInputFile  <- scenariosPath |> file.path("slr_from_GCAM.csv")

### Population Scenario File Name
popInputFile  <- scenariosPath |> file.path("State ICLUS Population.csv")

### Import inputs
x_inputs <- import_inputs(
  slrfile  = slrInputFile,
  popfile  = popInputFile
)

### Run custom scenarios
run3 <- run_fredi(inputsList=x_inputs)

### Get information on sectors:
get_sectorInfo()

### Run for a single sector, with default inputs, no aggregation, and elasticity=1:
run4 <- run_fredi(sectorList="ATS Temperature-Related Mortality", aggLevels="none", elasticity=1)

### Set end year for analysis to 2100 using default scenarios (values after 2090 will all be missing, since default scenarios only have values out to 2090)
run5 <- run_fredi(maxYear=2100)

### Set end year for analysis to 2300 using default scenarios (values after 2090 will all be missing, since default scenarios only have values out to 2090)
run6 <- run_fredi(thru2300=TRUE)




}
\references{
Environmental Protection Agency (EPA). 2021. Technical Documentation on The Framework for Evaluating Damages and Impacts (FrEDI). Technical Report EPA 430-R-21-004, EPA, Washington, DC. Available at \url{https://epa.gov/cira/FrEDI/}.
}
