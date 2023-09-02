#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(leaflet)
library(ggplot2)
library(plotly)

LandingsData = Meteorite_Landings <- read_csv("C:/Users/Jeffrey DeRemo/Desktop/csce 567/Meteorite_Landings.csv")
#View(Meteorite_Landings)
LandingsData$color = ifelse(LandingsData$fall == "Found", "green",
                         ifelse(LandingsData$fall == "Fell", "blue",
                                 "yellow"))
#summary(Landings)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Meteorite Landings"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "Fell_found", label = " fell or found",
                  choices = c("fell","found","both" ),
                  selected = "all"),
         numericInput("staryear", "start year", value =  900, min =860, max = 2101),
                              
      
         numericInput("lastyear", "end  year", value =  900, min =860 , max = 2101),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 25)
                  
                                
                    
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Locations",leafletOutput("map")) ,
          tabPanel("Histogram of years",plotlyOutput("some")))
      )
  ) #close side bar layouft
)# close fluid page
      
      
      
      # Define server logic required to draw a histogram
      server <- function(input, output) {
        LandingsDatashow = reactive(
          switch(
            input$Fell_found, "found" =LandingsData[LandingsData$fall == "Found"& LandingsData$year>=input$staryear,],
            "fell" = LandingsData[LandingsData$fall == "Fell"& LandingsData$year>=input$staryear &LandingsData$year<=input$lastyear,],
            "both" = LandingsData[LandingsData$fall == "both"& LandingsData$year>=input$staryear,],
            ))
        
        output$map = renderLeaflet({
          Landings = leaflet()
          Landings = addTiles(Landings)
          Landings = addCircles( Landings, data = LandingsDatashow(), lat = ~reclat,lng = ~reclong,color =~color
                                )})
        
        output$some <- renderPlotly({
          ggplotly(ggplot(LandingsDatashow(),aes(year)) + geom_histogram(bins = input$bins)) 
                    
          # generate bins based on input$bins from ui.R
          #x    <- faithful[, 2]
          # bins <- seq(min(x), max(x), length.out = input$bins + 1)
          
          # draw the histogram with the specified number of bins
          #  hist(x, breaks = bins, col = 'darkgray', border = 'white',
          #   xlab = 'Waiting time to next eruption (in mins)',
          #  main = 'Histogram of waiting times')
        })
      }
      
      # Run the application 
      shinyApp(ui = ui, server = server)
      