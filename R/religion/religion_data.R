library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')
library('purrr')

## Values of `age` we want to keep for plotting
age_values <- c("0 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 34 years", 
                "35 to 44 years", "45 to 54 years", "55 to 64 years", "65 to 74 years", 
                "75 years and over")

## ...
religion_raw <- statcan_download_data(tableNumber = "98-10-0353-01", lang = "eng")

## ...
religion <- 
  religion_raw |> 
  select(-seq(9, 57, by = 2)) |>
  as_tibble() |>
  clean_names() |> 
  rename_with(
    .cols = starts_with("religion"), 
    .fn   = ~str_split_i(string = .x, pattern = "religion_25_", i = 2)
    ) |>  
  rename(
    "age"        = "age_15c",
    "gender"     = "gender_3",
    "statistics" = "statistics_2"
    ) |> 
  pivot_longer(
    cols      = "total_religion_1":"no_religion_and_secular_perspectives_25",
    names_to  = "religion_name",
    values_to = "total_followers"
    ) |>
  filter(statistics == "2021 Counts", age %in% age_values) |> 
  mutate(
    age             = factor(age, levels = age_values),
    total_followers = as.integer(total_followers),
    year            = year(ref_date),
    month           = month(ref_date)
    ) |> 
  select("ref_date", "geo", "age", "gender",
         "statistics", "religion_name", "total_followers", "year",
         "month")

## ...
write_csv(religion, file = "data-raw/religion_data.csv")
