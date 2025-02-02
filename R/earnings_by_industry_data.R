library(tidyverse, warn.conflicts = FALSE)
library(statcanR)

## Download raw data from Stats Can
earnings_by_industry_raw <- statcanR::statcan_download_data("14-10-0204-01", lang = "eng")

## Some basic data cleaning
earnings_by_industry <- 
  earnings_by_industry_raw |> 
  tidyr::drop_na(VALUE) |> 
  dplyr::filter(STATUS == "", VALUE > 0) |>
  dplyr::rename(
    "EMPLOYEE_TYPE"                   = "Type of employees",
    "OVERTIME_LABEL"                  = "Overtime",
    "ANNUAL_WEEKLY_SALARY_IN_DOLLARS" = "VALUE",
    "NAICS_CLASSIFICATION"            = "North American Industry Classification System (NAICS)"
    ) |>
  dplyr::mutate(
    YEAR  = lubridate::year(REF_DATE),
    MONTH = lubridate::month(REF_DATE)
    ) |> 
  dplyr::select("REF_DATE", "YEAR", "MONTH", "GEO", 
                "NAICS_CLASSIFICATION", "EMPLOYEE_TYPE", "OVERTIME_LABEL", "ANNUAL_WEEKLY_SALARY_IN_DOLLARS")

## Write to `data-raw` folder
readr::write_csv(earnings_by_industry, "data-raw/earnings_by_industry_data.csv")
