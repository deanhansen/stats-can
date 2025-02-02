library('tidyverse')

aircraft_traffic <- readr::read_csv(file = "data-raw/aircraft_traffic_data.csv")
aircraft_weight  <- readr::read_csv(file = "data-raw/aircraft_weight_data.csv")


# Plot --------------------------------------------------------------------

aircraft_weight |> 
  dplyr::filter(AIRPORT_LOCATION == "All Airports") |> 
  dplyr::group_by(REF_DATE, AIRCRAFT_WEIGHT_IN_KG) |> 
  dplyr::reframe(TOTAL_AIRCRAFT = sum(NUMBER_OF_AIRCRAFT)) |>
  ggplot2::ggplot(
    ggplot2::aes(x = REF_DATE, y = TOTAL_AIRCRAFT, colour = AIRCRAFT_WEIGHT_IN_KG)
    ) +
  ggplot2::geom_point() +
  ggplot2::scale_y_continuous(labels = scales::label_number()) +
  ggplot2::labs(colour = "Aircraft Weight Category") +
  ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank()
    ) +
  ggplot2::facet_wrap(~AIRCRAFT_WEIGHT_IN_KG, nrow = 5)
