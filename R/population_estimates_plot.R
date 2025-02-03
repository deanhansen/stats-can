library('tidyverse')
library('scales')
library('ggthemes')

## ...
population_estimates <- readr::read_csv(file = "data-raw/population_estimates_data.csv")

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
    YEAR == population_filters$YEAR,
    GENDER    %in% population_filters$GENDER,
    AGE_GROUP %in% population_filters$AGE_GROUP_LEVELS
    ) |> 
  dplyr::mutate(AGE_GROUP = factor(AGE_GROUP, levels = population_filters$AGE_GROUP_LEVELS)) |> 
  dplyr::select("GENDER", "AGE_GROUP", "POPULATION_SIZE")

## ...
geom_pyramid <- function(.data){
  
  ## ...
  population_range <- range(.data$POPULATION_SIZE)
  
  ## ...
  age_range_seq <- pretty(population_range, n = 10)
  
  .data |>
  ggplot2::ggplot(
    ggplot2::aes(x = POPULATION_SIZE, y = AGE_GROUP, fill = GENDER)
    ) +
    ggplot2::geom_col() +
    ggplot2::scale_x_continuous(
      breaks  = age_range_seq,
      labels = scales::label_comma(abs(age_range_seq))
      ) +
    ggplot2::scale_fill_brewer(palette = "Dark2", guide = ggplot2::guide_legend(title = "")) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.title.x    = ggplot2::element_blank(),
      axis.title.y    = ggplot2::element_blank(),
      legend.position = "top"
      )
  
}

## ...
population_estimates |> 
  dplyr::filter(GEO == "Canada", AGE_GROUP %in% AGE_GROUP_LEVELS, GENDER %in% c("Men", "Women"), YEAR == 2024) |> 
  dplyr::mutate(AGE_GROUP = factor(AGE_GROUP, levels = AGE_GROUP_LEVELS)) |> 
  ggplot2::ggplot(
    ggplot2::aes(x = POPULATION_SIZE, y = AGE_GROUP, fill = GENDER)
    ) + 
  ggplot2::geom_col() +
  ggplot2::scale_x_continuous(labels = scales::label_comma()) +
  ggplot2::labs(fill = "Gender") +
  ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank()
    )


population_estimates |> 
  dplyr::filter(GEO == "Canada", AGE_GROUP %in% AGE_GROUP_LEVELS, GENDER %in% c("Men", "Women"), YEAR == 2024) |> 
  dplyr::mutate(AGE_GROUP = factor(AGE_GROUP, levels = AGE_GROUP_LEVELS)) |> 
  geom_pyramid()

