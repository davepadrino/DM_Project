# Sys.setlocale('LC_ALL','en_GB.UTF-8')
Sys.setlocale(locale="C")
library("stringr")
library("reshape2")
sample_sub <- read.csv("data/sample_submission.csv")
train <- read.csv("data/training_ratings_for_kaggle_comp.csv")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")


install = function(pkg){
  # Si ya est?? instalado, no lo instala.
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "http:/cran.rstudio.com")
    if (!require(pkg, character.only = TRUE)) stop(paste("load failure:", pkg))
  }
}
install("recommenderlab")


# Creating a DF with user's Info
usr2 <- unlist(strsplit(usr,"::"))
id <- usr2[seq(from = 1, to = length(usr2), by =5 )]
df.user <- as.data.frame(id)
df.user$sexo <- usr2[seq(from = 2, to = length(usr2), by =5 )]
df.user$age <- usr2[seq(from = 3, to = length(usr2), by =5 )]
df.user$ocupacion <- usr2[seq(from = 4, to = length(usr2), by =5 )]
df.user$zip.code <- usr2[seq(from = 5, to = length(usr2), by =5 )]

# MovieID::Title::Genres
mov <- unlist(strsplit(movies,"::"))
id <- mov[seq(from = 1, to = length(mov), by =3 )]
df.movie <- as.data.frame(id)
df.movie$title <- mov[seq(from = 2, to = length(mov), by =3 )]


# delete useless id 
train$id <- NULL


# esta es la matriz dispersa que usaremos 
df.train  <- dcast(train, user ~ movie)
df.train <- sapply(data.frame(df.train), as.numeric)

# Convirtiendo en una matriz especial de la biblioteca
train.RatingMatrix <- as(as.matrix(df.train), "realRatingMatrix")

# Normalizar la matrix
norm <- train.RatingMatrix

 # dudas
rec=Recommender(train.RatingMatrix[1:nrow(train.RatingMatrix)],method="UBCF", param=list(normalize = "Z-score",method="Cosine",nn=5, minRating=1))
rec=Recommender(train.RatingMatrix[1:nrow(train.RatingMatrix)],method="UBCF", param=list(normalize = "Z-score",method="Jaccard",nn=5, minRating=1))
rec=Recommender(r[1:nrow(r)],method="IBCF", param=list(normalize = "Z-score",method="Jaccard",minRating=1))
rec=Recommender(train.RatingMatrix[1:nrow(train.RatingMatrix)],method="POPULAR")
