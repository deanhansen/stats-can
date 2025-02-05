library(tidyverse)
library(statcanR)
library(plyr)


# Fetch full dataset ------------------------------------------------

cmhc_housing_starts_raw <- statcan_download_data("34-10-0135-01", lang = "eng")
cmhc_housing_starts <-
  cmhc_housing_starts_raw |> 
  filter(GEO == "Canada") |> 
  filter(`Housing estimates` == "Housing completions") |> 
  filter(`Type of unit` == "Total units") |> 
  select(REF_DATE,
         GEO,
         COMPLETED_HOUSES = VALUE)

quarterly_population_estimates_raw <- statcan_download_data("17-10-0009-01", lang = "eng")
quarterly_population_estimates <- 
  quarterly_population_estimates_raw |> 
  filter(GEO == "Canada") |> 
  select(REF_DATE, 
         POPULATION = VALUE)

fred_economic_data_raw <- read_csv("fred_economic_data.csv") # index set to 100 for 2010
fred_economic_data <- 
  fred_economic_data_raw |> 
  mutate(GEO = "Canada") |> 
  select(REF_DATE = DATE,
         INDEX_VALUE = QCAR628BIS)

df <- 
  join(x=cmhc_housing_starts,
     y=quarterly_population_estimates,
     by = "REF_DATE",
     type = "inner") |> 
  select(REF_DATE, GEO, POPULATION, COMPLETED_HOUSES) |> 
  join(fred_economic_data, 
       by = "REF_DATE",
       type = "inner") |> 
  select(REF_DATE, GEO, POPULATION, COMPLETED_HOUSES, INDEX_VALUE)

#write_csv(df, file="canada_housing_completions_data.csv")
