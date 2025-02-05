library('tidyverse')

bank_of_canada_interest_rates <- readr::read_csv(file = "data-raw/bank_of_canada_interest_rates_data.csv")

# Target Rate for the Bank of Canada by Year -----------------------------------------------------------

bank_of_canada_interest_rates |> 
  dplyr::filter(FINANCIAL_MARKET_STATISTIC_DESC == "Target Rate") |> 
  dplyr::group_by(YEAR) |> 
  dplyr::reframe(
    INTEREST_RATE_MEAN = mean(INTEREST_RATE),
    INTEREST_RATE_MIN  = min(INTEREST_RATE),
    INTEREST_RATE_MAX  = max(INTEREST_RATE)
  ) |> 
  dplyr::ungroup() |> 
  ggplot2::ggplot(
    ggplot2::aes(x = YEAR, y = INTEREST_RATE_MEAN, colour = factor(YEAR))
    ) +
  ggplot2::geom_point(
    ggplot2::aes(size = INTEREST_RATE_MEAN / 100)
  ) +
  ggplot2::geom_linerange(
    ggplot2::aes(ymin = INTEREST_RATE_MIN, ymax = INTEREST_RATE_MAX)
  ) +
  ggplot2::scale_x_continuous(n.breaks = 12) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  ggplot2::theme(
    axis.title.x    = ggplot2::element_blank(),
    axis.title.y    = ggplot2::element_blank(),
    legend.position = "none"
    )

