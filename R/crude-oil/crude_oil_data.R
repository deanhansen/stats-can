library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
crude_oil_raw <- statcan_download_data(tableNumber = "25-10-0063-01", lang = "eng") 
  
## ...
crude_oil <- 
  crude_oil_raw |> 
  as_tibble() |> 
  clean_names() |> 
  filter(uom == "Barrels") |>
  rename(
    "production_type"            = "supply_and_disposition",
    "total_barrels_of_crude_oil" = "value"
    ) |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "production_type", "total_barrels_of_crude_oil",
         "year", "month")

## ...
write_csv(x = crude_oil, file = "data-raw/crude_oil_data.csv")
