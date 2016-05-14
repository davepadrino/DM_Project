# Sys.setlocale('LC_ALL','en_GB.UTF-8')
Sys.setlocale(locale="C")
# install.packages("recommenderlab")
# install.packages("shiny")
library("stringr")
library("reshape2")
library("recommenderlab")
library("shiny")
train <- read.csv("data/ratings_for_kaggle_comp.csv")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")
training <- read.csv("data/training.csv")
testing <- read.csv("data/testing.csv")


# imprime los usuarios con menos de 5 películas
# for(j in unique(train$user)){
#   num <- length(train$movie[train$user == j])
#   if (num < 5){
#     print(paste("user:",j,"tiene:",num," peliculas"))
#   } 
# }

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





# # delete useless id 
# train$id <- NULL
################################### 
##---create training & testing---##
###################################
# training <- train[0,]
# testing <- train[0,]
# for(j in unique(train$user)){
#   aux <- train[train$user == j, ]
#   sampl <-  sample(nrow(aux), floor(nrow(aux) * 0.70))
#   aux.training <- aux[sampl, ]
#   aux.testing  <- aux[-sampl, ]
#   training <- rbind(training, aux.training )
#   testing <- rbind(testing,aux.testing)
# }
# dim(training)
# dim(testing)
# write.csv(training,file="data/training.csv")
# write.csv(testing,file="data/testing.csv")


testing$X <- NULL
training$X <- NULL
# esta es la matriz dispersa que usaremos 
df.train  <- acast(training, user ~ movie)
f <- df.movie$title[df.movie$id  %in% training$movie]

# Convirtiendo en una matriz especial de la biblioteca
train.RatingMatrix <- as(as.matrix(df.train), "realRatingMatrix")
df.train <- sapply(data.frame(df.train), as.numeric)

# as(train.RatingMatrix, "matrix")
# as(train.RatingMatrix, "list")


# Arguments are n and minRating. Items with a rating below minRating will not be part of the top-N list.
# n N (number of recommendations) of the top-N lists generated (only if type="topNList")
# to normalize and method params o the list, check the slack section "fonts"
rec=Recommender(train.RatingMatrix[1:nrow(train.RatingMatrix)],method="UBCF",
                param=list(normalize = "Z-score",method="Jaccard",nn=5, minRating=1))
print(rec)
names(getModel(rec))
getModel(rec)$nn


load("data/recom.RData")
# recom <- predict(rec, train.RatingMatrix[1:nrow(train.RatingMatrix)], type="ratings")
# save(recom, file="recom.RData")


a <- as(recom,"matrix")

a <- as.data.frame(a)
#colnames(a) <- f


a <- sapply(a,round)


rownames(df.train) <- unique(training$user)
rownames(a) <- unique(training$user)

# ejemplos de como acceder es
# df.train["6040","X3735"]


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


# Ahora falta comparar salida con testing


# ####################################
# 
# 
# ## get some information
# dimnames(train.RatingMatrix)
# rowCounts(train.RatingMatrix)
# colCounts(train.RatingMatrix)
# rowMeans(train.RatingMatrix)
# 
# ## histogram of ratings
# hist(getRatings(train.RatingMatrix), breaks="FD")
# 
# ## inspect a subset
# image(train.RatingMatrix[1:5,1:5])
# #######################################