library(statcanR)
library(tidyverse)
library(plyr)


# airplane traffic by destination -----------------------------------------

airplanes_raw <- statcan_download_data("23-10-0287-01", lang = "eng")

airplanes <- airplanes_raw %>%
  mutate(DESC = `Domestic and international itinerant aircraft movements`, YEAR = lubridate::year(REF_DATE)) %>%
  select(REF_DATE, DESC, VALUE, YEAR)

write_csv(airplanes, "airplanes.csv")

# aircraft weight ------------------------------------------------------------------

weight_raw <- statcan_download_data("23-10-0301-01", lang = "eng")

weight_raw <- weight_raw %>%
  mutate(AIRPORTS = Airports, WEIGHT_IN_KG = `Maximum take-off weight`, YEAR = lubridate::year(REF_DATE)) %>%
  select(REF_DATE, AIRPORTS, WEIGHT_IN_KG, VALUE, YEAR)

GEO <- c()
for (i in seq_along(weight_raw$AIRPORTS)) {
  GEO[i] <- str_split(weight_raw$AIRPORTS[i], ",")[[1]][2]
}
GEO <- str_trim(GEO,side="left")

weight <- dplyr::bind_cols(weight_raw, GEO=GEO) |> 
  filter(!GEO %in% c("NAV CANADA towers and flight service stations","non-NAV CANADA airports") )

weight |> 
  filter(GEO != "all airports") |> 
  #filter(GEO %in% c("Ontario", "British Columbia", "Quebec", "Alberta")) |> 
  filter(GEO == "Ontario") |> 
  group_by(REF_DATE, WEIGHT_IN_KG) |> 
  dplyr::summarise(N=sum(VALUE, na.rm = TRUE)) |>
  ggplot(aes(x=REF_DATE,y=N,colour=WEIGHT_IN_KG)) +
  geom_point() +
  labs(x="", y="") +
  facet_wrap(~WEIGHT_IN_KG)

write_csv(weight, "airplane_weights.csv")

