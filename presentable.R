Sys.setlocale(locale="C")
library("stringr")
library("reshape2")
library("recommenderlab")
library("shiny")
movies <- readLines("data/movies.dat")
usr <- readLines("data/users.dat")
training <- read.csv("data/training.csv")
testing <- read.csv("data/testing.csv")




## Histogramas

hist(training$rating)

usuarios <- as.data.frame(unique(training$user))
colnames(usuarios) <- "user"
usuarios$peliculas <- rep(0,length(usuarios$user))
for(i in 1:length(usuarios$user)){
  usuario <- usuarios$user[i]
  usuarios$peliculas[i] <- length(training$user[training$user == usuario])
}

# cambiando el parámetro by se cambia los breaks..
hist(x = usuarios$peliculas,
     breaks = seq(from = 0 , to = 1000 , by = 20),
     main = "Histograma de # de peliculas votadas",
     xlab = "# de movies"
)






# Creating a DF with user's Info
usr2 <- unlist(strsplit(usr,"::"))
id <- usr2[seq(from = 1, to = length(usr2), by =5 )]
df.user <- as.data.frame(id)
df.user$sexo <- usr2[seq(from = 2, to = length(usr2), by =5 )]
df.user$age <- usr2[seq(from = 3, to = length(usr2), by =5 )]
df.user$ocupacion <- usr2[seq(from = 4, to = length(usr2), by =5 )]
df.user$zip.code <- usr2[seq(from = 5, to = length(usr2), by =5 )]

#no se usan mas
rm(usr)
rm(usr2)


# MovieID::Title::Genres
mov <- unlist(strsplit(movies,"::"))
id <- mov[seq(from = 1, to = length(mov), by =3 )]
df.movie <- as.data.frame(id)
df.movie$title <- mov[seq(from = 2, to = length(mov), by =3 )]

# no se usa mas
rm(movies)
rm(mov)

# no sirve para nada
testing$X <- NULL
training$X <- NULL


# nombre de las pelmculas
f <- df.movie$title[df.movie$id  %in% training$movie]



# carga matriz de recomendaciones ya calculada en formato realratingmatrix
load("data/recom.RData")

# dataframe a con nombre de las peliculas
a <- as(recom,"matrix")
a <- as.data.frame(a)
colnames(a) <- f



# df de salida esperada en kaggle que se puede comparar con el testing 
salida <- read.csv("data/salida.csv")

# df.train sin nombre de película
df.train  <- acast(training, user ~ movie)

# carga dataframe c que contiene 10 recomendaciones por usuario
load("data/recomendacion10.RData")






##nuevo

salida$X <- NULL
t3 <- as.factor(training$movie)
testing <- testing[testing$movie %in% levels(t3), ]
df.salida  <- acast(salida[,1:3], user ~ movie)
df.test  <- acast(testing, user ~ movie)


salida.RatingMatrix <- as(df.salida, "realRatingMatrix")
test.RatingMatrix <- as(df.test, "realRatingMatrix")


error <- calcPredictionAccuracy(salida.RatingMatrix, test.RatingMatrix)

# Root Mean Squared Error (RMSE)
# (1/n) * sqrt(sum(salida$real - salida$rating) ^2)
RMSE <- error[1]
print(RMSE)

# mean square error
# (1/n) * sum(salida$real - salida$rating) ^2 
MSE <- error[2]
print(MSE)


table(round(salida$rating),salida$real )







