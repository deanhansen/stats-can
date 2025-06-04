library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')
library('purrr')


# Construction Wages by Trade and Wage Type -------------------------------

## ...
construction_wages_raw <- statcan_download_data(tableNumber = "18-10-0139-01", lang = "eng")

## ...
construction_wages <-
  construction_wages_raw |> 
  as_tibble() |> 
  clean_names() |> 
  rename(
    "construction_trades_desc" = "construction_trades",
    "hourly_wage_rate"         = "value"
    ) |>
  filter(type_of_wage_rates == "Basic construction union wage rates") |>
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "construction_trades_desc", "hourly_wage_rate",
         "year", "month")

## ...
write_csv(x = construction_wages, file = "data-raw/construction_wages_data.csv")
