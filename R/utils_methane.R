### Utility functions for the FrEDI methane module
### Function for mortality
# calc_mortality  <- listMethane$package$coefficients[["Mortality"]][["fun0"]]
calc_methane_mortality <- function(
    df0, ### Tibble with population and years
    df1      = listMethane$package$rff_nat_pop, ### Tibble with columns for mortality rate slope and mortality rate intercept
    pCol0    = "national_pop"      , ### Column with national population
    sCol0    = "rffMrate_slope"    , ### Column with mortality rate slope,
    iCol0    = "rffMrate_intercept", ### Column with mortality rate intercept,
    joinCols = c("year") ### Column to join df0 and df1
){
  ### Select columns
  select0 <- c("year", "ifRespScalar", "rffPop") |> c(sCol0, iCol0)
  df1     <- df1 |> select(all_of(select0))
  ### Join df0 and df1
  join0   <- joinCols
  df0     <- df0 |> left_join(df1, by=join0)
  rm(df1)
  ### Calculate intermediate populations
  # df0     <- df0 |> mutate(delta_rffPop = !!sym(pCol0) - rffPop)
  # df0     <- df0 |> mutate(rffFactor    = delta_rffPop * !!sym(sCol0) + !!sym(iCol0))
  df0     <- df0 |> mutate(logPop       = (!!sym(pCol0)) |> log())
  df0     <- df0 |> mutate(rffFactor    = logPop       * !!sym(sCol0) + !!sym(iCol0))
  df0     <- df0 |> mutate(respMrate    = rffFactor    * ifRespScalar)
  ### Return data
  return(df0)
}

### Function to calculate NOx factor
# calc_NOx_factor <- listMethane$package$coefficients[["NOx"      ]][["fun0"]]
# slope0     = -0.49
# intercept0 = -1.12
# adj0       = 1e3/556
calc_NOx_factor <- function(
    nox0,
    slope0     = listMethane$package$coefficients$NOx$slope0,
    intercept0 = listMethane$package$coefficients$NOx$intercept0,
    adj0       = listMethane$package$coefficients$NOx$adj0
){
  nox0 <- nox0 |> log()
  nox0 <- nox0 * slope0 + intercept0
  nox0 <- nox0 * adj0
  return(nox0)
}

### Function to calculate NOx ratio
calc_NOx_ratio <- function(
    df0, ### Tibble with NOx values
    factor0 = listMethane$package$coefficients[["NOx"]][["NOxFactor0"]]
){
  ### Calculate new NOx factor
  df0   <- df0 |> mutate(NOxFactor  = NOx_Mt |> calc_NOx_factor())
  df0   <- df0 |> mutate(NOxFactor0 = factor0)
  df0   <- df0 |> mutate(NOxRatio   = NOxFactor / NOxFactor0)
  ### Return
  return(df0)
}

### Function to calculate O3 concentration from CH4 concentration and NOX
calc_o3_conc <- function(
    df0 ### Tibble with CH4, NOx, and O3 response values
){
  ### Calculate NOx ratio
  ### Calculate O3 concentration
  df0   <- df0 |> calc_NOx_ratio()
  df0   <- df0 |> mutate(O3_pptv = CH4_ppbv * NOxRatio * state_o3response_pptv_per_ppbv)
  ### Return
  return(df0)
}


### Format methane drivers
format_methane_drivers <- function(
    df0, ### Tibble with scenarios
    df1=listMethane$package$state_rrScalar
){
  ### Format data
  idCols0  <- c("region", "state", "postal", "model")
  sumCols0 <- c("state_o3response_pptv_per_ppbv", "state_mortScalar")
  select0  <- idCols0 |> c(sumCols0)
  df1      <- df1     |> select(all_of(select0))
  ### Join data
  join0    <- df0 |> names() |> get_matches(y=df1 |> names())
  df0      <- df0 |> left_join(df1, by=join0, relationship="many-to-many")
  rm(df1)
  ### Calculate O3 if methane and nox present
  do_o3    <- df0 |> names() |> get_matches(y=c("CH4_ppbv")) |> length()
  if(do_o3) df0 <- df0 |> calc_o3_conc()
  ### Reorganize values
  move0   <- c("region", "state", "postal", "model") |> c("year")
  df0     <- df0 |> relocate(all_of(move0))
  df0     <- df0 |> arrange_at(c(move0))
  ### Return
  return(df0)
}


### Function to calculate CONUS scenario
calc_conus_scenario <- function(
    df0 ### Tibble with state population and GDP information
){
  ### Filter to CONUS states
  ### Group and summarize over year
  ### Join with df0
  filter0 <- c("AK", "HI")
  group0  <- c("year")
  df1     <- df0 |> filter(!postal %in% filter0)
  df1     <- df1 |> group_by_at(c(group0)) |> summarize(conus_pop = pop |> sum(na.rm=T), .groups="drop")
  ### Join data
  join0   <- df0 |> names() |> get_matches(y=df1 |> names())
  df0     <- df0 |> left_join(df1, by=join0)
  rm(filter0, group0, join0, df1)
  ### Calculate new gdp_percap
  df0     <- df0 |> mutate(gdp_percap_conus = gdp_usd / conus_pop)
  ### Reorganize values
  move0   <- c("region", "state", "postal") |> c("year")
  df0     <- df0 |> relocate(all_of(move0))
  df0     <- df0 |> arrange_at(c(move0))
  ### Return
  return(df0)
}


### Function to calculate economic scalars
calc_methane_scalars <- function(
    df0, ### Tibble with information on CONUS scenario
    scalar0    = "vsl_usd",
    mult0      = "gdp_percap_conus",
    adj0       = listMethane$package$coefficients[["vsl_adj0"]] |> pull(gdp_percap),
    df1        = rDataList$frediData$co_impactTypes |> filter(econScalarName %in% scalar0),
    df2        = rDataList$stateData$df_scalars |> filter(scalarName %in% scalar0),
    elasticity = rDataList$fredi_config$elasticity0
){
  ### Format impact types:
  ### - Get distinct values
  ### - Adjust econMultiplierName from "gdp_percap" to "gdp_percap_conus"
  select0   <- c("econScalarName", "econMultiplierName", "c0", "c1", "exp0", "year0")
  # df1       <- df1 |> filter(econScalarName %in% scalar0)
  df1       <- df1 |> select(all_of(select0)) |> distinct()
  df1       <- df1 |> mutate(econMultiplierName = mult0)

  ### Add econScalarName
  ### Join with df0
  join0     <- c("econScalarName")
  # df0 |> glimpse(); df1 |> glimpse()
  df0       <- df0 |> mutate(econScalarName=scalar0)
  df0       <- df0 |> left_join(df1, by=join0)

  ### Adjust elasticity
  df0       <- df0 |> mutate(exp0 = (econScalarName=="vsl_usd") |> ifelse(elasticity, exp0))

  ### Filter scalars
  drop0     <- c("region", "state", "postal") |> c("scalarType", "national_or_regional")
  renameAt0 <- c("scalarName", "value")
  renameTo0 <- c("econScalarName", "econScalarValue")
  join0     <- c("econScalarName", "year")
  years0    <- df0 |> pull(year) |> unique()
  df2       <- df2 |> filter(year %in% years0)
  df2       <- df2 |> select(-any_of(drop0))
  df2       <- df2 |> rename_at(c(renameAt0), ~renameTo0)
  df0       <- df0 |> left_join(df2, by=join0)
  rm(drop0, renameAt0, renameTo0, join0, years0)

  ### Economic adjustments (following FrEDI)
  df0     <- df0 |> mutate(econMultiplierValue = !!sym(mult0))
  df0     <- df0 |> mutate(econAdjValue        = adj0)
  df0     <- df0 |> mutate(econMultiplier      = (econMultiplierValue / econAdjValue)**exp0 )
  df0     <- df0 |> mutate(econScalar          = c0 + c1 * econScalarValue * (econMultiplier))

  ### Reorganize values
  move0   <- c("region", "state", "postal") |> c("year")
  df0     <- df0 |> relocate(all_of(move0))
  df0     <- df0 |> arrange_at(c(move0))

  ### Return
  return(df0)
}


### Function to calculate impacts
calc_methane_impacts <- function(
    df0, ### Tibble with population scenario and mortality
    df1  ### Tibble with ozone concentrations
){
  ### Join data with drivers
  # df0 |> glimpse(); df1 |> glimpse()
  join0 <- df0 |> names() |> get_matches(y=df1 |> names())
  df0   <- df0 |> left_join(df1, by=join0)
  rm(df1)
  ### Reorganize values
  move0   <- c("region", "state", "postal", "model") |> c("year")
  df0     <- df0 |> relocate(all_of(move0))
  df0     <- df0 |> arrange_at(c(move0))
  ### Calculate excess mortality
  df0   <- df0 |> mutate(physical_impacts = pop * respMrate * state_mortScalar * O3_pptv)
  ### Calculate annual impacts
  df0   <- df0 |> mutate(annual_impacts   = physical_impacts * econScalar)
}

