library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
electric_power_generation_raw <- statcan_download_data(tableNumber = "25-10-0015-01", lang = "eng")

## ...
electric_power_generation <-
  electric_power_generation_raw |>
  as_tibble() |> 
  clean_names() |> 
  rename("mega_watt_hours" = "value") |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "class_of_electricity_producer", "type_of_electricity_generation",
         "uom", "mega_watt_hours", "year", "month")

## ...
write_csv(electric_power_generation, file = "data-raw/electric_power_generation_data.csv")
