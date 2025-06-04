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
food_prices <- read_csv(file = "data-raw/food_prices_data.csv")

## ...
food_prices |> 
  filter(geo == "Canada", products_and_product_groups == "Cigarettes", uom == "2002=100") |> 
  mutate(ref_date = as.Date(ref_date)) |> 
  ggplot(
    aes(x = ref_date, y = food_price_index, group = products_and_product_groups, colour = products_and_product_groups)
    ) +
  geom_point(size = 0.25) +
  geom_line(linewidth = 0.5) +
  annotate(geom = "text", x =  as.Date("2005-01-01"), y = 250, colour = "steelblue", fontface = "bold", label = "As we can see, prices of cigarettes\nhave risen three-fold since 2002") +
  geom_hline(yintercept = 100, linewidth = 0.2, colour = "black", linetype = 2) +
  geom_hline(yintercept = 200, linewidth = 0.4, colour = "black", linetype = 2) +
  geom_hline(yintercept = 300, linewidth = 0.6, colour = "black", linetype = 2) +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  labs(caption = "Prices are measured relative to 2002 prices (i.e., 2002 = 100)")
