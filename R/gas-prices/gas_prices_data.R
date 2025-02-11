## Source: https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1810000101 

library('tidyverse')
library('statcanR')

## This dataset contains average monthly gasoline and fuel oil prices across Canada.
gas_prices_raw <- 
  statcanR::statcan_download_data(tableNumber = "18-10-0001-01", lang = "eng") |> 
  dplyr::as_tibble() |> 
  dplyr::rename(
    "FUEL_TYPE"                         = "Type of fuel",
    "AVG_FUEL_PRICE_IN_CENTS_PER_LITRE" = "VALUE"
    ) |> 
  dplyr::select("REF_DATE", "GEO", "FUEL_TYPE", "AVG_FUEL_PRICE_IN_CENTS_PER_LITRE")

## Factor levels for the `FUEL_TYPE` column
FUEL_TYPE_LEVELS <- c("Regular unleaded gasoline at full service filling stations", "Regular unleaded gasoline at self service filling stations", 
                      "Premium unleaded gasoline at full service filling stations", "Premium unleaded gasoline at self service filling stations",
                      "Diesel fuel at full service filling stations", "Diesel fuel at self service filling stations", "Household heating fuel")

#clean up some of the data
gas_prices <- 
  gas_prices_raw |>
  mutate(
    DOLLARS_PER_LITRE = 0.01 * VALUE, 
    YEAR = lubridate::year(REF_DATE),
    ID_FUEL_TYPE = match(FUEL_TYPE, unique(FUEL_TYPE))
    ) |> 
  select(REF_DATE, GEO, FUEL_TYPE, ID_FUEL_TYPE, DOLLARS_PER_LITRE, YEAR)

#pull the province from GEO tag
gas$GEO <- str_split(gas$GEO, ",") |> 
  map(pluck(1,1)) |> 
  unlist()

#fix the fuel tags
new_fuel_tags <- data.frame(ID=1:3, TEXT=c("Regular gasoline", "Premium gasoline", "Household heating fuel"))

gas <-
  gas |> 
  left_join(
    new_fuel_tags, 
    join_by(ID_FUEL_TYPE == ID)
    ) |> 
  select(-FUEL_TYPE) |> 
  dplyr::rename(FUEL_TYPE = TEXT)

write_csv(gas, "gas_prices/gas.csv")

#------------------------------------------------------

crude_oil_raw <- statcan_download_data("25-10-0063-01", lang = "eng")

crude_oil <- crude_oil_raw |> 
  filter(GEO == "Canada") |> 
  filter(UOM_ID == 34) |> 
  mutate(
    SUPPLY_AND_DISPOSITION = `Supply and disposition`, 
    YEAR = lubridate::year(REF_DATE), 
    MONTH = lubridate::month(REF_DATE)
    ) |> 
  select(REF_DATE, YEAR, GEO, SUPPLY_AND_DISPOSITION, VALUE)

write_csv(crude_oil, "gas_prices/crude_oil.csv")
