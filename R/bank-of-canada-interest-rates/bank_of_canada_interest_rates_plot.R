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
bank_of_canada_interest_rates <- read_csv(file = "data-raw/bank_of_canada_interest_rates_data.csv")


# Target Rate for the Bank of Canada by Year -----------------------------------------------------------

bank_of_canada_interest_rates |> 
  filter(financial_market_statistic_desc == "Target Rate") |> 
  group_by(year) |> 
  reframe(
    interest_rate_mean = mean(interest_rate),
    interest_rate_min  = min(interest_rate),
    interest_rate_max  = max(interest_rate)
    ) |> 
  ungroup() |> 
  ggplot(
    aes(x = year, y = interest_rate_mean, colour = factor(year))
    ) +
  geom_point(
    aes(size = interest_rate_mean / 100)
    ) +
  geom_linerange(
    aes(ymin = interest_rate_min, ymax = interest_rate_max)
    ) +
  scale_x_continuous(n.breaks = 12) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  theme(
    axis.title.x    = element_blank(),
    axis.title.y    = element_blank(),
    legend.position = "none"
    )

