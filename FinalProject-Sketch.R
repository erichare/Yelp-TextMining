
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
    library(randomForest)


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
    business.data$stars.f <- factor(business.data$stars)
    business.data$latitude <- as.numeric(as.character(business.data$latitude))
    
    reviews.data$text <- as.character(reviews.data$text)

    set.seed(20130421)
    data.sample <- sample(1:nrow(reviews.data), 20000)
    reviews.sub <- reviews.data[data.sample, ]


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


## @knitr NotAlexPlots, echo=FALSE, fig.cap='Displays for each user their number of useful reviews by the average stars that each user gives any review. The users are colored by the total number of reviews showing a clear trend in number of reviews and number of useful reviews'
    user.data$frc = '<50'
    user.data$frc[user.data$review_count > 50] = '50-200'
    user.data$frc[user.data$review_count > 200] = '200-500'
    user.data$frc[user.data$review_count > 500] = '500-1000'
    user.data$frc[user.data$review_count > 1000] = '>1000'
    qplot(data=user.data,average_stars,useful,color = frc)


## @knitr SummaryTable, echo=FALSE, results='asis', cache=TRUE
    reviews.sub$numChar <- sapply(reviews.sub$text, nchar)
    reviews.sub$numCap <- sapply(reviews.sub$text, function(x) { length(grep("[A-Z]", strsplit(as.character(x), split = "")[[1]])) / (nchar(x) + 1)})
    reviews.sub$numPunc <- sapply(reviews.sub$text, function(x) { length(grep("[^a-zA-Z ]", strsplit(as.character(x), split = "")[[1]])) / (nchar(x) + 1)})
    reviews.sub$numPar <- sapply(reviews.sub$text, function(x) { length(grep("\n", strsplit(as.character(x), split = "")[[1]])) / (nchar(x) + 1)})


    important.words <- read.csv("m.csv")
    reviews.sub$hasDont <- sapply(reviews.sub$text, function(x) { length(grep(" don'*t ", tolower(as.character(x)))) > 0})
    reviews.sub$hasTime <- sapply(reviews.sub$text, function(x) { length(grep(" time[sd]* ", tolower(as.character(x)))) > 0})
    
    reviews.sub$useful_bin <- reviews.sub$useful > 0
    summary.sub <- ddply(reviews.sub, .(useful_bin), summarise, numChar = mean(numChar), numCap = 100 * mean(numCap), numPunc = 100 * mean(numPunc), numPar = 100 * mean(numPar), hasDont = mean(hasDont), hasTime = mean(hasTime))

    print(xtable(summary.sub), table.placement = '!h')


## @knitr RandomForest, echo=FALSE, results='asis', cache=TRUE
    classError <- function(table) {
        cls1 <- (table[1,2] / (table[1,2] + table[1,1]))
        cls2 <- (table[2,1] / (table[2,2] + table[2,1]))
        cat(paste("Not Useful:", cls1, "\n"))
        cat(paste("Useful:", cls2, "\n"))
        cat(paste("Total:", mean(c(cls1, cls2)), "\n"))
    }

    reviews.train <- reviews.sub[1:18000, ]
    reviews.test <- reviews.sub[18001:20000, -c(1:3, ncol(reviews.sub))]
    reviews.test.truth <- reviews.sub[18001:20000, ncol(reviews.sub)]

    reviews.rf <- randomForest(factor(useful_bin) ~ stars+numChar+numCap+numPunc+numPar+hasDont+hasTime, data = reviews.train, importance = TRUE, ntree = 1000)

    print(xtable(reviews.rf$importance), table.placement = '!h')


## @knitr SVM, echo=FALSE, results='asis'
    reviews.svm <- svm(factor(useful_bin) ~ numChar+numPar+numPunc, data = reviews.train, kernel = "linear")

    predict.svm <- predict(reviews.svm, reviews.test)
    #classError(table(predict.svm, reviews.test.truth))

    print(xtable(table(predict.svm, reviews.test.truth)), table.placement = '!h')


