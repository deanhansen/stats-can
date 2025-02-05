library('tidyverse')
library('scales')
library('shadowtext')
library('patchwork')
library('showtext')
library('sysfonts')
showtext_auto()

GREEN <- "#2FC1D3"
BLUE <- "#076FA1"
BLUE_DARKER <- "#1f2e7a"
GREY_DARKER <- "#5C5B5D"
BLACK <- "#0d0d0d"
RED_DARK <- "#852e57"


motor_vehicle_registrations <- #load the data
  read_csv(
    "motor_vehicle_registrations/motor_vehicle_registrations.csv",
    col_types = cols(
      GEO = readr::col_factor(), 
      FUEL_TYPE = readr::col_factor(),
      VEHICLE_TYPE = readr::col_factor()
      )
    ) |>
  mutate(
    GEO = fct_recode(
      GEO,
      "CAN" = "Canada",
      "PEI" = "Prince Edward Island",
      "NB"  = "New Brunswick",
      "QUE" = "Quebec",
      "ON"  = "Ontario",
      "MB"  = "Manitoba",
      "SAS" = "Saskatchewan",
      "BC"  = "British Columbia and the Territories"
    ),
    FUEL_TYPE = fct_recode(
      FUEL_TYPE,
      "Gas"      = "Gasoline", 
      "Diesel"   = "Diesel", 
      "Electric" = "Battery electric", 
      "Hybrid"   = "Hybrid electric",
      "Hybrid"   = "Plug-in hybrid electric"
    )
  )

motor_vehicle_registrations_g <-
  motor_vehicle_registrations |> 
  filter(
    GEO == "CAN"
  ) |>
  select(
    REF_DATE, 
    FUEL_TYPE,
    VEHICLE_TYPE,
    NUMBER_OF_CARS
  ) |> 
  group_by(
    REF_DATE,
    FUEL_TYPE
  ) |> 
  dplyr::reframe(
    VALUE = sum(NUMBER_OF_CARS)
  )

g <- #create ggplot object
  motor_vehicle_registrations_g |>
  ggplot(aes(x = REF_DATE, y = VALUE))

g + 
  geom_area(aes(fill = FUEL_TYPE)) +
  scale_fill_manual(
    values = c(GREEN, BLUE, BLUE_DARKER, GREY_DARKER),
    aesthetics = "fill"
    ) +
  scale_x_date(date_breaks = "1 year",
    labels = scales::label_date(),
    date_labels = "%b-%Y",
    name = ""
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0,400000),
    labels = scales::label_comma()
  ) +
  labs(
    x = "Year",
    y = "",
    fill = "",
    title = "New Motor Vehicle Registrations",
    subtitle = "By Fuel Type",
    caption = "**data unavailable for Alberta, New Brunswick and Nova Scotia
    Source: https://statcan.gc.ca/"
  ) +
  theme(
    plot.title.position = "plot",
    text = element_text(size = 28),
    plot.title = element_text(family = "sans", face = "bold", size = 50),
    plot.caption.position = "plot",
    legend.position = "top",
    legend.text = element_text(family = "sans", size = 28),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#A8BAC4", linewidth = 0.25),
    panel.background = element_rect(fill = "white")
  )
