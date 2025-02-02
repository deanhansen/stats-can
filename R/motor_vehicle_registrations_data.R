library('statcanR')
library('tidyverse')
source("utils/data_loading.R")

#use personal tidy version of statcan_download_data
motor_vehicle_registrations_raw <- statcan_download_data_tidy("20-10-0024-01", lang = "eng")

motor_vehicle_registrations <- 
  motor_vehicle_registrations_raw |> 
  dplyr::rename(
    FUEL_TYPE = `Fuel type`,
    VEHICLE_TYPE = `Vehicle type`,
    NUMBER_OF_CARS = VALUE
    ) |> 
  select(
    -Statistics,
    -INDICATOR,
    -UOM
  ) |> 
  mutate(
    YEAR = lubridate::year(REF_DATE),
    MONTH = lubridate::month(REF_DATE),
    DAY = lubridate::day(REF_DATE),
    ) |> 
  filter(
    !is.na(NUMBER_OF_CARS)
    ) |> 
  filter(
    FUEL_TYPE %in% c("Gasoline", "Diesel", "Battery electric", "Hybrid electric", "Plug-in hybrid electric")
    ) |> 
  filter(
    VEHICLE_TYPE %in% c("Passenger cars", "Pickup trucks", "Vans")
    ) |> 
  mutate(
    GEO = fct_recode(
      GEO,
      "CAN" = "Canada",
      "PEI" = "Prince Edward Island",
      "NB"  = "New Brunswick",
      "QUE" = "Quebec",
      "ON"  = "Ontario",
      "MB"  = "Manitoba",
      "SAS" = "Saskatchewan",
      "BC"  = "British Columbia and the Territories"
    ),
    FUEL_TYPE = fct_recode(
      FUEL_TYPE,
      "Gas"      = "Gasoline", 
      "Diesel"   = "Diesel", 
      "Electric" = "Battery electric", 
      "Hybrid"   = "Hybrid electric",
      "Hybrid"   = "Plug-in hybrid electric"
    )
  ) |> 
  select(
    YEAR,
    MONTH,
    DAY,
    REF_DATE,
    GEO,
    FUEL_TYPE,
    VEHICLE_TYPE,
    NUMBER_OF_CARS
    )

write_csv(motor_vehicle_registrations, "motor_vehicle_registrations/motor_vehicle_registrations.csv")
