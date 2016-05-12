# Sys.setlocale('LC_ALL','en_GB.UTF-8')
Sys.setlocale(locale="C")
# install.packages("recommenderlab")
# install.packages("shiny")
library("stringr")
library("reshape2")
library("recommenderlab")
library(shiny)
sample_sub <- read.csv("data/sample_submission.csv")
train <- read.csv("data/training_ratings_for_kaggle_comp.csv")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")


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

#create training & testing
training <- train[0,]
testing <- train[0,]
for(j in unique(train$user)){
  aux <- train[train$user == j, ]
  sampl <-  sample(nrow(aux), floor(nrow(aux) * 0.70))
  aux.training <- aux[sampl, ]
  aux.testing  <- aux[-sampl, ]
  training <- rbind(training, aux.training )
  testing <- rbind(testing,aux.testing)
}
dim(training)
dim(testing)

length(unique(training$user))
length(unique(testing$user))


# esta es la matriz dispersa que usaremos 
df.train  <- dcast(training, user ~ movie)
df.train <- sapply(data.frame(df.train), as.numeric)

# Convirtiendo en una matriz especial de la biblioteca
train.RatingMatrix <- as(as.matrix(df.train), "realRatingMatrix")

as(train.RatingMatrix, "matrix")
as(train.RatingMatrix, "list")

# Normalizar la matrix
r_m <- normalize(train.RatingMatrix)
as(r_m, "list")


image(train.RatingMatrix, main = "Raw Ratings")       
image(r_m, main = "Normalized Ratings")

# Can also turn the matrix into a 0-1 binary matrix
r_b <- binarize(train.RatingMatrix, minRating=1)
as(r_b, "list")

# Arguments are n and minRating. Items with a rating below minRating will not be part of the top-N list.
# n N (number of recommendations) of the top-N lists generated (only if type="topNList")
# to normalize and method params o the list, check the slack section "fonts"
rec=Recommender(train.RatingMatrix[1:nrow(train.RatingMatrix)],method="UBCF", param=list(normalize = "Z-score",method="Jaccard",nn=5, minRating=1))
print(rec)
names(getModel(rec))
getModel(rec)$nn

recom <- predict(rec, train.RatingMatrix[1:nrow(train.RatingMatrix)], type="ratings")
recom



####################################


## get some information
dimnames(train.RatingMatrix)
rowCounts(train.RatingMatrix)
colCounts(train.RatingMatrix)
rowMeans(train.RatingMatrix)

## histogram of ratings
hist(getRatings(train.RatingMatrix), breaks="FD")

## inspect a subset
image(train.RatingMatrix[1:5,1:5])
#######################################