###### temps2slr ######
### Created 2021.02.11. Updated with new GMSL calculation method 2021.06.02. Updated parameters in August 2021.
#' Convert global temperature change in degrees Celsius to global mean sea level rise (GMSL) in centimeters
#'
#' @description
#' This pre-processing helper function converts a vector of global temperatures to global mean sea level rise (GMSL). This function adapts the method described by Kopp et al. (2016) (see references, below).
#'
#' @param temps A numeric vector of global temperatures in degrees Celsius. The temperature series and corresponding years must begin in 2000 or earlier.
#' @param years A numeric vector of years (common era) corresponding to the temperatures provided to `temps`. The temperature series and corresponding years must begin in 2000 or earlier.
#'
#' @details
#' This function converts a temperature scenario (global temperatures in degrees Celsius) into an SLR scenario to use for estimate impacts of global mean sea level rise (GMSL) on affected sectors. [FrEDI::temps2slr()] implements the method described by Kopp et al., 2016, "Temperature-driven global sea-level variability in the Common Era" (see references, below).
#'
#' Kopp et al.'s "semiempirical" sea-level model relates the rate of global sea level (GSL) rise \eqn{\frac{dh}{dt}}{dh/dt} to global mean temperature \eqn{T(t)}, an equilibrium temperature \eqn{T_0(t)}{Te(t)}, and a small residual trend arising from the long-term response to earlier changes \eqn{\phi(t)}{\phi(t)}:
#'
#' \deqn{dh/dt = \alpha \cdot (T(t) - T_0(t)) + \phi(t)}{dh/dt = \alpha \cdot (T(t) - Te(t)) + \phi(t)}
#'
#' As explained by Kopp et al. (2016): "The first term describes the GSL response to earlier changes during the study period. The second term covers a small residual trend arising from the long-term response to earlier changes (i.e., deglaciation), which is very slowly decaying over millennia and of the order 0.1 mm/year in 2000 CE. It thus has a negligible effect on the modeled GSL rise during the 20th and 21st centuries" (Kopp et al., 2016, p. E1439).
#'
#' In the equation above, \eqn{T_0(t)}{Te(t)} and \eqn{\phi(t)} are functions of time, where:
#'
#' \deqn{\frac{dT_0(t)}{dt} = \frac{T(t) - Te(t)}{\tau_1}}{dTe(t)/dt = (T(t) - Te(t))/k1}
#'
#' And:
#'
#' \deqn{\frac{d\phi(t)}{dt} = \frac{\phi}{\tau_2}}{d\phi(t)/dt = p(t)/k2}
#'
#' And \eqn{\tau_1}{k1} and \eqn{\tau_2}{k2} are both constants.
#'
#' @return
#' Outputs a data frame with two columns: `year`, which has the years from the `years` input that fall within the range from 2000 through 2090 and `slr_cm` which has the GMSL in centimeters.
#'
#' @examples
#temps2slr(years = seq(2020, 2080, 10), temps =1:7)
#'
#' ### Path to example scenarios
#' scenariosPath <- system.file(package="FrEDI") |> file.path("extdata","scenarios")
#' ### View example scenario names
#'
#' scenariosPath |> list.files()
#'
#' ### Temperature Scenario File Name
#' tempInputFile <- scenariosPath |> file.path("GCAM_scenario.csv")
#'
#' ### Import example temperature scenario
#' example_inputsList <- import_inputs(tempfile = tempInputFile)
#'
#' ### Extract the example temperature scenario data frame from the list
#' ### Example has global temperatures in degrees Celsius
#' x_tempInput <- example_inputsList$tempInput
#'
#' ### Calculate global mean sea level rise in cm from global temperatures
#' x_slr <- temps2slr(temps=x_tempInput$temp_C, years=x_tempInput$year)
#'
#'
#' @references Environmental Protection Agency (EPA). 2021. Technical Documentation on The Framework for Evaluating Damages and Impacts (FrEDI). Technical Report EPA 430-R-21-004, EPA, Washington, DC. Available at <https://epa.gov/cira/FrEDI/>.
#'
#' Kopp, Robert E., et al. (2016). Temperature-driven global sea-level variability in the Common Era. PNAS: E1434-E1441. Available at https://www.pnas.org/content/113/11/E1434
#'
#'
#' @export
#' @md
#'
###
###

temps2slr <- function(
    temps, years, conn
){
  ###### Messages ######
  msg1    <- "\t"
  ###### Kopp Equations ######
  ### dh/dt = a*(T(t) - Te(t)) + c(t)
  ### dTe(t)/dt = (T(t) - Te(t))/tau1
  ### dc(t)/dt = c/tau2

  ###### Kopp Constants ######
  ### Phi: (i.e., "c", above) is a temperature-independent rate term with e-folding time tau2. I.e., phi is the multi-millennial contribution to GMSL in mm/year.
  ### Scalar: Sensitivity of the GSL rate to a deviation of T(t) from an equilibrium temperature of Te(t).
  ### Alpha: The value obtained in Mann et al. posterior distribution (Kopp et al., 2016 Figure S5a for "a").
  ### Tau1: the timescale on which the actual temperature relaxes toward the equilibrium temperature. Value obtained  in Mann et al. posterior distribution (Kopp et al., 2016 Figure S5a for "tau").
  ### Tau2: e-folding time(scale) for phi. Value obtained  in Mann et al. posterior distribution (Kopp et al., 2016 Figure S5a for "tau_C").
  phi0       <- 0.14
  alpha      <- 4.0
  tau1       <- 174
  tau2       <- 4175

  ###### Initial Values ######
  ### Reference year 2000 and equilibrium temperature offset for 2000
  ### Assign reference year from config file (max_year)
  # fredi_config        <- "fredi_config" |> get_frediDataObj("frediData")
  fredi_config    <- DBI::dbReadTable(conn,"fredi_config")
  fredi_config    <- unserialize(fredi_config$value |> unlist())
  temps2slr_constants <- fredi_config[["temps2slr"]]

  # temps2slr_constants |> list2env(envir = environment())
  for(name_i in fredi_config |> names()) {name_i |> assign(fredi_config[[name_i]]); rm(name_i)}

  #### Reference year is 2000
  co_modelTypes <- DBI::dbReadTable(conn,"co_modelTypes") |> filter(modelType_id == "slr")
  ref_year0     <- co_modelTypes |> pull(modelRefYear)

  ###### Other constants ######
  eqtemp_offset <- 0.62
  mm2cm         <- 0.1 ### Number of centimeters per millimeter

  ### We used HadCrUT4 to determine the appropriate temperature offset between the actual temperature and the equilibrium temperature in 2000.
  ### Met Office Hadley Centre observations datasets. https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/download.html.
  ###### Initialize Data ######
  ### Filter NA values and make sure values are numeric
  mutate0 <- c("year", "temp_C")
  df_x0   <- tibble(year = years, temp_C = temps)
  df_x0   <- df_x0 |> mutate_at(c(mutate0), as.character)
  df_x0   <- df_x0 |> mutate_at(c(mutate0), as.numeric)
  df_x0   <- df_x0 |> filter_all(all_vars(!(. |> is.na())))
  df_x0   <- df_x0 |> arrange_at(c("year"))
  rm(mutate0)

  ### Filter missing values, then get unique years
  df_x0   <- df_x0 |> filter_all(all_vars(!(. |> is.na())))
  years0  <- df_x0 |> pull(year) |> unique()
  range0  <- years0 |> range()
  min0    <- range0[1]
  max0    <- range0[2]

  ### Check that there are no duplicate rows
  hasDuplicates <- (df_x0 |> nrow()) > (years0 |> length())
  if(hasDuplicates){
    paste0(msg1, "Warning: There are duplicate years in the inputs!") |> message()
    paste0(msg1, "Exiting...") |> message()
    return()
    # message("\t\t\t", "Averaging values for duplicate years...")
    # df_x0 <- df_x0 |> group_by_at(.vars = c("year")) |> summarize_at(c("temp_C"), mean, na.rm=T)
  } ### End if(hasDuplicates)

  ### Check for 2020 (year0)
  ### If 2020 not found, check for values above and below 2000
  checkRefYear <- (ref_year0 %in% years0)
  checkRefYear <- (any(!checkRefYear)) |> ifelse(min0 < ref_year0 & max0 > ref_year0, checkRefYear)

  ### If 2020 is still not found, message the user and exit
  ###To-do exit gracefully within tempbin()
  ### Else, if there is a valid temperature series: Calculate temperatures
  if(any(!checkRefYear)) {
    message("\t", "Warning:")
    message("\t\t", "In 'temps2slr()': Missing values for the reference year ", ref_year0 , ".")
    message("\t\t\t", "The reference year ", ref_year0 , " must be present in the input (or the input must have values above and below the reference year).")
    message("\n", "\t", "Enter a valid temperature series.")
    message("\n", "Exiting...")
    return()
  }

  ###### Standardize data #####
  ### Filter to years of interest 2000-2100
  # max_year     <- 2100
  # new_years    <- seq(ref_year0, max_year)
  new_years <- ref_year0:max0
  num_x     <- new_years |> length()
  ind_x     <- 1:num_x

  ###### Interpolate the data #####
  ### Interpolated Data
  # function require annual data
  df_x1 <- tibble(year = new_years) |> mutate(temp_C = NA)
  df_x1 <- df_x1 |> mutate(temp_C = approx(
    x    = df_x0$year,
    y    = df_x0$temp_C,
    xout = new_years,
    rule=1:1
  ) |> as.data.frame() |> pull(y))
  ### Filter years
  df_x1 <- df_x1 |> filter(year >= ref_year0)
  df_x1 <- df_x1 |> mutate(equilTemp = NA, slr_mm = NA)
  df_x1 <- df_x1 |> select(c("year", "temp_C", "equilTemp", "slr_mm"))
  df_x1 <- df_x1 |> mutate(yearFrom0 = year - ref_year0)
  df_x1 <- df_x1 |> mutate(phi = phi0 * exp(-yearFrom0 / tau2))
  # df_x1 |> glimpse(); ind_x |> length() |> print()

  ###### Series ######
  ### Calculate base values
  ### Equilibrium temps

  df_x  <- df_x1 |> (function(k){
    for(i in ind_x){
      if(i == 1){
        ### Initialize temperature
        temp_C0        <- (df_x1 |> filter(year==ref_year0))$temp_C[1]
        k$equilTemp[i] <- temp_C0 - eqtemp_offset
        k$slr_mm   [i] <- 0
      } else{
        k$equilTemp[i] <- k$equilTemp[i - 1] + ( k$temp_C[i] - k$equilTemp[i-1] ) / tau1
        k$slr_mm   [i] <- k$slr_mm[i-1] + alpha * ( k$temp_C[i] - k$equilTemp[i] ) + k$phi[i]
      } ### End else
    } ### End for(i in ind_x)
    return(k)
  })()

  ### GMSL in cm
  df_x  <- df_x |> select(c("year", "slr_mm"))
  df_x  <- df_x |> mutate(slr_cm = slr_mm * mm2cm) ### convert from mm to cm
  df_x  <- df_x |> select(-c("slr_mm"))

  ###### Return ######
  return(df_x)

}

