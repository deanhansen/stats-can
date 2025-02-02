library('tidyverse')
library('hrbrthemes')
library('ggthemes')
library('scales')

food_prices <- read_csv(file = "food_prices/food_prices_data.csv")

food_prices_canada_all_products <-
  food_prices |> 
  filter(
    GEO == "Canada", 
    PRODUCT_TYPE == "All-items"
    ) |> 
  group_by(YEAR) |> 
  summarise(
    AVG_INDEX = mean(VALUE),
    SD_INDEX = sd(VALUE)
  )

food_prices_all_products <-
  food_prices |> 
  filter(PRODUCT_TYPE == "All-items") |> 
  group_by(GEO, YEAR) |> 
  summarise(
    AVG_INDEX = mean(VALUE),
    SD_INDEX = sd(VALUE)
  )

food_prices_canada_all_products |> 
  ggplot(aes(YEAR, AVG_INDEX)) +
  geom_line()
# geom_errorbar(aes(ymin=AVG_INDEX-SD_INDEX, ymax=AVG_INDEX+SD_INDEX), width=1, position=position_dodge(0.5))

food_prices_all_products |> 
  filter(YEAR > 2001) |> 
  ggplot(aes(YEAR, AVG_INDEX, group = GEO, col = GEO)) +
  geom_line() +
  geom_point(size = 0.25)
