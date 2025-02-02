library('statcanR')
library('tidyverse')


# Historical Interest Rates from Bank of Canada ---------------------------

bank_of_canada_interest_rates_raw <- statcan_download_data(tableNumber = "10-10-0139-01", lang = "eng")

bank_of_canada_interest_rates <- 
  bank_of_canada_interest_rates_raw  |> 
  dplyr::as_tibble() |>
  dplyr::rename(
    "INTEREST_RATE"                   = "VALUE",
    "FINANCIAL_MARKET_STATISTIC_DESC" = `Financial market statistics`
    ) |> 
  dplyr::filter(!is.na(INTEREST_RATE)) |> 
  dplyr::mutate(
    FINANCIAL_MARKET_STATISTIC_DESC = stringr::str_to_title(string = FINANCIAL_MARKET_STATISTIC_DESC),
    YEAR                            = lubridate::year(REF_DATE),
    MONTH                           = lubridate::month(REF_DATE),
    DAY                             = lubridate::day(REF_DATE)
  ) |> 
  dplyr::select("REF_DATE", "GEO", "FINANCIAL_MARKET_STATISTIC_DESC", "INTEREST_RATE",
                "YEAR", "MONTH", "DAY")

readr::write_csv(bank_of_canada_interest_rates, "data-raw/bank_of_canada_interest_rates_data.csv")
