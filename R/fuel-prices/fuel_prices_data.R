#| Source: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1810000101 

library('tidyverse')
library('statcanR')


## This dataset contains average monthly gasoline and fuel oil prices across Canada.
fuel_prices_raw <- 
  statcanR::statcan_download_data(tableNumber = "18-10-0001-01", lang = "eng") |> 
  dplyr::as_tibble() |> 
  dplyr::rename(
    "FUEL_TYPE"                         = "Type of fuel",
    "AVG_FUEL_PRICE_IN_CENTS_PER_LITRE" = "VALUE"
    ) |> 
  dplyr::select("REF_DATE", "GEO", "FUEL_TYPE", "AVG_FUEL_PRICE_IN_CENTS_PER_LITRE")

## Factor levels for the `FUEL_TYPE` column
FUEL_TYPE_LEVELS <- c("Regular unleaded gasoline at full service filling stations", "Regular unleaded gasoline at self service filling stations", 
                      "Premium unleaded gasoline at full service filling stations", "Premium unleaded gasoline at self service filling stations",
                      "Diesel fuel at full service filling stations", "Diesel fuel at self service filling stations", "Household heating fuel")

## ...
fuel_prices <- 
  fuel_prices_raw |>
  dplyr::mutate(
    AVG_FUEL_PRICE_IN_DOLLARS_PER_LITRE = AVG_FUEL_PRICE_IN_CENTS_PER_LITRE * 1e-2, 
    YEAR                                = lubridate::year(REF_DATE),
    MONTH                               = lubridate::month(REF_DATE)
    ) |> 
  dplyr::select("REF_DATE", "GEO", "FUEL_TYPE", "AVG_FUEL_PRICE_IN_DOLLARS_PER_LITRE",
                "YEAR", "MONTH")

## ...
readr::write_csv(x = fuel_prices, file = "data-raw/fuel_prices_data.csv")
