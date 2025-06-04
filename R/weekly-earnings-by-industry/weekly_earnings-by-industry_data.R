library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')
library('purrr')

## ...
weekly_earnings_by_industry_raw <- statcan_download_data(tableNumber = "14-10-0204-01", lang = "eng")

## ...
weekly_earnings_by_industry <- 
  weekly_earnings_by_industry_raw |> 
  as_tibble() |> 
  clean_names() |>
  rename(
    "naics"                            = "north_american_industry_classification_system_naics",
    "average_weekly_salary_in_dollars" = "value"
    ) |> 
  filter(status == "", average_weekly_salary_in_dollars > 0, !is.na(average_weekly_salary_in_dollars)) |>
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "year", "month", "geo",
         "naics", "type_of_employees", "overtime", "average_weekly_salary_in_dollars")

## ...
write_csv(weekly_earnings_by_industry, file = "data-raw/weekly_earnings_by_industry_data.csv")
