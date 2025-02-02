library(statcanR) # fetching data from Statistics Canada API
library(readr) # reading data
library(dplyr) # grouping, pipe operator
library(ggplot2) # creating plots
library(plotly) # make plots interactive
library(scales) # scale aesthetics
library(RColorBrewer) # enlarge default colour palettes
library(lubridate) # date and time
library(stringr) # formatting strings
library(tidyr) 
library(tibble) # tibble object

#Fetch data from Statistics Canada website via statcanR package
carsales <- statcanR::statcan_download_data("2010000201", "eng") %>% as_tibble()

head(carsales)

carsales <- carsales %>% 
  filter(STATUS == "")

carsales <- carsales %>% 
  rename(VEHICLE_TYPE = "Vehicle type", SALES = "Sales")

carsales <- carsales %>% 
  rename(REF_YEAR = "REF_DATE") %>% 
  mutate(REF_YEAR = lubridate::year(REF_YEAR))

carsales <- carsales %>% 
  filter(GEO != "Canada") %>% # exclude rows that contain Canada wide data
  filter(VEHICLE_TYPE != "Total, new motor vehicles") %>% # exclude rows that contain total for all vehicle types
  select(REF_YEAR, GEO, VEHICLE_TYPE, SALES, VALUE)

carsales <- carsales %>% 
  tidyr::pivot_wider(names_from = "SALES", values_from = "VALUE") %>%
  rename(TOTAL_CARS = "Units", TOTAL_DOLLARS = "Dollars")

#Plot for q3
ggplot(q3_data, aes(MONTH_OF_DEATH , TOTAL_DEATHS)) +
  geom_point() +
  xlab("Deaths By Month, 2020") +
  ylab("") +
  labs(color = "", size = "") +
  scale_x_discrete(guide = guide_axis(angle = 75)) +
  facet_wrap(~ GEO)


#Here is some code from class that might help
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE),
    count = n()
  ) %>% 
  filter(count > 20, dest != "HNL")

ggplot(data = delays, 
       mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE) + 
  xlab("average distance") +
  ylab("average delay (minutes)")


#Deploy shiny app to shiny.io
rsconnect::deployApp("/Users/deanhansen/Grad School/Courses/stats_780/stats-780a/assignment_1")
