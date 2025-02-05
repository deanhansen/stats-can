library('statcanR')
library('dplyr')

## ...
construction_wages_raw <- statcanR::statcan_download_data(tableNumber = "18-10-0139-01", lang = "eng")

## ...
construction_wages <-
  construction_wages_raw |> 
  dplyr::rename(
    "TRADE"       = `Construction trades`,
    "WAGE_TYPE"   = `Type of wage rates`,
    "HOURLY_WAGE" = "VALUE"
  ) |>
  dplyr::filter(WAGE_TYPE == "Basic construction union wage rates") |>
  mutate(
    YEAR  = lubridate::year(REF_DATE),
    MONTH = lubridate::month(REF_DATE)
    ) |> 
  dplyr::select("REF_DATE", "GEO",  "TRADE", "HOURLY_WAGE", 
                "YEAR", "MONTH")

## ...
readr::write_csv(x = construction_wages, file = "data-raw/construction_wages_data.csv")
