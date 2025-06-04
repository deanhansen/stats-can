library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
demographic_growth_components_raw <- statcan_download_data(tableNumber = "17-10-0008-01", lang = "eng")

## ...
demographic_growth_components <-
  demographic_growth_components_raw |>
  as_tibble() |> 
  clean_names() |> 
  rename("persons" = "value") |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "ref_period", "geo", "components_of_population_growth", 
         "persons", "year", "month")

## ...
write_csv(demographic_growth_components, file = "data-raw/demographic_growth_components_data.csv")
