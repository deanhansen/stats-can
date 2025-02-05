library('tidyverse')
library('scales')

marital_status <- read_csv(file = "marital_status/marital_status_data.csv")

ggplot(marital_status %>% filter(INDICATOR == "median" & GENDER != "Total" & GEO != "Canada"),
       aes(x = REF_DATE, y = VALUE, color = PRIOR_MARITAL_STATUS, group = PRIOR_MARITAL_STATUS)) +
  
  geom_point(size = 2, shape = 3) +
  geom_smooth() +
  
  # Scales
  scale_y_continuous(breaks = c(25, 30, 35, 40, 45, 50, 55, 60, 65, 70)) +
  
  # Labels
  labs(title = "Median Age of Marriage",
       subtitle = "A Tale of Two Sexes",
       x = "",
       y = "") +
  
  # Themes
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = .5),
    plot.subtitle = element_text(size = 14, hjust = .5, margin = margin(b = 10)),
    plot.caption = element_text(size = 8, hjust = 0, margin = margin(t = 10)),
    legend.title = element_blank(),
    legend.text = element_text(size = 10, margin = margin(r = 10)),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.title.x = element_text(size = 12, face = "bold", vjust = 2, angle = 45, hjust = 1),
    axis.title.y = element_text(size = 12, face = "bold", vjust = 0, angle = 45)
  ) +
  facet_wrap(~GENDER)