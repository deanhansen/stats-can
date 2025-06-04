library('statcanR')
library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')

## ...
marital_status_raw <- statcan_download_data(tableNumber = "39-10-0056-01", lang = "eng")

## ...
marital_status <- 
  marital_status_raw  |> 
  as_tibble() |>
  clean_names() |> 
  filter(gender_composition_of_the_couple == "Different-gender couples" | gender_composition_of_the_couple == "Total – Gender composition") |> 
  rename("age_in_years" = "value") |> 
  mutate(
    year  = year(ref_date),
    month = month(ref_date)
    ) |> 
  select("ref_date", "geo", "legal_marital_status_prior_to_marriage", "gender",
         "gender_composition_of_the_couple", "indicator", "age_in_years", "year",
         "month")

## ...
write_csv(marital_status, "data-raw/marital_status_data.csv")
