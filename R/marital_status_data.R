library('tidyverse')
library('statcanR')
import::from(.from = "plyr", mapvalues)

marital_status_raw <- statcan_download_data("39-10-0056-01", lang = "eng")

marital_status <- 
  marital_status_raw  |> 
  select(REF_DATE, GEO, Gender, `Gender composition of the couple`,  `Legal marital status prior to marriage`, VALUE, Indicator) |>
  rename(GENDER_COUPLE = `Gender composition of the couple`, GENDER = Gender, PRIOR_MARITAL_STATUS = `Legal marital status prior to marriage`, INDICATOR = Indicator) |>
  filter(GENDER_COUPLE == "Different-gender couples" | GENDER_COUPLE == "Total – Gender composition") |>
  select(-GENDER_COUPLE)

marital_status$GENDER <- mapvalues(marital_status$GENDER,
                                   from=c("Total – Gender", "Men+", "Women+"), 
                                   to=c("Total","Male","Female"))

marital_status$INDICATOR <- mapvalues(marital_status$INDICATOR,
                                      from=c("Mean age at marriage", "Median age at marriage"), 
                                      to=c("mean","median"))

write_csv(marital_status, "marital_status/marital_status_data.csv")
