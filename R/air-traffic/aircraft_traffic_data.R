library('statcanR')
library('tidyverse')


# Airplane Traffic by Destination -----------------------------------------

aircraft_traffic_raw <- statcanR::statcan_download_data(tableNumber = "23-10-0287-01", lang = "eng")

aircraft_traffic <- 
  aircraft_traffic_raw |>
  dplyr::as_tibble() |>
  dplyr::mutate(YEAR = lubridate::year(REF_DATE)) |>
  dplyr::rename(
    "AIRCRAFT_MOVEMENT_DESC"       = `Domestic and international itinerant aircraft movements`,
    "NUMBER_OF_AIRCRAFT_MOVEMENTS" = "VALUE"
    ) |> 
  dplyr::select("REF_DATE", "AIRCRAFT_MOVEMENT_DESC", "NUMBER_OF_AIRCRAFT_MOVEMENTS", "YEAR")

readr::write_csv(aircraft_traffic, file = "data-raw/aircraft_traffic_data.csv")


# Aircraft Weight ------------------------------------------------------------------

aircraft_weight_raw <- statcanR::statcan_download_data(tableNumber = "23-10-0301-01", lang = "eng")

aircraft_weight <- 
  aircraft_weight_raw |> 
  dplyr::as_tibble() |>
  dplyr::rename(
    "AIRPORTS"              = "Airports",
    "AIRCRAFT_WEIGHT_IN_KG" = `Maximum take-off weight`,
    "NUMBER_OF_AIRCRAFT"    = "VALUE"
    ) |>
  dplyr::mutate(
    YEAR                  = lubridate::year(REF_DATE),
    AIRPORT_LOCATION      = stringr::str_split_i(string = AIRPORTS, pattern = ",", i = 2L) |> stringr::str_trim(side = "left") |> stringr::str_to_title(),
    NUMBER_OF_AIRCRAFT    = dplyr::if_else(is.na(NUMBER_OF_AIRCRAFT), 0L, NUMBER_OF_AIRCRAFT),
    AIRCRAFT_WEIGHT_IN_KG = factor(
      AIRCRAFT_WEIGHT_IN_KG, 
      levels = c("2,000 kilograms and under", "2,001 to 4,000 kilograms", "4,001 to 5,670 kilograms", "5,671 to 9,000 kilograms",
                 "9,001 to 18,000 kilograms", "18,001 to 35,000 kilograms", "35,001 to 70,000 kilograms", "70,001 to 90,000 kilograms",
                 "90,001 to 136,000 kilograms", "136,001 kilograms and over")
      )
    ) |>
  dplyr::select("REF_DATE", "AIRPORTS", "AIRPORT_LOCATION", "AIRCRAFT_WEIGHT_IN_KG",
                "NUMBER_OF_AIRCRAFT",  "YEAR")

readr::write_csv(aircraft_weight, file = "data-raw/aircraft_weight_data.csv")
