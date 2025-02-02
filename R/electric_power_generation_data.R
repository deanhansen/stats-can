source("statscan_utils/data_loading.R")

electric_power_generation_raw <- statcan_download_data_tidy("25-10-0015-01", "eng")

electric_power_generation <-
  electric_power_generation_raw |> 
  dplyr::rename(
    CLASS_OF_ELECTRICITY_PRODUCER = `Class of electricity producer`,
    TYPE_OF_ELECTRICITY_GENERATION = `Type of electricity generation`
  ) |> 
  filter(!is.na(VALUE)) |> 
  filter(CLASS_OF_ELECTRICITY_PRODUCER != "Total all classes of electricity producer") |> 
  filter(!TYPE_OF_ELECTRICITY_GENERATION %in% c("Total all types of electricity generation", "Total electricity production from combustible fuels", "Total electricity production from biomass", "Total electricity production from non-renewable combustible fuels")) |> 
  mutate(VALUE = ifelse(VALUE < 0, 0, VALUE))
  
electric_power_generation |> 
  group_by(REF_DATE, GEO, TYPE_OF_ELECTRICITY_GENERATION) |>
  mutate(
    PROP = (VALUE / sum(VALUE)) * 100
  ) |> 
  select(REF_DATE, GEO, TYPE_OF_ELECTRICITY_GENERATION, PROP) |> 
  filter(GEO == "Canada") |> 
  ggplot(aes(REF_DATE,PROP, fill=TYPE_OF_ELECTRICITY_GENERATION)) +
  geom_bar(stat = "identity", position = "fill")

View(electric_power_generation_raw)
