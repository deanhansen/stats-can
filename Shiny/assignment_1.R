library('statcanR')

## Fetch data from Statistics Canada website via `statcanR` package
carsales <- statcanR::statcan_download_data("20-10-0024-02", "eng")
carsales <- carsales[carsales$GEO != "Canada", ]
carsales <- carsales[carsales$`Fuel type` != "All fuel types", ]
carsales <- carsales[carsales$`Vehicle type` != "Total, vehicle type", ]

## Add column for year
carsales$REF_YEAR <- lubridate::year(carsales$REF_DATE)

## Save the dataset for shiny app
saveRDS(carsales, "carsales_20240910.RData")
