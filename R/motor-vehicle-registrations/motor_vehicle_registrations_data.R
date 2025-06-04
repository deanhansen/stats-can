library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')
library('purrr')

## ...
motor_vehicle_registrations_raw <- statcan_download_data(tableNumber = "20-10-0024-01", lang = "eng")

## ...
motor_vehicle_registrations <- 
  motor_vehicle_registrations_raw |>
  as_tibble() |> 
  clean_names() |> 
  rename("number_of_vehicles" = "value") |> 
  filter(!is.na(number_of_vehicles)) |> 
  mutate(
    year      = year(ref_date),
    month     = month(ref_date),
    geo       = fct_recode(
      geo,
      "CAN" = "Canada",
      "PEI" = "Prince Edward Island",
      "NB"  = "New Brunswick",
      "QUE" = "Quebec",
      "ON"  = "Ontario",
      "MB"  = "Manitoba",
      "SAS" = "Saskatchewan",
      "BC"  = "British Columbia and the Territories"
    ),
    fuel_type = fct_recode(
      fuel_type,
      "Gas"             = "Gasoline", 
      "Diesel"          = "Diesel", 
      "Electric"        = "Battery electric", 
      "Hybrid Electric" = "Hybrid electric",
      "Hybrid Electric" = "Plug-in hybrid electric",
      "Other"           = "Other fuel types"
      ),
    year      = year(ref_date),
    month     = month(ref_date)
    ) |> 
  select("ref_date", "geo", "fuel_type", "vehicle_type", 
         "number_of_vehicles", "year", "month")

## ...
write_csv(motor_vehicle_registrations, file = "data-raw/motor_vehicle_registrations_data.csv")
