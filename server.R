library(shiny)
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

testing$X <- NULL
training$X <- NULL
# esta es la matriz dispersa que usaremos 
df.train  <- acast(training, user ~ movie)
f <- df.movie$title[df.movie$id  %in% training$movie]


load("data/recom.RData")
a <- as(recom,"matrix")
a <- as.data.frame(a)
#colnames(a) <- f
a <- sapply(a,round)


rownames(df.train) <- unique(training$user)
rownames(a) <- unique(training$user)

salida <- testing
salida$rating <- 0
for(i in 1:length(salida$movie)){
  fila <- as.character(salida$user[i])
  columna  <-  paste("X",salida$movie[i],sep="")
  nulo <- a[fila,columna]
  if(!is.null(nulo)){
    salida$rating[i] <- a[fila,columna]
  }
}

salida$real <- testing$rating
# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application


#mpgData <- mtcars
#mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))



# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "movies" = df.movie,
           "users" = df.user,
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
})