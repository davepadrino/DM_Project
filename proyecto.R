#setwd("./data")
sample_sub <- read.csv("sample_submission.csv")
train <- read.csv("training_ratings_for_kaggle_comp.csv")
mov <- readLines("movies.dat")
usr <- readLines("users.dat")


usr2 <- unlist(strsplit(usr,"::"))
id <- usr2[seq(from = 1, to = length(usr2), by =5 )]
df.user <- as.data.frame(id)
df.user$sexo <- usr2[seq(from = 2, to = length(usr2), by =5 )]
df.user$age <- usr2[seq(from = 3, to = length(usr2), by =5 )]
df.user$ocupacion <- usr2[seq(from = 4, to = length(usr2), by =5 )]
df.user$zip.code <- usr2[seq(from = 5, to = length(usr2), by =5 )]


#MovieID::Title::Genres
mov <- unlist(strsplit(mov,"::"))
id <- mov[seq(from = 1, to = length(mov), by =3 )]
df.movie <- as.data.frame(id)
df.movie$title <- mov[seq(from = 2, to = length(mov), by =3 )]
df.movie$generos <-  mov[seq(from = 3, to = length(mov), by =3 )]
df.movie$action <- rep(0,length(df.movie$id))
df.movie$adventure <- rep(0,length(df.movie$id))
df.movie$animation <- rep(0,length(df.movie$id))
df.movie$children <- rep(0,length(df.movie$id))
df.movie$comedy <- rep(0,length(df.movie$id))
df.movie$crime <- rep(0,length(df.movie$id))
df.movie$documentary <- rep(0,length(df.movie$id))
df.movie$drama <- rep(0,length(df.movie$id))
df.movie$fantasy <- rep(0,length(df.movie$id))
df.movie$film-noir <- rep(0,length(df.movie$id))
df.movie$horror <- rep(0,length(df.movie$id))
df.movie$musical <- rep(0,length(df.movie$id))
df.movie$mystery <- rep(0,length(df.movie$id))
df.movie$romance <- rep(0,length(df.movie$id))
df.movie$sci-fi <- rep(0,length(df.movie$id))
df.movie$thriller <- rep(0,length(df.movie$id))
df.movie$war <- rep(0,length(df.movie$id))
df.movie$western <- rep(0,length(df.movie$id))



generos <-  mov[seq(from = 3, to = length(mov), by =3 )]
generos <- unlist(strsplit(generos,"|",fixed = TRUE))
generos <- as.factor(generos)
levels(generos)

# supongo q habrá que hacer un ciclo con expresiones regulares
# para ir llenando el df , la columna genero hay q eliminarla pero
# se las deje para que la vieran xD







