% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_fredi_ghg.R
\name{run_fredi_ghg}
\alias{run_fredi_ghg}
\title{Project annual impacts from GHG changes}
\usage{
run_fredi_ghg(
  inputsList = list(gdp = NULL, pop = NULL, ch4 = NULL, nox = NULL, o3 = NULL),
  aggLevels = c("none"),
  elasticity = 1,
  maxYear = 2100,
  outputList = FALSE,
  allCols = FALSE
)
}
\arguments{
\item{inputsList=list(gdp=NULL, pop=NULL, ch4=NULL, nox=NULL, o3=NULL)}{A list with named elements (\code{gdp}, \code{pop}, \code{ch4}, \code{nox}, and/or \code{o3}), each containing data frames of custom scenarios for gross domestic product (GDP), state-level population, ozone concentration, methane concentration, and NOx emissions, respectively, over a continuous period. Values should start in 2020 or earlier. Values for each scenario type must be within reasonable ranges. For more information, see \code{\link[=import_inputs]{import_inputs()}}.}

\item{aggLevels="none"}{Levels of aggregation at which to summarize data: one or more of \code{c("national","conus", "modelaverage", "impacttype", "all", "none")}. Defaults to no levels (i.e., \code{aggLevels = "none"}).}

\item{elasticity=1}{A numeric value indicating an elasticity to use for adjusting VSL (defaults to \code{elasticity = 1}).}

\item{maxYear=2100}{A numeric value indicating the maximum year for the analysis. The range for \code{maxYear} is \verb{[2011, 2300]}. Defaults to \code{maxYear = 2100}.}

\item{thru2300=FALSE}{A \code{ TRUE/FALSE} shortcut that overrides the \code{maxYear} argument to run the model to 2300. Defaults to \code{thru2300 = FALSE}.}

\item{outputList=FALSE}{A \code{ TRUE/FALSE} value indicating whether to output results as a data frame object (\code{outputList = FALSE}, default) or to return a list of objects (\code{outputList = TRUE}) that includes information about model provenance (including input arguments and input scenarios) along with the data frame of results.}

\item{allCols=FALSE}{A \code{TRUE/FALSE} value indicating whether to include intermediate column values in results (e.g., physical and economic multipliers). Used in testing. Defaults to \code{allCols = FALSE}).}
}
\value{
If \code{outputList=FALSE}, the output of \code{run_fredi_ghg()} is a data frame object (described above) containing annual physical and economic impacts over the analysis period, for each region, state, and model.

If \code{outputList=TRUE}, \code{run_fredi_ghg()} returns a list object containing the following:
\itemize{
\item \strong{\code{statusList}}. A list with values for the arguments passed to \code{run_fredi_ghg()} (including defaults if unspecified).
\item \strong{\code{argsList}}. A list with elements named after \code{run_fredi_ghg()} arguments, containing the values of the arguments passed to \code{run_fredi_ghg()} (or default values if unspecified).
\item \strong{\code{scenarios}}. A list with named elements \code{gdp} and \code{pop} and \code{o3} or \code{ch4} and \code{nox} -- each containing the scenarios for GDP, population, and ozone or methane and NOx as used by the model in calculating impacts.
\item \strong{\code{results}}. Containing a data frame of annual physical and economic impacts (i.e., the same data frame returned if \code{outputList = FALSE}).
}
}
\description{
This function allows users to estimate the economic and physical impacts associated with changes of atmospheric GHG concentrations. As of FrEDI v5.0, this function calculates the projected change in mortality and morbidity associated with exposure to ozone that is produced by atmospheric methane.
}
\details{
This function allows users to estimate impacts from changes in atmospheric concentrations of greenhouse gases (GHG) in the atmosphere. This module (also referred to as the \strong{concentration-driven module} or \strong{FrEDI-GHG}. \strong{FrEDI-GHG} is an optional supplement to the main FrEDI function \code{\link[=run_fredi]{run_fredi()}}, and is driven by changes in GHG concentrations, rather than by changes in temperature or sea-level rise. The outputs of \strong{FrEDI-GHG} complement the damages output from main FrEDI and allow users to explore how these additional GHG-related impacts will be distributed across CONUS regions.

The \strong{FrEDI-GHG} module currently assesses the health impacts associated with changes in exposure to the ozone produced from atmospheric methane. \code{run_fredi_ghg()} calculates these impacts by adapting the reduced form damage function developed by McDuffie et al., 2023. As described in McDuffie et al. 2023, increases in atmospheric methane concentrations lead to higher levels of global background ozone in the troposphere, and result in increased ozone attributable respiratory-related mortality. The efficiency of ozone production from methane (i.e., the ozone response) is sensitive to (or modified by) the presence of other ozone precursors, such as nitrogen oxides (NOx), CO, or volatile organic compounds (VOCs). GCM simulations conducted by the UNEP/CCAC Methane Assessment Report (which formed the basis of the McDuffie at al., 2023 results) previously showed that the ozone response efficiency was more sensitive to change in NOx emissions than to changes in VOCs and derived a NOx-specific modification factor. This relationship shows that as NOx emissions are reduced, ozone production will become more NOx limited (or VOC saturated) and methane will have a smaller impact on ozone production. Users have the option to supply annual NOx concentrations to modify the amount of methane-ozone production in each state by the change in NOx emissions relative to the reference values (the reference scenario assumes constant annual NOx emissions of 10.53Mt/year in the US). If the user does not provide a NOx emissions trajectory with a methane concentration trajectory, we assume NOx levels stay constant at the reference values, and with no adjustment to ozone response. Alternatively, users can supply a custom ozone concentration scenario. Users also have the option to supply a custom state-level population trajectory and/or a national Gross Domestic Product (GDP) scenario.

Users can specify any optional custom scenarios to use with \code{run_fredi_ghg()} via the \code{inputsList} argument (for more information on the format of inputs, refer to the format of outputs described in \code{\link[=import_inputs]{import_inputs()}}). \code{run_fredi_ghg()} looks for a list object passed to the argument \code{inputsList}. Within that list, \code{run_fredi_ghg()} looks for named list elements -- \code{gdp}, \code{pop}, \code{o3}, \code{ch4}, and/or \code{nox} -- with each respectively containing a data frame with a custom scenario for GDP, state-level population, ozone concentration, methane concentration, and/or NOx concentration. If \code{inputsList = NULL} or \code{inputsList = list()} (default), \code{run_fredi_ghg()} uses default trajectories for GDP, population, ozone concentration, methane concentration, and/or NOx concentration. \code{run_fredi_ghg()} will default back to the default scenarios for any list elements that empty or \code{NULL} (in other words, running \code{run_fredi(inputsList = list())} returns the same outputs as running \code{run_fredi_ghg()}). See \link{gdpDefault}, \link{popDefault} for more information about the default GDP and population scenarios. Default scenarios for ozone, methane, and NOx are described in more detail below.
\itemize{
\item \strong{GDP Inputs.} The input scenario for gross domestic product (GDP) requires national GDP values in 2015$. GDP values must be greater than or equal to zero.
\itemize{
\item \code{gdp} requires a data frame object with two columns with names \code{"year"}, and \code{"gdp_usd"} containing the year and the national GDP, respectively. GDP values must be greater than or equal to zero.
\item GDP inputs must have at least one non-missing value in 2020 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}). Note that the minimum year for the GDP scenario is different from that for \code{\link[=run_fredi]{run_fredi()}}, because \code{run_fredi_ghg()} is only available starting in 2020.
\item If the user does not specify an input scenario for GDP (i.e., \code{inputsList = list(gdp = NULL)}, \code{run_fredi_ghg()} uses a default GDP scenario.
}
\item \strong{Population Inputs.} The input population scenario requires state-level population values(national-, CONUS-, or region-level population values can be converted to state-level population by immporting inputs using the \code{\link[=import_inputs]{import_inputs()}} function). Population values must be greater than or equal to zero.
\itemize{
\item \code{pop} requires a data frame object with five columns with names \code{"region"}, \code{"state"}, \code{"postal"}, \code{"year"}, and \code{"pop"} containing the region name (one of \code{"Midwest"}, \code{"Northeast"}, \code{"Northern Plains"}, \code{"Northwest"}, \code{"Southeast"}, \code{"Southern Plains"}, or \code{"Southwest"} for CONUS states, or \code{"Alaska"} and \code{"Hawaii"} for Alaska and Hawaii, respectively), the state name, the two-character postal code abbreviation for the state, the year, and the state population, respectively.
\item Population inputs must have at least one non-missing value in 2020 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}). Note that the minimum year for the GDP scenario is different from that for \code{\link[=run_fredi]{run_fredi()}}, because \code{run_fredi_ghg()} is only available starting in 2020.
\item If the user does not specify an input scenario for population (i.e., \code{inputsList = list(pop = NULL)}, \code{run_fredi_ghg()} uses a default population scenario.
}
\item \strong{Ozone Inputs.} The input ozone scenario requires changes in annual state-level ozone concentrations, by GCM model, in parts per trillion by volume (pptv) relative to a 1986-2005 baseline era. In other words, the input ozone scenario requires ozone concentrations specific to the state, GCM model, and year of the analysis.
\itemize{
\item \code{o3} requires a data frame object with six columns with names \code{"region"}, \code{"state"}, \code{"postal"}, \code{"model"}, \code{"year"}, and \code{"O3_pptv"}  containing the region name (\code{"Midwest"}, \code{"Northeast"}, \code{"Northern Plains"}, \code{"Northwest"}, \code{"Southeast"}, \code{"Southern Plains"}, or \code{"Southwest"} for CONUS states, or \code{"Alaska"} and \code{"Hawaii"} for Alaska and Hawaii, respectively), the state name, the two-character postal code abbreviation for the state, the GCM model name (\code{"CanESM2"}, \code{"GFDL-CM3"}, \code{"GISS-E2-R"}, \code{"HadGEM2-ES"}, and/or \code{"MIROC5"}), the year, and the change in ozone concentration (in pptv) relative to a 1986-2005 baseline era.
\item Ozone inputs must have at least one non-missing value in 2020 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item If inputs are specified for ozone \emph{and} methane or NOx (i.e., \code{!is.null(inputsList$o3) & (!is.null(inputsList$ch4) | !is.null(inputsList$nox))}), \code{run_fredi_ghg()} will use the ozone scenario in preference of the methane and NOx scenario.
}
\item \strong{Methane Inputs.} The input methane scenario requires changes in annual methane concentrations, at the national level, in parts per billion by volume (ppbv) relative to a 1986-2005 baseline era.
\itemize{
\item \code{ch4} requires a data frame object with two columns with names \code{"year"} and \code{"CH4_ppbv"}  containing the year and the change in methane concentration (in ppbv) relative to a 1986-2005 baseline era.
\item Methane inputs must have at least one non-missing value in 2020 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item \code{run_fredi_ghg()} will override a user-supplied methane scenario with a user-supplied ozone scenario; in other words, \code{run_fredi_ghg()} will use the ozone scenario in preference of the methane and NOx scenario.
}
\item \strong{NOx Inputs.} The input NOx scenario requires annual NOx emissions in the US, at the national level, in Megatons (MT) relative to a 1986-2005 baseline.
\itemize{
\item \code{nox} requires a data frame object with two columns with names \code{"year"} and \code{"NOx_Mt"}  containing the year and the change in NOx concentration (in Mt) relative to a 1986-2005 baseline era.
\item NOx inputs must have at least one non-missing value in 2020 or earlier and at least one non-missing value in or after the final analysis year (as specified by \code{maxYear}).
\item \code{run_fredi_ghg()} will override a user-supplied methane scenario with a user-supplied ozone scenario; in other words, \code{run_fredi_ghg()} will use the ozone scenario in preference of the methane and NOx scenario.
}
}

The function \code{\link[=import_inputs]{import_inputs()}} can be used to importing custom scenarios from CSV files. \code{\link[=import_inputs]{import_inputs()}} returns a list with named elements \code{gdp}, \code{pop}, \code{o3}, \code{ch4}, and/or \code{nox}, with each respectively containing a data frame with a custom scenario for GDP, state-level population, change in ozone concentration, change in methane concentration, and NOx emissions. If a user imports scenarios using \code{\link[=import_inputs]{import_inputs()}}, they can pass the outputs of \code{\link[=import_inputs]{import_inputs()}} directly to the \code{run_fredi_ghg()} argument \code{inputsList}. Note that the documentation for \code{\link[=import_inputs]{import_inputs()}} can also provide additional guidance and specification on the formats for each scenario type.

If inputs are specified for ozone \emph{and} methane or NOx (i.e., \code{!is.null(inputsList$o3) & (!is.null(inputsList$ch4) | !is.null(inputsList$nox))}), \code{run_fredi_ghg()} will use the ozone scenario in preference of the methane and NOx scenario. If no ozone, methane, or NOx scenario are provided (i.e., \code{inputsList$o3}, \code{inputsList$ch4}, and \code{inputsList$nox} are all \code{NULL}), \code{run_fredi_ghg()} will use the default ozone scenario to calculate impacts. However, if a user provides an input scenario for methane or NOx (i.e., either \code{inputsList$ch4} or \code{inputsList$nox} are not \code{NULL}) but no ozone scenario is provided (i.e., \code{inputsList$o3} is \code{NULL}), then \code{run_fredi_ghg()} will use the methane and NOx scenarios (if either of those inputs is missing, \code{run_fredi_ghg()} will use the corresponding default scenario).

To calculate the change in ozone concentrations when using methane and NOx scenarios, \code{run_fredi_ghg()} follows the approach described in EPA (Forthcoming):
\enumerate{
\item First, \code{run_fredi_ghg} calculates values for the change in ozone concentration (in pptv) by multiplying values for a given change in methane concentrations (in ppbv) by a state- and model-specific ozone response matrix (with values in units of concentrations of ozone in pptv relative to concentrations of methane in ppbv).
\item Second, \code{run_fredi_ghg} calculates values for NOx factor (\code{NOxFactor}) from the NOx concentrations in Mt (\code{NOX_Mt}), using the equation \verb{NOxFactor = (log(NOX_Mt) \\* k1 + k0) \\* 1e3/556} (where \code{k0} and \code{k1} are coefficients with values of \code{-1.12} and \code{-0.49}, respectively). Note that methane module currently uses the GCM average values for the US, though GCM-specific values are available and could be added in future revisions.
\item Third, \code{run_fredi_ghg} calculates a NOx ratio (\code{NOxRatio = NOxFactor / NOxFactor0}) by dividing the NOx factor values (\code{NOxFactor}) from Step 2 by a reference NOx factor (\code{NOxFactor0=-4.088991}), where the value for \code{NOxFactor0} was calculated for a reference NOx concentration (\code{NOX_Mt0=10.528}) using the equation from Step 2.
\item Fourth, \code{run_fredi_ghg} adjusts the values for change in ozone concentration from Step 1 by the NOx ratio from Step 3.
}

\code{run_fredi_ghg} uses the following default scenarios:
\itemize{
\item \strong{Methane}. The methane default scenario, \code{ch4Default}, uses a constant value of \code{CH4_ppbv=100} for change in methane concentration (in ppbv) for the years 2020 through 2100. See \link{ch4Default} for more information on the default scenario. Note that the temperature scenario used to produce this default methane scenario differs from the default temperature scenario used in main \code{FrEDI} (\code{\link[=run_fredi]{run_fredi()}}) and the \code{FrEDI} SV module (\code{\link[=run_fredi_sv]{run_fredi_sv()}}).
\item \strong{NOx}. The NOx default scenario, \code{noxDefault}, uses a constant value of \code{NOx_Mt=10.528} for change in NOx concentration (in Mt) for the years 2020 through 2100.
\item \strong{Ozone}. The ozone default scenario, \code{o3Default}, uses state- and GCM-specific constant values for change in ozone concentration (\code{O3_pptv} in pptv) for the years 2020 through 2100, as calculated from the default methane and NOx scenarios using the approach described above.
}

\code{run_fredi_ghg()} linearly interpolates missing annual values for all input scenarios using non-missing values (each scenario requires at least two non-missing values as detailed above for each scenario type). After interpolation of the input scenarios, \code{run_fredi_ghg()} subsets the input scenarios to values within the analysis period (years above 2020 and ending in the year specified by \code{maxYear}).

By default, \code{run_fredi_ghg()} calculates impacts starting in the year 2020 and ending in 2100. Specify an alternative end year for the analysis using the \code{maxYear} argument. \code{maxYear} has a default value of \code{2100} and minimum and maximum values of \code{2020} and \code{2300}, respectively. Alternatively, users can set argument \code{thru2300 = TRUE} to override the \code{maxYear} argument and set \code{maxYear = 2300}. Note that the default scenarios included within \link{FrEDI} stop in the year 2100; users must provide custom input scenarios out to the desired end year \strong{and} specify a \code{maxYear >= 2100} (and \code{maxYear <= 2300}) in order to return non-missing values for years after 2100.

\code{run_fredi_ghg()} calculates national population from state population values and then calculates GDP per capita from values for GDP and national population. Values for state population, national population, national GDP (in 2015$), and national per capita GDP (in 2015$/capita) are provided in the results data frame in columns \code{"pop"}, \code{"national_pop"}, \code{"gdp_usd"}, and \code{"gdp_percap"}, respectively. \code{run_fredi_ghg()} converts the physical impacts (excess deaths) to an economic impact using a Value of Statistical Life (VSL) approach. VSL values are adjusted over time by scaling GDP per capita (relative to CONUS population) relative to a reference GDP per capita. For more information, refer to EPA (2021).

The process used by the methane module to calculate physical impacts (excess respiratory deaths) from ozone is as follows:
\enumerate{
\item \code{run_fredi_ghg()} estimates a time-dependent national respiratory mortality rate (in deaths per capita) from national population values relative to a reference population.
\item State-level respiratory mortality (deaths) is then calculated by the national respiratory mortality rate by state population.
\item \code{run_fredi_ghg()} then calculates a state-level respiratory mortality ratio by dividing the state-level respiratory mortality by a reference respiratory mortality.
\item \code{run_fredi_ghg()} also calculates a state- and model-specific ozone ratio by dividing the change in ozone concentration values in pptv by reference values.
\item To calculate the number of excess respiratory mortality due to ozone, \code{run_fredi_ghg()} multiplies the state- and model-specific baseline values for excess respiratory mortality by the state-level respiratory mortality ratio and the state- and model-specific ozone ratio. These
}

To calculate the economic impacts of excess respiratory deaths from ozone, \code{run_fredi_ghg()} multiplies the physical impacts by VSL adjusted for GDP and population, as described above.

If \code{outputList = FALSE} (default), \code{run_fredi_ghg()} returns a data frame of annual physical and economic impacts over the analysis period, for each region, state, and model. If \code{outputList = TRUE}, in addition to the data frame of impacts, \code{run_fredi_ghg()} returns a list object containing information about values for function arguments and scenarios for GDP, population, and ozone or methane and NOx.
}
\examples{
### Load FrEDI
require(FrEDI)

### Load population and GDP scenarios and glimpse data
data("popDefault"); popDefault |> glimpse()
data("gdpDefault"); gdpDefault |> glimpse()


### Run FrEDI methane with O3 inputs
example1 <- run_fredi_ghg(inputsList=list(gdp=gdpDefault, pop=popDefault, o3=o3Default))

### Run FrEDI methane with methane inputs
example1 <- run_fredi_ghg(inputsList=list(gdp=gdpDefault, pop=popDefault, ch4=ch4Default))

### Run FrEDI methane with methane and NOx inputs
example1 <- run_fredi_ghg(inputsList=list(gdp=gdpDefault, pop=popDefault, ch4=ch4Default, nox=noxDefault))


}
\references{
Environmental Protection Agency (EPA). 2025. Technical Documentation on The Framework for Evaluating Damages and Impacts (FrEDI). Technical Report EPA 430-R-24-001, EPA, Washington, DC. Available at https://epa.gov/cira/FrEDI/.

McDuffie, E. E., Sarofim, M. C., Raich, W., Jackson, M., Roman, H., Seltzer, K., Henderson, B. H., Shindell, D. T., Collins, M., Anderton, J., Barr, S., & Fann, N. (2023). The Social Cost of Ozone-Related Mortality Impacts From Methane Emissions. Earth’s Future, 11(9), e2023EF003853.
}
