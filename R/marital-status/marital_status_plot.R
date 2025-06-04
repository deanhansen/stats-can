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
marital_status <- read_csv(file = "data-raw/marital_status_data.csv")

## ...
marital_status |> 
  filter(geo == "Canada", legal_marital_status_prior_to_marriage == "Never legally married", gender_composition_of_the_couple == "Total – Gender composition", str_detect(string = indicator, pattern = "Median")) |>  
  ggplot(
    aes(x = year, y = age_in_years, colour = gender)
    ) +
  geom_point(size = 0.5) +
  geom_smooth() +
  scale_x_continuous(n.breaks = 10, minor_breaks = NULL) +
  scale_y_continuous(n.breaks = 5,  minor_breaks = NULL, labels = label_number(suffix = " yrs. old")) +
  labs(title = "Median Age of First Marraige by Gender", caption = "Note: if we had to guess, the trend lines for Men and Women continue\nabove/below the green curve. So, I'd say the median age of marriage\nis somewhere around 31 for Men and 29 for Women.")
