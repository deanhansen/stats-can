library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')


# Historical Interest Rates from Bank of Canada ---------------------------

## ...
bank_of_canada_interest_rates_raw <- statcan_download_data(tableNumber = "10-10-0139-01", lang = "eng")

## ...
bank_of_canada_interest_rates <- 
  bank_of_canada_interest_rates_raw  |> 
  as_tibble() |>
  clean_names() |> 
  rename(
    "interest_rate"                   = "value",
    "financial_market_statistic_desc" = "financial_market_statistics"
    ) |> 
  filter(!is.na(interest_rate)) |> 
  mutate(
    financial_market_statistic_desc = str_to_title(string = financial_market_statistic_desc),
    year                            = year(ref_date),
    month                           = month(ref_date),
    day                             = day(ref_date)
    ) |> 
  select("ref_date", "geo", "financial_market_statistic_desc", "interest_rate",
         "year", "month", "day")

## ...
write_csv(bank_of_canada_interest_rates, file = "data-raw/bank_of_canada_interest_rates_data.csv")
