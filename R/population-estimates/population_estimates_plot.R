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
library('ggpattern')
library('gganimate')

## ...
population_estimates <- read_csv(file = "data-raw/population_estimates_data.csv")

## ...
population_filters <- 
  list(
    geo              = "Canada", 
    year             = 2024, 
    gender           = c("Men+", "Women+"), 
    age_group_levels = c(paste(seq(0, 95, by = 5), "to", seq(4, 99, by = 5), "years"), "100 years and over")
    )

## ...
population_estimates_filtered <-
  population_estimates |> 
  filter(geo == population_filters$geo, gender %in% population_filters$gender, age_group %in% population_filters$age_group_levels) |> 
  drop_na(population) |> 
  mutate(
    age_group  = factor(age_group, levels = population_filters$age_group_levels),
    population = if_else(gender == "Men+", (-1) * population, population)
    ) |> 
  select("year", "gender", "age_group", "population")


# Population Pyramid by Year and Sex --------------------------------------

## ...
population_pyramid_anim <-
  population_estimates_filtered |> 
  ggplot(
    aes(x = population, y = age_group, fill = gender)
    ) +
  geom_col_pattern(
    width           = 0.35,
    pattern         = "stripe", 
    pattern_alpha   = 0.5, 
    pattern_density = 0.1,
    pattern_colour  = "white"
    ) +
  scale_x_continuous(
    labels = function(x) label_comma()(abs(x)),
    breaks = breaks_pretty(n = 9),
    limits = c(-3e6, 3e6),
    expand = expansion(mult = 0.15)
    ) +
  scale_fill_manual(values = c("#007bff", "#ff69b4")) +
  labs(title = "Canadian Population Pyramid: {frame_time}", fill = "Sex") +
  theme(
    text                   = element_text(family = "Comic Sans MS"),
    plot.title             = element_text(face = "bold"), 
    axis.title.x           = element_blank(),
    axis.title.y           = element_blank(),
    axis.text.x            = element_text(size = 9, vjust = 0.5, margin = margin(t = 5, r = 0, b = 10, l = 0)),
    axis.text.y            = element_text(size = 9, hjust = 0.5, margin = margin(t = 0, r = 5, b = 0, l = 10)),
    axis.ticks             = element_line(linewidth = 0.5), 
    panel.grid.major.x     = element_blank(),
    panel.grid.major.y     = element_blank(),
    legend.text            = element_text(size = 8),
    legend.title           = element_blank(),
    legend.position        = "inside",
    legend.position.inside = c(0.89, 0.8),
    legend.background      = element_rect(fill = "transparent"),
    legend.key.size        = unit(12, units = "pt"),
    legend.key.spacing.y   = unit(3, units = "pt"),
    legend.margin          = margin(t = 5, r = 5, b = 5, l = 5)
    ) +
  ## Animation!
  transition_time(year) +
  ease_aes(default = "linear") +
  view_follow(fixed_x = TRUE, fixed_y = TRUE)

## ...
animate(population_pyramid_anim, duration = 5, fps = 60, height = 5, width = 7, units = "in", res = 300)

## ...
anim_save("man/gif/Canada Population Pyramid.gif")

