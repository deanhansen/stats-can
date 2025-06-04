library('readr')
library('dplyr')
library('janitor')
library('stringr')
library('lubridate')

## ...
cmhc_housing_raw <- statcan_download_data("34-10-0135-01", lang = "eng")

## ...
cmhc_housing <-
  cmhc_housing_raw |>
  as_tibble() |> 
  clean_names() |> 
  filter(type_of_unit == "Total units", seasonal_adjustment == "Unadjusted") |> 
  rename("total_units" = "value") |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "housing_estimates", "total_units", 
         "year", "month")

## ...
quarterly_population_estimates_raw <- statcan_download_data(tableNumber = "17-10-0009-01", lang = "eng")

## ...
quarterly_population_estimates <- 
  quarterly_population_estimates_raw |> 
  as_tibble() |> 
  clean_names() |>
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  rename("population" = "value") |> 
  select("ref_date", "geo", "population", "year", 
         "month")

## ...
housing <-
  cmhc_housing |> 
  inner_join(quarterly_population_estimates, by = join_by("ref_date", "geo", "year", "month")) |> 
  select("ref_date", "geo", "housing_estimates", "total_units",
         "population", "year", "month")

## ...
write_csv(quarterly_population_estimates, file = "data-raw/quarterly_population_estimates_data.csv")
write_csv(housing,                        file = "data-raw/housing_data.csv")
