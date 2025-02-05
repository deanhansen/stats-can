library('statcanR')
library('tidyverse')

## ...
population_estimates_raw <- statcanR::statcan_download_data(tableNumber = "17-10-0005-01", lang =  "eng")

## ...
# AGE_GROUP_LEVELS <- paste(seq(0, 99, by = 1), "years")
AGE_GROUP_LEVELS  <- c(paste(seq(0, 95, by = 5), "to", seq(4, 99, by = 5), "years"), "100 years and over")

## ...
population_estimates <- 
  population_estimates_raw |> 
  dplyr::as_tibble() |> 
  dplyr::rename(
    "GENDER"          = "Gender",
    "AGE_GROUP"       = `Age group`,
    "POPULATION_SIZE" = "VALUE"
  ) |>
  dplyr::filter(AGE_GROUP %in% AGE_GROUP_LEVELS) |> 
  dplyr::mutate(
    GENDER = dplyr::case_when(
      GENDER == "Men+"           ~ "Men", 
      GENDER == "Women+"         ~ "Women",
      GENDER == "Total - gender" ~ "Total - Gender"
      ),
    YEAR   = lubridate::year(REF_DATE)
    ) |> 
  dplyr::select("REF_DATE", "GEO", "GENDER", "AGE_GROUP", 
         "POPULATION_SIZE", "YEAR")

## ...
readr::write_csv(population_estimates, "data-raw/population_estimates_data.csv")
