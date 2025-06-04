library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
consumer_price_index_raw <- statcan_download_data(tableNumber = "18-10-0006-01", lang = "eng")

## The following data are the seasonally adjusted monthly CPI values (components included).
## StatsCan compares price changes relative the CPI in 2002 prices, so `VALUE` == 100 in 2002.
consumer_price_index <-
  consumer_price_index_raw |> 
  as_tibble() |> 
  clean_names() |> 
  rename("consumer_price_index" = "value") |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "products_and_product_groups", "consumer_price_index", 
         "uom", "year", "month")

## Save to a .csv file
write_csv(x = consumer_price_index, file = "data-raw/consumer_price_index_data.csv")
  