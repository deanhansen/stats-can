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
housing <- read_csv("data-raw/housing_data.csv")

## ...
housing |> 
  filter(geo == "Canada", month == 10, housing_estimates == "Housing completions") |> 
  mutate(housing_estimates = fct_inorder(housing_estimates)) |>
  ggplot(
    aes(x = total_units, y = population)
    ) +
  geom_path(alpha = 0.5) +
  geom_point(colour = "red3") +
  scale_x_continuous(n.breaks = 12, labels = label_comma()) +
  scale_y_continuous(n.breaks = 6, labels = label_comma()) +
  labs(title = "Canada Completes More Houses with Smaller Population", x = "Housing Completions in Canada", y = "Population")
