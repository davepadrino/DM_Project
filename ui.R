library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Recomendador de Peliculas"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    h3("Visualizar Dataset"),
    selectInput("dataset", "Choose a dataset:", 
                choices = c("movies", "usr")),
    numericInput("obs", "Number of observations to view:", 10)
    
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    verbatimTextOutput("head"),
    
    tableOutput("view")
  )
))