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


# Data --------------------------------------------------------------------

crude_oil <- read_csv(file = "data-raw/crude_oil_data.csv")


# Crude Oil by Export Destination ---------------------------------------------------------

crude_oil |> 
  filter(production_type %in% c("Export to the United States", "Export to other countries"), !is.na(total_barrels_of_crude_oil), total_barrels_of_crude_oil > 0) |> 
  ggplot(
    aes(x = ref_date, y = total_barrels_of_crude_oil, colour = production_type)
    ) +
  geom_point(alpha = 0.5) +
  scale_x_date(date_breaks = "1 year", labels = label_date(format = "%y'"), minor_breaks = NULL) +
  scale_y_log10(n.breaks = 10, minor_breaks = NULL, lim = c(1, 10^8.25), label = label_log()) +
  facet_wrap(~production_type, nrow = 2)
  