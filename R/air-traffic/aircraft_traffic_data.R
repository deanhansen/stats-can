library('statcanR')
library('readr')
library('dplyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')


# Airplane Traffic by Destination -----------------------------------------

## ...
aircraft_traffic_raw <- statcan_download_data(tableNumber = "23-10-0287-01", lang = "eng")

## ...
aircraft_traffic <- 
  aircraft_traffic_raw |>
  as_tibble() |>
  clean_names() |> 
  mutate(year = year(ref_date)) |>
  rename(
    "aircraft_movement_desc"       = "domestic_and_international_itinerant_aircraft_movements",
    "number_of_aircraft_movements" = "value"
    ) |> 
  select("ref_date", "aircraft_movement_desc", "number_of_aircraft_movements", "year")

## ...
write_csv(aircraft_traffic, file = "data-raw/aircraft_traffic_data.csv")


# Aircraft Weight ------------------------------------------------------------------

## ...
aircraft_weight_raw <- statcan_download_data(tableNumber = "23-10-0301-01", lang = "eng")

## ...
aircraft_weight <- 
  aircraft_weight_raw |> 
  as_tibble() |>
  clean_names() |> 
  rename(
    "aircraft_weight_in_kg" = "maximum_take_off_weight",
    "number_of_aircraft"    = "value"
    ) |>
  mutate(
    year                  = year(ref_date),
    airport_location      = str_split_i(string = airports, pattern = ",", i = 2L) |> str_trim(side = "left") |> str_to_title(),
    number_of_aircraft    = if_else(is.na(number_of_aircraft), 0L, number_of_aircraft),
    aircraft_weight_in_kg = factor(
      aircraft_weight_in_kg, 
      levels = c("2,000 kilograms and under", "2,001 to 4,000 kilograms", "4,001 to 5,670 kilograms", "5,671 to 9,000 kilograms",
                 "9,001 to 18,000 kilograms", "18,001 to 35,000 kilograms", "35,001 to 70,000 kilograms", "70,001 to 90,000 kilograms",
                 "90,001 to 136,000 kilograms", "136,001 kilograms and over")
      )
    ) |>
  select("ref_date", "airports", "airport_location", "aircraft_weight_in_kg",
         "number_of_aircraft", "year")

## ...
write_csv(aircraft_weight, file = "data-raw/aircraft_weight_data.csv")
