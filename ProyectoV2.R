
setwd("C:/Users/pedro/Desktop/proydm")


sample_sub <- read.csv("sample_submission.csv")
train <- read.csv("training_ratings_for_kaggle_comp.csv")
mov <- readLines("movies.dat")
usr <- readLines("users.dat")

train$id <- as.character(train$id)






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
df.movie$film_noir <- rep(0,length(df.movie$id))
df.movie$horror <- rep(0,length(df.movie$id))
df.movie$musical <- rep(0,length(df.movie$id))
df.movie$mystery <- rep(0,length(df.movie$id))
df.movie$romance <- rep(0,length(df.movie$id))
df.movie$sci_fi <- rep(0,length(df.movie$id))
df.movie$thriller <- rep(0,length(df.movie$id))
df.movie$war <- rep(0,length(df.movie$id))
df.movie$western <- rep(0,length(df.movie$id))
df.movie$id <- as.character(df.movie$id)



generos <-  mov[seq(from = 3, to = length(mov), by =3 )]
generos <- unlist(strsplit(generos,"|",fixed = TRUE))
generos <- as.factor(generos)
levels(generos)

#Action

df.movie$action <- 0
df.movie$action[grepl("(Action)", df.movie$generos)] =  as.character(1)


#Adventure
df.movie$adventure <- 0
df.movie$adventure[grepl("(Adventure)", df.movie$generos)] =  as.character(1)


#animation
df.movie$animation <- 0
df.movie$animation[grepl("(Animation)", df.movie$generos)] =  as.character(1)


#children
df.movie$children <- 0
df.movie$children[grepl("(Children's)", df.movie$generos)] =  as.character(1)


#comedy
df.movie$comedy <- 0
df.movie$comedy[grepl("(Comedy)", df.movie$generos)] =  as.character(1)


#crime
df.movie$crime <- 0
df.movie$crime[grepl("(Crime)", df.movie$generos)] =  as.character(1)


#documentary
df.movie$documentary <- 0
df.movie$documentary[grepl("(Documentary)", df.movie$generos)] =  as.character(1)



#drama
df.movie$drama <- 0
df.movie$drama[grepl("(Drama)", df.movie$generos)] =  as.character(1)



#fantasy
df.movie$fantasy <- 0
df.movie$fantasy[grepl("(Fantasy)", df.movie$generos)] =  as.character(1)



#film-noir
df.movie$film_noir <- 0
df.movie$film_noir[grepl("(Film-Noir)", df.movie$generos)] =  as.character(1)


#Horror
df.movie$horror <- 0
df.movie$horror[grepl("(Horror)", df.movie$generos)] =  as.character(1)


#musical
df.movie$musical <- 0
df.movie$musical[grepl("(Musical)", df.movie$generos)] =  as.character(1)




#mystery
df.movie$mystery <- 0
df.movie$mystery[grepl("(Mystery)", df.movie$generos)] =  as.character(1)


#romance
df.movie$romance <- 0
df.movie$romance[grepl("(Romance)", df.movie$generos)] =  as.character(1)


#sci-fi
df.movie$sci_fi <- 0
df.movie$sci_fi[grepl("(Sci-Fi)", df.movie$generos)] =  as.character(1)


#thriller
df.movie$thriller <- 0
df.movie$thriller[grepl("(Thriller)", df.movie$generos)] =  as.character(1)



#war
df.movie$war <- 0
df.movie$war[grepl("(War)", df.movie$generos)] =  as.character(1)


#western
df.movie$western <- 0
df.movie$western[grepl("(Western)", df.movie$generos)] =  as.character(1)


