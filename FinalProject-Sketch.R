
## @knitr concordance, echo=FALSE
opts_chunk$set(concordance=TRUE)


## @knitr LoadLibraries, echo=FALSE, cache=FALSE, message=FALSE
    ## Libraries
    library(rjson)
    library(plyr)
    library(maps)
    library(tm)
    library(ggplot2)
    library(xtable)
    library(e1071)


## @knitr DataProcessing, echo=FALSE, cache=TRUE
    processData <- function(json) {
        lines <- readLines(json)
        json.lines <- lapply(1:length(lines), function(x) { fromJSON(lines[x])})
    }
    
    ## Read in json training files
    business.json <- processData("yelp_training_set_business.json")
    checkin.json <- processData("yelp_training_set_checkin.json")
    reviews.json <- processData("yelp_training_set_review.json")
    user.json <- processData("yelp_training_set_user.json")
    
    ## Read in json test files
    reviews.test.json <- processData("yelp_test_set_review.json")
    
    ## Reviews Data
    ## Convert to DF
    reviews.data <- data.frame(matrix(unlist(reviews.json), nrow = length(reviews.json), byrow = TRUE))
    names(reviews.data) <- c("funny", "useful", "cool", names(reviews.json[[1]])[-1])
    ## Fix some of the data types
    reviews.data$useful <- as.numeric(as.character(reviews.data$useful))
    reviews.data$cool <- as.numeric(as.character(reviews.data$cool))
    reviews.data$funny <- as.numeric(as.character(reviews.data$funny))
 
    ## Reviews Test Data
    ## Convert to DF
    reviews.test.data = data.frame(matrix(unlist(reviews.test.json), nrow = length(reviews.test.json), byrow = TRUE))
    
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
    business.data$stars.f <- factor(business.data$stars)
    business.data$latitude <- as.numeric(as.character(business.data$latitude))
    
    reviews.data$text <- as.character(reviews.data$text)


## @knitr UsefulFunny, echo=FALSE, out.height='5in', out.width='5in', fig.show='hold', fig.align='center'
qplot(cool, useful, data = user.data, colour = I("blue")) + geom_point(aes(x = funny, y = useful), colour = I("red"))


## @knitr CityData, echo=FALSE, results='asis'
business.data$full_address <- as.character(business.data$full_address)

business.data$zip <- substring(business.data$full_address, nchar(business.data$full_address) - 5, nchar(business.data$full_address))

city.data = ddply(business.data,.(city),summarize,
  reviews = sum(review_count),
  checkins = sum(checkins))

city.data <- city.data[with(city.data, order(-checkins)), ]

city.data$percentage <- city.data$reviews/city.data$checkins

print(xtable(city.data[1:10,]), include.rownames = FALSE, table.placement = '!h')


## @knitr CheckinsBoxplot, echo=FALSE, out.height='5in', out.width='5in', fig.show='hold', fig.align='center'
qplot(stars.f, log(checkins), data = business.data, geom = "boxplot", colour = stars.f)


## @knitr UsefulTable, echo=FALSE, results='asis'
use = subset(user.data,review_count>100)
use$good = use$useful / use$review
use = use[with(use,order(-good)),]

print(xtable(use[1:10, c(1:3, 5:7, 9)]), include.rownames = FALSE, table.placement = '!h')


## @knitr TDMStuff, echo=FALSE, cache=TRUE
## Smaller sample of documents
## Remove a lot of terms (which don't show up)
## KMeans of the terms
## http://stat.ethz.ch/R-manual/R-patched/library/utils/html/aspell.html


#mapping function for corpus
m = list(Content = "text", Heading = "review_id", Author = "user_id", Description = "business_id")
t <- readTabular(mapping = m)

#subset dataset
train = sample(1:nrow(reviews.data),20000)

#create and clean corpus
corpus <- Corpus(DataframeSource(reviews.data[train,]), readerControl = list(reader = t))
corpus = tm_map(corpus, stripWhitespace)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, stemDocument) #needs weka

#Term document matrix
tdm = TermDocumentMatrix(corpus, control = list(bounds=list(global = c(10,Inf), local = c(1, Inf))))
dtm = as.DocumentTermMatrix(tdm)

#look through term document matrix
findFreqTerms(dtm, 15000)

#possible response variables
stars = reviews.data$stars
funny = reviews.data$funny
useful = reviews.data[train,]$useful > 0
cool = reviews.data$cool

#convert to normal matrix
matrix.dtm = inspect(dtm)

#classifiers
m = svm(useful ~ matrix.dtm)
