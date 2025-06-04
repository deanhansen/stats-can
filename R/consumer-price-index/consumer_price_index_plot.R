library('readr')
library('dplyr')
library('tidyr')
library('janitor')
library('stringr')
library('lubridate')
library('forcats')
library('purrr')
library('ggplot2')
library('scales')
library('ggview')

## ...
consumer_price_index_data <- read_csv(file = "data-raw/consumer_price_index_data.csv")

## ...
consumer_price_index_data |> 
  filter(geo == "Canada", products_and_product_groups != "All-items") |> 
  ggplot(
    aes(x = ref_date, y = consumer_price_index, group = products_and_product_groups, colour = products_and_product_groups)
    ) +
  geom_point(size = 0.75) +
  geom_line(linewidth = 0.25)
