library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
food_prices_raw <- statcan_download_data(table = "18-10-0004-03", lang = "eng")

## ...
food_prices <-
  food_prices_raw  |> 
  as_tibble() |> 
  clean_names() |> 
  rename("food_price_index" = "value") |> 
  filter(terminated != "t", !is.na(food_price_index)) |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "products_and_product_groups", "food_price_index",
         "uom", "year", "month")

## ...
write_csv(food_prices, file = "data-raw/food_prices_data.csv")
