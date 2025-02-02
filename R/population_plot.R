library('tidyverse')
library('hrbrthemes')
library('ggthemes')
library('scales')
library('viridis')

population_2022 <- read_csv(file = "population/population_2022_data.csv")
population_2022$SEX <- fct(population_2022$SEX, levels = c("Both sexes", "Males", "Females"))
AGE_GROUP_SHORT <- paste(seq(0,99), "years")
AGE_GROUP_LONG <- c(paste(seq(0,95,5), "to", seq(4,99,5), "years"), "100 years and over")

population_2022 |> 
  filter(AGE_GROUP %in% AGE_GROUP_LONG, SEX == "Both sexes") |> 
  mutate(AGE_GROUP = fct(AGE_GROUP, levels = AGE_GROUP_LONG)) |> 
  ggplot(aes(x=AGE_GROUP, y=VALUE, fill=GEO)) + 
  geom_col() +
  theme(
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 55, vjust = 1, hjust = 1)
    ) +
  labs(subtitle = "Population of Canada, 2022", x = "", y = "") +
  scale_y_comma(n.breaks = 10, limits = c(0,3000000))

