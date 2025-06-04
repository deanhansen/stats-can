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
demographic_growth_components_data <- read_csv(file = "data-raw/demographic_growth_components_data.csv")

## ...
demographic_growth_components_data |> 
  filter(ref_period == "Fiscal year", geo == "Canada", !is.na(persons)) |> 
  ggplot(
    aes(x = ref_date, y = persons, group = components_of_population_growth, colour = components_of_population_growth)
    ) +
  geom_point(size = 1) +
  geom_line(linewidth = 0.5) +
  scale_y_continuous(n.breaks = 10, minor_breaks = NULL, labels = label_number(big.mark = ","))
