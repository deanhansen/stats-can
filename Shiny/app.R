library('shiny')
library('ggplot2')
library('plotly')
library('viridis')

## Load car sales dataset
carsales <- readRDS("carsales_20240910.RData")

## UI components for the user to filter
vehicle_type <- carsales$`Vehicle type` |> unique() |> c("") |> sort()
fuel_type    <- carsales$`Fuel type` |> unique() |> c("") |> sort()
breaks       <- carsales$REF_YEAR |> unique() |> sort()

## Define UI for application that draws a histogram
ui <- fluidPage(
  
  ## Application title
  titlePanel("New Motor Car Sales Across Canada"),
  
  ## Sidebar with a slider input for number of bins 
  sidebarLayout(
    position = "left",
    sidebarPanel(
      selectInput(
        inputId  = "vehicle_type", 
        label    = "Choose type of vehicle", 
        choices  = vehicle_type,
        selected = "category",
        width    = "100%"
        ),
      selectInput(
        inputId  = "fuel_type", 
        label    = "Choose fuel type", 
        choices  = fuel_type,
        selected = "category",
        width    = "100%"
        )
    ),
    
    ## Show a plot of the generated distribution
    mainPanel(
      plotlyOutput(outputId = "distPlot", width = "100%"),
      br(),
      hr(),
      p("Overview of new vehicles purchased across Canada.")
    )
  )
)

## Define server logic required to draw a plot
server <- function(input, output) {
  
  output$distPlot <- renderPlotly({
    
    ## Show nothing if `fuel_type` is blank
    if (input$fuel_type == "") {
      
    }
    
    ## Show plot if `fuel_type` is populated
    else {
      
      ggplotly(
        ggplot(
          subset(carsales, `Vehicle type` == input$vehicle_type & `Fuel type` == input$fuel_type),
          aes(
            x    = REF_YEAR,
            y    = VALUE,
            fill = GEO,
            text = GEO
            )
          ) +
          geom_bar(position = "fill", stat = "identity") +
          scale_x_continuous(breaks = breaks) +
          labs(x = "year", y = "% of new cars sold", fill = "") +
          scale_fill_viridis(discrete = TRUE)
        )
      
    }
    
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)