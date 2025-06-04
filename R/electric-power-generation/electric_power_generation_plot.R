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
electric_power_generation <- read_csv(file = "data-raw/electric_power_generation_data.csv")

## ...
electric_power_generation |> 
  filter(geo == "Canada", class_of_electricity_producer == "Total all classes of electricity producer", str_detect(string = type_of_electricity_generation, pattern = "Total", negate = TRUE), !is.na(mega_watt_hours), mega_watt_hours > 0) |>
  ggplot(
    aes(x = ref_date, y = mega_watt_hours, group = type_of_electricity_generation, colour = type_of_electricity_generation)
    )  +
  geom_point(size = 0.75) +
  geom_line(linewidth = 0.25) +
  scale_y_log10(n.breaks = 10, minor_breaks = NULL, lim = c(1, 10^8), label = label_log())
