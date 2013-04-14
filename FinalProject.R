### STAT 503
### Final Project

## Libraries
library(rjson)
library(plyr)
library(maps)
library(tm)
library(e1071)
# library(RJSONIO)

processData <- function(json) {
    lines <- readLines(json)
    json.lines <- lapply(1:length(lines), function(x) { fromJSON(lines[x])})
}

## Read in json training files
business.json <- processData("yelp_training_set_business.json")
checkin.json <- processData("yelp_training_set_checkin.json")
reviews.json <- processData("yelp_training_set_review.json")
user.json <- processData("yelp_training_set_user.json")


## Reviews Data
## Convert to DF
reviews.data <- data.frame(matrix(unlist(reviews.json), nrow = length(reviews.json), byrow = TRUE))
names(reviews.data) <- c("funny", "useful", "cool", names(reviews.json[[1]])[-1])
## Fix some of the data types
reviews.data$useful <- as.numeric(as.character(reviews.data$useful))
reviews.data$cool <- as.numeric(as.character(reviews.data$cool))
reviews.data$funny <- as.numeric(as.character(reviews.data$funny))


## Business Data
## We need to turn "Categories" into a comma separated string
for (i in 1:length(business.json)) {
    business.json[[i]]$categories <- paste(business.json[[i]]$categories, collapse = ",")
}
business.data.tmp <- data.frame(matrix(unlist(business.json), nrow = length(business.json), byrow = TRUE))
names(business.data.tmp) <- names(business.json[[1]])[-8]


## Checkin Data
##
for (i in 1:length(checkin.json)) {
    checkins <- sum(unlist(checkin.json[[i]][-(c(length(checkin.json[[i]]), length(checkin.json[[i]]) - 1))]))
    business_id <- checkin.json[[i]]$business_id
    
    checkin.json[[i]] <- list(business_id = business_id, checkins = checkins)
}
checkin.data <- data.frame(matrix(unlist(checkin.json), nrow = length(checkin.json), byrow = TRUE))
names(checkin.data) <- names(checkin.json[[1]])


## User Data
user.data <- data.frame(matrix(unlist(user.json), nrow = length(user.json), byrow = TRUE))
names(user.data) <- c("funny", "useful", "cool", names(user.json[[1]])[-1])
user.data$useful <- as.numeric(as.character(user.data$useful))
user.data$cool <- as.numeric(as.character(user.data$cool))
user.data$funny <- as.numeric(as.character(user.data$funny))
user.data$average_stars <- as.numeric(as.character(user.data$average_stars))
user.data$review_count <- as.numeric(as.character(user.data$review_count))

####
## Merge Data
## Three sets, businesses and users, with reviews linking businesses to users
####
business.data <- merge(business.data.tmp, checkin.data, by = "business_id")
business.data$checkins <- as.numeric(as.character(business.data$checkins))
business.data$review_count <- as.numeric(as.character(business.data$review_count))
business.data$longitude <- as.numeric(as.character(business.data$longitude))
business.data$stars <- as.numeric(as.character(business.data$stars))
business.data$latitude <- as.numeric(as.character(business.data$latitude))

qplot(review_count, average_stars, data = user.data)

## Examples
## Get all reviews for a particular business_id
# subset(reviews.data, business_id == "9yKzy9PApeiPPOUJEtnvkg")
#
## Get all reviews for business with most checkins
# subset(reviews.data, business_id == business.data[which.max(business.data$checkins), "business_id"])
## Get the name/info of this business
# subset(business.data, business_id == "hW0Ne_HTHEAgGF1rAdmR-g")
## It's a stupid airport....

reviews.data$user_id = as.character(reviews.data$user_id)
reviews.data$review_id = as.character(reviews.data$review_id)
reviews.data$business_id = as.character(reviews.data$business_id)
reviews.data$text = as.character(reviews.data$text)

m = list(Content = "text", Heading = "review_id", Author = "user_id", Description = "business_id")
t <- readTabular(mapping = m)
corpus <- Corpus(DataframeSource(reviews.data), readerControl = list(reader = t))
#tdm = TermDocumentMatrix(corpus)


c2 = tm_map(corpus, stripWhitespace)
c2 = tm_map(c2, removePunctuation)
c2 = tm_map(c2, tolower)
c2 = tm_map(c2, removeWords, stopwords("english"))
c2 = tm_map(c2, removeNumbers)
c2 = tm_map(c2, stemDocument) #needs weka
inspect(tdm2[1:5,100:105])

tdm2 = TermDocumentMatrix(c2)
tdm3 = TermDocumentMatrix(c2, control = list(bounds=list(global = c(10,Inf), local = c(1, Inf))))
inspect(tdm3[120:125,100:105])

dtm = as.DocumentTermMatrix(tdm3)

dimtdm$dimnames$Terms[tdm[,1]$i]