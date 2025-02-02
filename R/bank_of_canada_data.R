library('statcanR')
library('tidyverse')

## ...
boc_raw <- statcan_download_data(tableNumber = "10-10-0139-01", lang = "eng")

boc <- 
  boc_raw  |> 
  select(REF_DATE, `Financial market statistics`, VALUE) |>
  rename(MARKET_STATISTIC = `Financial market statistics`) |>
  filter(!is.na(VALUE)) |> 
  mutate(
    YEAR = year(REF_DATE),
    MONTH = month(REF_DATE),
    DAY = day(REF_DATE)
  )

write_csv(boc, "bank_of_canada/bank_of_canada_data.csv")
