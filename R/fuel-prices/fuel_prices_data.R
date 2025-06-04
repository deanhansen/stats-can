library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## This dataset contains average monthly gasoline and fuel oil prices across Canada.
fuel_prices_raw <- statcan_download_data(tableNumber = "18-10-0001-01", lang = "eng")

## ...
fuel_prices <- 
  fuel_prices_raw |>
  as_tibble() |> 
  clean_names() |> 
  mutate(
    monthly_average_retail_price_in_dollars_per_litre = value * 1e-2, 
    year                                              = year(ref_date),
    month                                             = month(ref_date)
    ) |> 
  dplyr::select("ref_date", "geo", "type_of_fuel", "monthly_average_retail_price_in_dollars_per_litre",
                "year", "month")

## ...
write_csv(x = fuel_prices, file = "data-raw/fuel_prices_data.csv")
