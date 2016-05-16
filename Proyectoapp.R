Sys.setlocale(locale="C")
library("stringr")
library("reshape2")
library("recommenderlab")
library("shiny")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")
training <- read.csv("data/training.csv")
testing <- read.csv("data/testing.csv")
rating <- read.csv("data/ratings_for_kaggle_comp.csv")


# Creating a DF with user's Info
usr2 <- unlist(strsplit(usr,"::"))
id <- usr2[seq(from = 1, to = length(usr2), by =5 )]
df.user <- as.data.frame(id)
df.user$sexo <- usr2[seq(from = 2, to = length(usr2), by =5 )]
df.user$age <- usr2[seq(from = 3, to = length(usr2), by =5 )]
df.user$ocupacion <- usr2[seq(from = 4, to = length(usr2), by =5 )]
df.user$zip.code <- usr2[seq(from = 5, to = length(usr2), by =5 )]

#no se usan más
rm(usr)
rm(usr2)


# MovieID::Title::Genres
mov <- unlist(strsplit(movies,"::"))
id <- mov[seq(from = 1, to = length(mov), by =3 )]
df.movie <- as.data.frame(id)
df.movie$title <- mov[seq(from = 2, to = length(mov), by =3 )]

# no se usa más
rm(movies)
rm(mov)

# no sirve para nada
testing$X <- NULL
training$X <- NULL


# nombre de las películas
f <- df.movie$title[df.movie$id  %in% training$movie]

# carga matriz de recomendaciones ya calculada en formato realratingmatrix
load("data/recom.RData")

# dataframe a con nombre de las peliculas
a <- as(recom,"matrix")
a <- as.data.frame(a)
colnames(a) <- f

# df de salida esperada en kaggle que se puede comparar con el testing 
salida <- read.csv("data/salida.csv")


# carga dataframe c que contiene 10 recomendaciones por usuario
load("data/recomendacion10.RData")

# df.train sin nombre de película
df.train  <- acast(training, user ~ movie)


runApp(list(
  ui = pageWithSidebar(
    
    
    
    # Application title
    headerPanel("Recomendador de Peliculas"),
    
    # Sidebar with controls to select a dataset and specify the number
    # of observations to view
    sidebarPanel(
      h3("Visualizar Dataset"),
      selectInput("dataset", "Seleccione un dataset a explorar:", 
                  choices = c("Movies", "Users","Entrenamiento","Predicciones","Comparaciones")),
      selectInput("user", "Seleccione un usuario a evaluar:", 
                  choices = c(unique(training$user)))
    ),
    
    # Show a summary of the dataset and an HTML table with the requested
    # number of observations
    mainPanel(
      #verbatimTextOutput("head"),
      tabsetPanel(
        tabPanel('Analisis exploratorio de los datasets',
                 tableOutput("mytable1")),
        tabPanel('Recomendaciones a usuario',
                 tableOutput("mytable2"), 
                 tableOutput("mytable3"),
                 tableOutput("mytable4")
                 )
      )
      #tableOutput("view"),
      #tableOutput("df.user$input")
    )
    
    
    
    
    ),
  server = function(input, output) {
    datasetInput <- reactive({
      switch(input$dataset,
             "Movies" = df.movie,
             "Users" = df.user,
             "Entrenamiento" = df.train,
             "Predicciones" = as.data.frame(a),
             "Comparaciones" = salida)
    })
    
    
    # Generate a summary of the dataset

    # Show the first "n" observations
    output$mytable1 <- renderTable({
      head(datasetInput(), n = 10)
    })
    
    output$mytable2 <- renderTable({
      df.user[input$user,]
    },
    caption = "Informacion del usuario")

    
    output$mytable3 <- renderTable({
      head(rating[rating$user == input$user,-4], 10)
      
    },
    caption = "10 Valoraciones de peliculas del usuario seleccionado"
    )    
    
    
    output$mytable4 <- renderTable({
      c[input$user,]
      
    },
    caption = "10 Recomendaciones al usuario seleccionado"
    ) 
    
    
    
    
    }
))
