library('statcanR')
library('dplyr')

## ...
demographic_growth_components_raw <- statcanR::statcan_download_data(tableNumber = "17-10-0008-01", lang = "eng")

## ...
demographic_growth_components <-
  demographic_growth_components_raw |> 
  dplyr::rename(
    "GROWTH_COMPONENT_DESC" = `Components of population growth`,
    "PERSONS" = "VALUE"
    ) |> 
  dplyr::mutate(
    YEAR  = lubridate::year(REF_DATE),
    MONTH = lubridate::month(REF_DATE)
  ) |> 
  dplyr::select("REF_DATE", "REF_PERIOD", "GEO", "GROWTH_COMPONENT_DESC", 
                "PERSONS", "YEAR", "MONTH")

## ...
readr::write_csv(demographic_growth_components, file = "data-raw/demographic_growth_components_data.csv")
