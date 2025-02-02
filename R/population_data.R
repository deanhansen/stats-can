library('tidyverse')
library('statcanR')
import::from(.from = "plyr", mapvalues)

population_raw <- statcan_download_data("17-10-0005-01", "eng")

population <- 
  population_raw |> 
  select(REF_DATE, GEO, UOM, Sex, `Age group`, VALUE) |> 
  filter(GEO == "Canada", UOM == "Persons") |> 
  rename(AGE_GROUP = `Age group`, SEX = Sex) |> 
  mutate(YEAR = year(REF_DATE))

population_2022 <- 
  population |> 
  filter(YEAR == 2022) |> 
  select(GEO, SEX, AGE_GROUP, VALUE, YEAR)

write_csv(population_2022, "immigration/population_2022_data.csv")
