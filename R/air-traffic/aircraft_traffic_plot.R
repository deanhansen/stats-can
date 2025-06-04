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
aircraft_weight  <- read_csv(file = "data-raw/aircraft_weight_data.csv")
aircraft_traffic <- read_csv(file = "data-raw/aircraft_traffic_data.csv")


# Number of Aircraft Flying from Canadian Airports by Weight Category --------------------------------------------------------------------

aircraft_weight |> 
  filter(airport_location == "All Airports") |> 
  group_by(ref_date, aircraft_weight_in_kg) |> 
  reframe(total_aircraft = sum(number_of_aircraft)) |>
  ggplot(
    aes(x = ref_date, y = total_aircraft, colour = aircraft_weight_in_kg)
    ) +
  geom_point() +
  geom_line() +
  scale_y_continuous(labels = label_number()) +
  labs(colour = "Aircraft Weight Category") +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
    ) +
  facet_wrap(~aircraft_weight_in_kg, nrow = 5)
