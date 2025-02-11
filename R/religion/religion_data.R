## Source: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=9810035301

library('statcanR')
library('tidyverse')

## ...
religion_raw <- 
  statcanR::statcan_download_data(tableNumber = "98-10-0353-01", lang = "eng") |> 
  dplyr::select(-seq(9, 57, by = 2)) |>
  dplyr::as_tibble() |>
  dplyr::rename_with(
    .cols = dplyr::starts_with("Religion"), 
    .fn   = \(x) stringr::str_split_i(string = x, pattern = ":", i = 2) |> stringr::str_split_i(pattern = "\\[", i = 1)
    ) |> 
  dplyr::rename(
    "AGE"        = "Age (15C)",
    "GENDER"     = "Gender (3)",
    "STATISTICS" = "Statistics (2)"
  ) |> 
  tidyr::pivot_longer(
    cols      = "Total - Religion":"No religion and secular perspectives",
    names_to  = "RELIGION",
    values_to = "TOTAL_ADHERANTS"
    ) |>
  dplyr::select("REF_DATE", "GEO", "AGE", "GENDER",
                "STATISTICS", "RELIGION", "TOTAL_ADHERANTS")

## Values of `AGE` we want to keep for plotting
AGE_VALUES <- c("0 to 14 years", "15 to 19 years", "20 to 24 years", "25 to 34 years", 
                "35 to 44 years", "45 to 54 years", "55 to 64 years", "65 to 74 years", 
                "75 years and over")

## ...
religion <-
  religion_raw |> 
  dplyr::filter(STATISTICS == "2021 Counts", STATISTICS == "2021 Counts", GENDER != "Total - Gender", AGE %in% AGE_VALUES) |> 
  dplyr::mutate(
    GENDER          = factor(GENDER, levels = c("Men+", "Women+"), labels = c("Men", "Women")),
    AGE             = factor(AGE,    levels = AGE_VALUES),
    TOTAL_ADHERANTS = as.integer(TOTAL_ADHERANTS),
    YEAR            = lubridate::year(REF_DATE)
  ) |> 
  dplyr::select("YEAR", "GEO", "AGE", "GENDER", 
                "RELIGION", "TOTAL_ADHERANTS")

## ...
readr::write_csv(x = religion, file = "data-raw/religion_data.csv")
