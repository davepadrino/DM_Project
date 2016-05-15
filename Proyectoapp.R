library("stringr")
library("reshape2")
library("recommenderlab")
library("shiny")
train <- read.csv("data/ratings_for_kaggle_comp.csv")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")
training <- read.csv("data/training.csv")
testing <- read.csv("data/testing.csv")
usr2 <- unlist(strsplit(usr,"::"))
id <- usr2[seq(from = 1, to = length(usr2), by =5 )]
df.user <- as.data.frame(id)
df.user$sexo <- usr2[seq(from = 2, to = length(usr2), by =5 )]
df.user$age <- usr2[seq(from = 3, to = length(usr2), by =5 )]
df.user$ocupacion <- usr2[seq(from = 4, to = length(usr2), by =5 )]
df.user$zip.code <- usr2[seq(from = 5, to = length(usr2), by =5 )]

mov <- unlist(strsplit(movies,"::"))
id <- mov[seq(from = 1, to = length(mov), by =3 )]
df.movie <- as.data.frame(id)
df.movie$title <- mov[seq(from = 2, to = length(mov), by =3 )]


runApp(list(
  ui = pageWithSidebar(
    
    
    
    # Application title
    headerPanel("Recomendador de Peliculas"),
    
    # Sidebar with controls to select a dataset and specify the number
    # of observations to view
    sidebarPanel(
      h3("Visualizar Dataset"),
      selectInput("dataset", "Choose a dataset:", 
                  choices = c("movies", "users","training","prediction","comparison")),
      selectInput("dataset", "Choose a user:", 
                  choices = unique(training$user))
      #numericInput("obs", "Number of observations to view:", 10)
      
    ),
    
    # Show a summary of the dataset and an HTML table with the requested
    # number of observations
    mainPanel(
      #verbatimTextOutput("head"),
      
      tableOutput("view")
    )
    
    
    
    
    ),
  server = function(input, output) {
    datasetInput <- reactive({
      switch(input$dataset,
             "movies" = df.movie,
             "users" = df.user,
             "training" = df.train,
             "prediction" = as.data.frame(a),
             "comparison" = salida)
    })
    
    # Generate a summary of the dataset
    output$head <- renderPrint({
      dataset <- datasetInput()
      head(dataset)
    })
    
    # Show the first "n" observations
    output$view <- renderTable({
      head(datasetInput(), n = 10)
    })
    }
))
