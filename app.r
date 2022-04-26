# Load R packages
library(shiny)
library(shinythemes)
library(ggplot2)
load(url("https://github.com/bandcar/Unemployment-Rate-Pre-and-Post-Covid/find/main"))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Unemployment Rates Pre and Post Covid"),
  
  # Sidebar layout
  sidebarLayout(
    #Inputs: Select which inputs from the data we want to display
    sidebarPanel(
      #Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Unemployment Rate"), 
                  selected = "Unemployment Rate"),
      #Select X-axix variables
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Year"), 
                  selected = "Year")
    ),
    
    #Output: Type of plot
    mainPanel(
      plotOutput(outputId = "FreqTab") #Any name can go where "FreqTab" is, but be sure to keep it consistent with name in output$FreqTab in the server section
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$FreqTab <- renderPlot({
    # draw the histogram with the specified number of bins
    ggplot(t, aes_string(x=input$x, y=input$y)) + geom_point() #Notice the difference between the ggplots
  })
}

# Run the application 
shinyApp(ui = ui, server = server)