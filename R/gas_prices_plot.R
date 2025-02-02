library('tidyverse')
library('scales')

# data --------------------------------------------------------------------
gas <- read_csv("gas_prices/gas.csv")
crude_oil <- read_csv("gas_prices/crude_oil.csv")
crude_oil_imports_exports <- 
  crude_oil |> 
  filter(SUPPLY_AND_DISPOSITION %in% c("Imports", "Exports"))

# colors ------------------------------------------------------------------

BROWN <- "#AD8C97"
BROWN_DARKER <- "#7d3a46"
GREEN <- "#2FC1D3"
BLUE <- "#076FA1"
BLUE_DARKER <- "#1f2e7a"
GREY <- "#C7C9CB"
GREY_DARKER <- "#5C5B5D"
RED <- "#e3120b"
BLACK <- "#0d0d0d"
WHITE <- "#fef8e6"
GLOBE <- "#852e57"


# gas plots -------------------------------------------------------------------
ggplot(gas,
       aes(
         x = REF_DATE, 
         y = DOLLARS_PER_LITRE,
         color = FUEL_TYPE,
         fill = FUEL_TYPE)
       ) +
  geom_violin() +
  labs(
    title = "Cost of Gas Across Canada",
    subtitle = "A Tale of Prices",
    x = "",
    y = ""
    ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 14, hjust = 0, margin = margin(b = 10)),
    plot.caption = element_text(size = 8, hjust = 0, margin = margin(t = 10)),
    legend.title = element_blank(),
    legend.text = element_text(size = 10, margin = margin(r = 10)),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.title.x = element_text(size = 12, face = "bold", vjust = 2, angle = 45, hjust = 1),
    axis.title.y = element_text(size = 12, face = "bold", vjust = 0, angle = 45)
  ) +
  facet_wrap(
    ~FUEL_TYPE
    )


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
