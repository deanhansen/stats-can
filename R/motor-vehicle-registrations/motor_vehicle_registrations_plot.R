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
motor_vehicle_registrations <- read_csv(file = "data-raw/motor_vehicle_registrations_data.csv")

## ...
motor_vehicle_registrations |> 
  filter(geo == "CAN", str_detect(string = fuel_type, pattern = "All", negate = TRUE), str_detect(string = vehicle_type, pattern = "Total", negate = TRUE)) |> 
  ggplot(
    aes(x = ref_date, y = number_of_vehicles, group = fuel_type, colour = fuel_type)
    ) +
  geom_point() +
  geom_line() +
  scale_x_date(date_breaks = "1 year", minor_breaks = NULL, labels = label_date(format = "%y'")) +
  scale_y_continuous(labels = label_comma(), n.breaks = 6, minor_breaks = NULL) +
  facet_wrap(~vehicle_type)
