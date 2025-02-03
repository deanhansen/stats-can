library('dplyr')
library('ggplot2')
library('scales')
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

range(population_estimates_filtered$POPULATION_SIZE)

# Population Pyramid by Year and Sex --------------------------------------

population_pyramid_anim <-
  ggplot2::ggplot(
  data    = population_estimates_filtered, 
  mapping = ggplot2::aes(x = POPULATION_SIZE, y = AGE_GROUP, fill = GENDER)
  ) +
  ggplot2::geom_col(width = 0.65) +
  ggplot2::scale_x_continuous(
    labels = function(x) scales::label_comma()(abs(x)),
    breaks = scales::breaks_pretty(n = 9),
    limits = c(-3e6, 3e6),
    expand = ggplot2::expansion(mult = 0.1)
    ) +
  ggplot2::scale_fill_brewer(palette = "Dark2", type = "qual", direction = -1) +
  ggplot2::labs(title = "Canadian Population Pyramid: {frame_time}", fill = "Sex") +
  ggplot2::theme(
    axis.title.x    = ggplot2::element_blank(),
    axis.title.y    = ggplot2::element_blank(),
    legend.position = "bottom",
    legend.text     = ggplot2::element_text(size = 11)
    ) +
  ## Animation!
  gganimate::transition_time(YEAR) +
  gganimate::ease_aes(default = "linear") +
  gganimate::view_follow(fixed_x = TRUE, fixed_y = TRUE)

## ...
gganimate::animate(population_pyramid_anim, duration = 5, fps = 60, height = 5, width = 7, units = "in", res = 300)

## ...
gganimate::anim_save("man/GIF/Canada Population Pyramid.gif")

