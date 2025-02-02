library('tidyverse')
library('statcanR')

table <- "18-10-0004-03"
food_prices_raw <- statcan_download_data(table, lang = "eng")

food_prices <-
  food_prices_raw  |> 
  select(REF_DATE, GEO, `Products and product groups`, UOM, TERMINATED, VALUE) |>
  rename(PRODUCT_TYPE = `Products and product groups`) |>
  filter(
    !is.na(VALUE), 
    TERMINATED != "t", 
    UOM == "2002=100", 
    GEO %in% c("Canada", "Ontario")
    ) |> 
  mutate(
    YEAR = year(REF_DATE),
    MONTH = month(REF_DATE),
    DAY = day(REF_DATE)
  ) |> 
  select(REF_DATE, GEO, PRODUCT_TYPE, VALUE, YEAR, MONTH, DAY)

write_csv(food_prices, file = "food_prices/food_prices_data.csv")
