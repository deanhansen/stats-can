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
population_estimates_raw <- statcan_download_data(tableNumber = "17-10-0005-01", lang =  "eng")

## ...
age_group_levels <- c(paste(seq(0, 95, by = 5), "to", seq(4, 99, by = 5), "years"), "100 years and over")

## ...
population_estimates <- 
  population_estimates_raw |> 
  as_tibble() |> 
  clean_names() |> 
  rename("population" = "value") |>
  filter(age_group %in% age_group_levels) |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "gender", "age_group", 
         "population", "year", "month")

## ...
write_csv(population_estimates, file = "data-raw/population_estimates_data.csv")
