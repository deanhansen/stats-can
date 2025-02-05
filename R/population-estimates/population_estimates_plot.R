library('dplyr')
library('ggplot2')
library('scales')
library('ggpattern')
library('ggthemes')
library('gganimate')

## ...
population_estimates <- 
  readr::read_csv(
    file      = "data-raw/population_estimates_data.csv", 
    col_types = list(YEAR = "integer")
    )

## ...
population_filters <- 
  list(
    GEO              = "Canada", 
    YEAR             = 2024, 
    GENDER           = c("Men", "Women"), 
    AGE_GROUP_LEVELS = c(paste(seq(0, 95, by = 5), "to", seq(4, 99, by = 5), "years"), "100 years and over")
    )

## ...
population_estimates_filtered <-
  population_estimates |> 
  dplyr::filter(
    GEO  == population_filters$GEO,
    # YEAR == population_filters$YEAR,
    GENDER    %in% population_filters$GENDER,
    AGE_GROUP %in% population_filters$AGE_GROUP_LEVELS
    ) |> 
  tidyr::drop_na(POPULATION_SIZE) |> 
  dplyr::mutate(
    AGE_GROUP       = factor(AGE_GROUP, levels = population_filters$AGE_GROUP_LEVELS),
    POPULATION_SIZE = dplyr::if_else(GENDER == "Men", (-1) * POPULATION_SIZE, POPULATION_SIZE)
    ) |> 
  dplyr::select("YEAR", "GENDER", "AGE_GROUP", "POPULATION_SIZE")


# Population Pyramid by Year and Sex --------------------------------------

## ...
population_pyramid_anim <-
  population_estimates_filtered |> 
  ggplot2::ggplot(
    mapping = ggplot2::aes(x = POPULATION_SIZE, y = AGE_GROUP, fill = GENDER)
    ) +
  ggpattern::geom_col_pattern(
    width           = 0.35,
    pattern         = "stripe", 
    pattern_alpha   = 0.5, 
    pattern_density = 0.1,
    pattern_colour  = "white"
    ) +
  ggplot2::scale_x_continuous(
    labels = function(x) scales::label_comma()(abs(x)),
    breaks = scales::breaks_pretty(n = 9),
    limits = c(-3e6, 3e6),
    expand = ggplot2::expansion(mult = 0.15)
    ) +
  ggplot2::scale_fill_manual(
    values = c("#007bff", "#ff69b4")
    ) +
  ggplot2::labs(title = "Canadian Population Pyramid: {frame_time}", fill = "Sex") +
  ggplot2::theme(
    text                   = ggplot2::element_text(family = "Comic Sans MS"),
    plot.title             = ggplot2::element_text(face = "bold"), 
    axis.title.x           = ggplot2::element_blank(),
    axis.title.y           = ggplot2::element_blank(),
    axis.text.x            = ggplot2::element_text(size = 9, vjust = 0.5, margin = ggplot2::margin(t = 5, r = 0, b = 10, l = 0)),
    axis.text.y            = ggplot2::element_text(size = 9, hjust = 0.5, margin = ggplot2::margin(t = 0, r = 5, b = 0, l = 10)),
    axis.ticks             = ggplot2::element_line(linewidth = 0.5), 
    panel.grid.major.x     = ggplot2::element_blank(),
    panel.grid.major.y     = ggplot2::element_blank(),
    legend.text            = ggplot2::element_text(size = 8),
    legend.title           = ggplot2::element_blank(),
    legend.position        = "inside",
    legend.position.inside = c(0.89, 0.8),
    legend.background      = ggplot2::element_rect(fill = "transparent"),
    legend.key.size        = ggplot2::unit(12, units = "pt"),
    legend.key.spacing.y   = ggplot2::unit(3, units = "pt"),
    legend.margin          = ggplot2::margin(t = 5, r = 5, b = 5, l = 5)
    ) +
  ## Animation!
  gganimate::transition_time(YEAR) +
  gganimate::ease_aes(default = "linear") +
  gganimate::view_follow(fixed_x = TRUE, fixed_y = TRUE)

## ...
gganimate::animate(population_pyramid_anim, duration = 5, fps = 60, height = 5, width = 7, units = "in", res = 300)

## ...
gganimate::anim_save("man/gif/Canada Population Pyramid.gif")

