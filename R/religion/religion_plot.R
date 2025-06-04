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
theme_set(theme_classic())

## ...
religion <- read_csv(file = "data-raw/religion_data.csv")

## ...
religion |> 
  filter(geo == "Canada", religion_name %in% "total_religion_1") |> 
  ggplot(
    aes(x = age, y = total_followers, fill = gender, group = gender)
    ) +
  geom_col(width = 0.6, position = position_dodge(width = 0.7)) +
  geom_text(aes(label = label_comma()(total_followers)), size = 13 / .pt, hjust = 1.1, fontface = "bold", angle = 90, colour = "white", position = position_dodge(width = 0.7)) +
  geom_hline(aes(yintercept = 0), colour = "black") +
  scale_y_continuous(n.breaks = 6, labels = label_comma()) +
  labs(x = NULL, y = NULL) +
  theme(
    panel.grid.major.y = element_line(colour = "black", linewidth = 0.1, linetype = 2),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank()
    )
