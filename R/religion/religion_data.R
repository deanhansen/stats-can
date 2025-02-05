library('statcanR')
library('tidyverse')
source('statscan_utils/data_loading.R')

religion_raw <- statcan_download_data("98-10-0353-01", lang = "eng")

#remove multiple columns
religion <-
  religion_raw |> 
  select(-c(Symbol, DGUID, COORDINATE, INDICATOR, Coordinate))

#update the names of the columns
names(religion) <- 
  religion |> 
  names() |> 
  snakecase::to_snake_case() |> 
  str_replace("religion_25_", "") |> 
  str_replace_all("[:digit:]", "") |> 
  snakecase::to_snake_case()

#filter out data for only % of population
religion <-
  religion |> 
  filter(
    statistics == "% distribution (2021)",
    gender == "Total - Gender",
    age_c != "Total - Age"
  ) |> 
  select(
    -c(gender, statistics, total_religion)
  ) |> 
  pivot_longer(
    cols = 4:27, 
    names_to = "name", 
    values_to = "proportion"
    )

write_csv(religion, "religion/religion.csv")
