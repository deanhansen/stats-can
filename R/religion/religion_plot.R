library('tidyverse')

## ...
religion <- readr::read_csv(file = "data-raw/religion_data.csv")

## ...
religion |> 
  dplyr::filter(GEO == "Canada", RELIGION %in% "Total - Religion") |> 
  ggplot(aes(x = AGE, y = TOTAL_ADHERANTS, fill = GENDER, group = GENDER)) +
  geom_col(width = 0.6, position = position_dodge(width = 0.7), show.legend = FALSE) +
  geom_text(aes(label = label_comma()(TOTAL_ADHERANTS)), size = 13 / .pt, hjust = 1.1, fontface = "bold", angle = 90, colour = "white", position = position_dodge(width = 0.7)) +
  geom_hline(aes(yintercept = 0), colour = "black") +
  scale_y_continuous(labels = label_comma()) +
  scale_fill_manual(values = c('#5c2237', '#643f38')) +
  labs(x = NULL, y = NULL) +
  theme(
    axis.text.x = element_text(angle = 0),
    panel.grid.major.y = element_line(colour = "grey40", linewidth = 0.20, linetype = 2),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.background = element_rect(fill = "grey80")
    )
