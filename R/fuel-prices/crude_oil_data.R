#| Source: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=2510006301

library('tidyverse')
library('statcanR')

## ...
crude_oil_raw <- 
  statcanR::statcan_download_data(tableNumber = "25-10-0063-01", lang = "eng") |> 
  dplyr::as_tibble() |> 
  dplyr::filter(UOM == "Barrels") |>
  dplyr::rename(
    "PRODUCTION_TYPE" = "Supply and disposition",
    "TOTAL_BARRELS"   = "VALUE"
    ) |> 
  dplyr::select("REF_DATE", "GEO", "PRODUCTION_TYPE", "TOTAL_BARRELS")

## ...
crude_oil <- 
  crude_oil_raw |> 
  dplyr::mutate(
    YEAR  = lubridate::year(REF_DATE), 
    MONTH = lubridate::month(REF_DATE)
    ) |> 
  dplyr::select("REF_DATE", "GEO", "PRODUCTION_TYPE", "TOTAL_BARRELS",
                "YEAR", "MONTH")

## ...
readr::write_csv(x = crude_oil, file = "data-raw/gas_prices_data.csv")