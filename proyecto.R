# setwd("data")
# Sys.setlocale('LC_ALL','en_GB.UTF-8')
Sys.setlocale(locale="C")
library("stringr")
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

# create feature year from the title
year <- gsub("\\D", "", df.movie$title)
year <- str_sub(year, start = -4)
df.movie$year <- year

# delete the (year) from tittle (optional)
## df.movie$title <- str_sub(df.movie$title, start = 0 , end = -7)

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

# Management of the genres
## Action
df.movie$action[grepl("(Action)", df.movie$generos)] =  as.character(1)

## Adventure
df.movie$adventure[grepl("(Adventure)", df.movie$generos)] =  as.character(1)

## Animation
df.movie$animation[grepl("(Animation)", df.movie$generos)] =  as.character(1)

## Children
df.movie$children[grepl("(Children's)", df.movie$generos)] =  as.character(1)

## Comedy
df.movie$comedy[grepl("(Comedy)", df.movie$generos)] =  as.character(1)

## Crime
df.movie$crime[grepl("(Crime)", df.movie$generos)] =  as.character(1)

## Documentary
df.movie$documentary[grepl("(Documentary)", df.movie$generos)] =  as.character(1)

## Drama
df.movie$drama[grepl("(Drama)", df.movie$generos)] =  as.character(1)

## Fantasy
df.movie$fantasy[grepl("(Fantasy)", df.movie$generos)] =  as.character(1)

## Film-noir
df.movie$film_noir[grepl("(Film-Noir)", df.movie$generos)] =  as.character(1)

## Horror
df.movie$horror[grepl("(Horror)", df.movie$generos)] =  as.character(1)

## Musical
df.movie$musical[grepl("(Musical)", df.movie$generos)] =  as.character(1)

## Mystery
df.movie$mystery[grepl("(Mystery)", df.movie$generos)] =  as.character(1)

## Romance
df.movie$romance[grepl("(Romance)", df.movie$generos)] =  as.character(1)

## Sci-fi
df.movie$sci_fi[grepl("(Sci-Fi)", df.movie$generos)] =  as.character(1)

## Thriller
df.movie$thriller[grepl("(Thriller)", df.movie$generos)] =  as.character(1)

## War
df.movie$war[grepl("(War)", df.movie$generos)] =  as.character(1)

## Western
df.movie$western[grepl("(Western)", df.movie$generos)] =  as.character(1)


## Deleting last column
train.new <- train[-4]

# head(train.new[train.new$movie == 3952, ])

## Creating a new DF
df.train <- data.frame(matrix(ncol = nrow(df.movie), nrow = nrow(df.user)))

## Setting columns as movies id
colnames(df.train) <- df.movie$id


## fill dataframe with ratings between users and movies in train.new
for (i in 1:nrow(train.new)){
  df.row <- train.new[i,]$user #rows as a sequence of rows
  df.colu <- as.character(train.new[i,]$movie) # convert movies ids into char
  df.train[df.row, df.colu] <- train.new[i,]$rating # assign rating to a tuple (user_id, movie_id)
}

# Now we have a big dataframe sparse matriz-like, simillar to the one we need to make collaborative filtering












# take a random sample of size 50 from a dataset train 
# sample without replacement
train.sample <- train.new[sample(1:nrow(train.new), 200, replace=FALSE),]
# plot(train.sample)
# scale(train[-4])

# testing k-means with 5 centroids
k.means <- kmeans(train.sample, centers = 5)
plot(train.sample$user, train.sample$movie, col= k.means$cluster)
# Setting the points
points(k.means$centers[, c("user", "movie")],
       col=1:5,
       pch = 19,
       cex = 2)

## Selecting a recommendation method











