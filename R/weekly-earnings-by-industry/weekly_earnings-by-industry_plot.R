library('readr')
library('dplyr')
library('tidyr')
library('ggplot2')
library('scales')
library('ggview')
theme_set(theme_bw())

## ...
weekly_earnings_by_industry_data <- read_csv(file = "data-raw/weekly_earnings_by_industry_data.csv")

## ...
weekly_earnings_by_industry_data |> 
  filter(geo == "Canada", type_of_employees == "All employees", overtime == "Including overtime", ) |> 
  ggplot(
    aes(x = year, y = average_weekly_salary_in_dollars, group = naics, colour = naics)
    ) +
  geom_line(show.legend = FALSE) +
  scale_x_continuous(expand = expansion(0.05)) +
  scale_y_continuous(labels = label_comma(), lim = c(0, 2000), expand = expansion(0.1))
