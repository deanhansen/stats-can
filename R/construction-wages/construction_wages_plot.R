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
library('gghighlight')

## ...
construction_wages <- read_csv(file = "data-raw/construction_wages_data.csv")

## ...
construction_wages |> 
  filter(!is.na(hourly_wage_rate), !geo %in% "Ottawa-Gatineau, Ontario part, Ontario/Quebec") |> 
  mutate(geo = str_split_i(string = geo, pattern = ",", 2) |> str_trim(side = "both")) |> 
  ggplot(
    aes(x = year, y = hourly_wage_rate, group = construction_trades_desc, colour = construction_trades_desc)
    ) +
  geom_point(size = 0.1) +
  geom_line(linewidth = 0.1) +
  gghighlight(hourly_wage_rate == max(hourly_wage_rate), use_group_by = TRUE, calculate_per_facet = TRUE) +
  facet_wrap(~geo)
