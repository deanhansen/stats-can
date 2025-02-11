## Source: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1810000601

library('statcanR')
library('tidyverse')

## The following data are the seasonally adjusted monthly CPI values (components included).
## StatsCan compares price changes relative the CPI in 2002 prices, so `VALUE` == 100 in 2002.
consumer_price_index_raw <-
  statcanR::statcan_download_data(tableNumber = "18-10-0006-01", lang = "eng") |> 
  dplyr::as_tibble() |> 
  dplyr::rename(
    "PRODUCT_TYPE"         = "Products and product groups",
    "CONSUMER_PRICE_INDEX" = "VALUE"
    ) |> 
  dplyr::select("REF_DATE", "GEO", "PRODUCT_TYPE", "CONSUMER_PRICE_INDEX", 
                "UOM")

## Add the `YEAR` and `MONTH` to the table, this way we can join onto other Statistics Canada datasets.
consumer_price_index <-
  consumer_price_index_raw |> 
  dplyr::mutate(
    YEAR  = lubridate::year(REF_DATE),
    MONTH = lubridate::month(REF_DATE)
  ) |> 
  dplyr::select("REF_DATE", "GEO", "PRODUCT_TYPE", "CONSUMER_PRICE_INDEX", 
                "UOM", "YEAR", "MONTH")

## Save to a .csv file
readr::write_csv(x = consumer_price_index, file = "data-raw/consumer_price_index_data.csv")
  