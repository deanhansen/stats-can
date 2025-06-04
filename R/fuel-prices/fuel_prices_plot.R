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
library('gganimate')


# Data --------------------------------------------------------------------

fuel_prices <- read_csv("data-raw/fuel_prices_data.csv")

# Average Monthly Price of Gasoline in Toronto -------------------------------------------------------------------

fuel_prices |> 
  filter(str_detect(string = type_of_fuel, pattern = "self service"), geo == "Toronto, Ontario", year > 2010L) |> 
  mutate(
    type_of_fuel = str_split_i(string = type_of_fuel, pattern = "at|self|or", i = 1) |> str_remove_all("unleaded") |> str_trim(),
    type_of_fuel = fct_inorder(type_of_fuel)
    ) |> 
  ggplot(
    aes(x = ref_date, y = monthly_average_retail_price_in_dollars_per_litre, color = type_of_fuel, fill = type_of_fuel)
    ) +
  geom_line(linewidth = 0.05, show.legend = FALSE) +
  geom_area(alpha = 0.25, show.legend = FALSE) +
  scale_x_date(
    expand      = expansion(0.1), 
    date_breaks = "3 years",
    labels      = label_date(format = "%Y")
    ) +
  scale_y_continuous(
    expand = expansion(0), 
    labels = label_currency(), 
    breaks = pretty_breaks(n = 15),
    limits = c(0, 2.6)
    ) +
  scale_colour_manual(values = c("steelblue", "violetred", "magenta3")) +
  scale_fill_manual(values = c("steelblue4", "violetred4", "magenta4")) +
  labs(title = "Average Price of Gas in Toronto", subtitle = "A Tale of Rising Costs") +
  theme(
    text                  = element_text(family = "Comic Sans MS"),
    plot.title            = element_text(size = 16, face = "bold", hjust = 0),
    plot.subtitle         = element_text(size = 12, hjust = 0, margin = margin(b = 10)),
    plot.caption          = element_text(size = 8, hjust = 0, margin = margin(t = 10)),
    legend.title          = element_blank(),
    legend.text           = element_text(size = 10, margin = margin(t = 0, r = 5, b = 0, l = 5)),
    panel.grid.major.x    = element_blank(),
    panel.grid.major.y    = element_line(linewidth = 0.2, colour = "black", linetype = 3),
    panel.grid.minor.x    = element_blank(),
    panel.grid.minor.y    = element_blank(),
    axis.title.x          = element_blank(),
    axis.title.y          = element_blank(), 
    legend.position       = "bottom",
    legend.background     = element_rect(fill = "white"),
    legend.box.background = element_rect(linewidth = 0.5, linetype = 1, color = "white")
    ) +
  facet_wrap(~type_of_fuel, nrow = 1)
