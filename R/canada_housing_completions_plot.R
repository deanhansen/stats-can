library(tidyverse)
library(ggthemes)
theme_set(theme_minimal())

df <- read_csv("canada_housing_completions_data.csv")

ggplot(df, aes(x=REF_DATE, y=INDEX_VALUE)) +
  geom_line(alpha=0.8) +
  geom_abline(intercept = mean(df$INDEX_VALUE), slope=0, col="red") +
  labs(title = "Real Canadian Residential Housing Price Index",
       subtitle = "From 1970-01-01 to 2022-10-01",
       x = "",
       y = "",
       caption = "Bank for International Settlements, 
Real Residential Property Prices for Canada [QCAR628BIS], 
Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/QCAR628BIS, September 21, 2023.") +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = -0.1),
    plot.subtitle = element_text(size = 10, hjust = -0.05, margin = margin(b = 10)),
    plot.caption = element_text(size = 8, hjust = 0, margin = margin(t = 10)),
    legend.title = element_blank(),
    legend.text = element_text(size = 10, margin = margin(r = 10)),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.title.x = element_text(size = 12, face = "bold", vjust = 2, angle = 45, hjust = 1),
    axis.title.y = element_text(size = 12, face = "bold", vjust = 0, angle = 45)
  )
