library('tidyverse')
library('scales')
library('gganimate')

# Data --------------------------------------------------------------------

fuel_prices <- readr::read_csv("data-raw/fuel_prices_data.csv")
crude_oil   <- readr::read_csv("data-raw/crude_oil_data.csv")

crude_oil_imports_exports <- 
  crude_oil |> 
  dplyr::filter(SUPPLY_AND_DISPOSITION %in% c("Imports", "Exports"))


# gas plots -------------------------------------------------------------------

fuel_prices |> 
  dplyr::filter(
    stringr::str_detect(string = FUEL_TYPE, pattern = "self service"),
    GEO == "Toronto, Ontario"
    ) |> 
  ggplot(aes(x = REF_DATE, y = AVG_FUEL_PRICE_IN_DOLLARS_PER_LITRE, color = FUEL_TYPE, fill = FUEL_TYPE)) +
  geom_line(linewidth = 0.05, show.legend = FALSE) +
  geom_area(alpha = 0.25, show.legend = FALSE) +
  scale_x_date(
    expand      = expansion(0), 
    date_breaks = "4 years",
    labels      = scales::label_date(format = "%Y")
    ) +
  scale_y_continuous(
    labels = scales::label_currency(), 
    breaks = scales::pretty_breaks(n = 10),
    limits = c(0, 2.6)
    ) +
  scale_colour_manual(values = c("steelblue", "violetred", "magenta3")) +
  scale_fill_manual(values = c("steelblue4", "violetred4", "magenta4")) +
  labs(title = "Average Gas Prices in Toronto", subtitle = "A Tale of Rising Prices") +
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
  facet_wrap(~FUEL_TYPE, nrow = 1)


# crude oil plots ---------------------------------------------------------
g <- 
  crude_oil_imports_exports |> 
  ggplot(aes(x = REF_DATE, y = VALUE))

g + 
  geom_col(aes(fill = SUPPLY_AND_DISPOSITION), width = 15) +
  geom_point(alpha = 4, col = BLUE, cex = 2) +
  scale_fill_manual(
    values = c(RED, BROWN_DARKER),
    aesthetics = "fill") +
  labs(
    x = "Year",
    y = "",
    fill = "Suppy and Disposition",
    title = "Imports and Exports of Crude Oil",
    subtitle = "'16 to '23",
    caption = "Source: https://statcan.gc.ca/"
    ) +
  theme(
    axis.title.y = element_text(angle = 360, vjust = 0),
    plot.title.position = "panel",
    plot.caption.position = "plot",
    legend.position = "bottom",
    legend.box.background = element_rect(colour = GREY),
    panel.background = element_rect(fill = "#fef8e6"),
    panel.grid = element_blank()
    )
