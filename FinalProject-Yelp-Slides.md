---
title       : Predicting Usefulness of Yelp Reviews
subtitle    :
author      : Jim Curro, Eric Hare, Alex Shum
job         : Apr. 29, 2013
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---




## Introduction




---

## Data: Businesses

```r
head(business.data, n = 1)
```

```
##              business_id                               full_address open
## 1 --5jkZ3-nUPZxUvtcbr8Uw 1336 N Scottsdale Rd\nScottsdale, AZ 85257 TRUE
##          categories       city review_count                       name
## 1 Greek,Restaurants Scottsdale           11 George's Gyros Greek Grill
##   longitude state stars latitude     type checkins stars.f
## 1    -111.9    AZ   4.5    33.46 business       84     4.5
```


---

## Data: Users

```r
head(user.data, n = 1)
```

```
##   funny useful cool                user_id name average_stars review_count
## 1     0      7    0 CR2y7yEm4X035ZMzrTtN9Q  Jim             5            6
##   type
## 1 user
```


---

## Data: Reviews

```r
reviews.sub[18, ]
```

```
##       funny useful cool                user_id              review_id
## 86819     0      0    0 Ts367xA-JqA4s13qY0awbg _RDx1GXkVG8Xxk_VYqZrBg
##       stars       date                                           text
## 86819     2 2012-09-27 Totally flavorless.  I'd rather have in-n-out.
##         type            business_id
## 86819 review Cr2JNnewX53TYd9w6qw6Jw
```


---

## Data Analysis
...

---

## Useful vs Funny/Cool
![plot of chunk usefulvfunny](figure/usefulvfunny.png) 


---

## City Data
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:24 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> Top ten cities by the number of checkins in that city </CAPTION>
<TR> <TH> city </TH> <TH> reviews </TH> <TH> checkins </TH> <TH> percentage </TH>  </TR>
  <TR> <TD> Phoenix </TD> <TD align="right"> 91453.00 </TD> <TD align="right"> 310640.00 </TD> <TD align="right"> 0.29 </TD> </TR>
  <TR> <TD> Scottsdale </TD> <TD align="right"> 49042.00 </TD> <TD align="right"> 202946.00 </TD> <TD align="right"> 0.24 </TD> </TR>
  <TR> <TD> Tempe </TD> <TD align="right"> 27021.00 </TD> <TD align="right"> 93446.00 </TD> <TD align="right"> 0.29 </TD> </TR>
  <TR> <TD> Chandler </TD> <TD align="right"> 13944.00 </TD> <TD align="right"> 48067.00 </TD> <TD align="right"> 0.29 </TD> </TR>
  <TR> <TD> Mesa </TD> <TD align="right"> 9786.00 </TD> <TD align="right"> 34328.00 </TD> <TD align="right"> 0.29 </TD> </TR>
  <TR> <TD> Glendale </TD> <TD align="right"> 7017.00 </TD> <TD align="right"> 26306.00 </TD> <TD align="right"> 0.27 </TD> </TR>
  <TR> <TD> Gilbert </TD> <TD align="right"> 5803.00 </TD> <TD align="right"> 22723.00 </TD> <TD align="right"> 0.26 </TD> </TR>
  <TR> <TD> Peoria </TD> <TD align="right"> 2599.00 </TD> <TD align="right"> 11361.00 </TD> <TD align="right"> 0.23 </TD> </TR>
  <TR> <TD> Surprise </TD> <TD align="right"> 1274.00 </TD> <TD align="right"> 5109.00 </TD> <TD align="right"> 0.25 </TD> </TR>
  <TR> <TD> Avondale </TD> <TD align="right"> 1243.00 </TD> <TD align="right"> 5053.00 </TD> <TD align="right"> 0.25 </TD> </TR>
   <A NAME=tab:CityData></A>
</TABLE>


---

## Checkins
![plot of chunk checkins](figure/checkins.png) 


---

## Useful Users
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:25 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> Top ten users in the Yelp data by total number of useful votes per review (Minimum 100 reviews). </CAPTION>
<TR> <TH> funny </TH> <TH> useful </TH> <TH> cool </TH> <TH> name </TH> <TH> average_stars </TH> <TH> review_count </TH> <TH> good </TH>  </TR>
  <TR> <TD align="right"> 20707.00 </TD> <TD align="right"> 23080.00 </TD> <TD align="right"> 19815.00 </TD> <TD> Hazel </TD> <TD align="right"> 4.06 </TD> <TD align="right"> 814.00 </TD> <TD align="right"> 28.35 </TD> </TR>
  <TR> <TD align="right"> 13074.00 </TD> <TD align="right"> 16707.00 </TD> <TD align="right"> 14381.00 </TD> <TD> Katie </TD> <TD align="right"> 4.19 </TD> <TD align="right"> 770.00 </TD> <TD align="right"> 21.70 </TD> </TR>
  <TR> <TD align="right"> 11070.00 </TD> <TD align="right"> 13146.00 </TD> <TD align="right"> 11836.00 </TD> <TD> Chris </TD> <TD align="right"> 3.77 </TD> <TD align="right"> 624.00 </TD> <TD align="right"> 21.07 </TD> </TR>
  <TR> <TD align="right"> 9488.00 </TD> <TD align="right"> 10134.00 </TD> <TD align="right"> 10563.00 </TD> <TD> Robin </TD> <TD align="right"> 3.79 </TD> <TD align="right"> 530.00 </TD> <TD align="right"> 19.12 </TD> </TR>
  <TR> <TD align="right"> 7481.00 </TD> <TD align="right"> 10396.00 </TD> <TD align="right"> 9832.00 </TD> <TD> Raider </TD> <TD align="right"> 4.24 </TD> <TD align="right"> 546.00 </TD> <TD align="right"> 19.04 </TD> </TR>
  <TR> <TD align="right"> 1993.00 </TD> <TD align="right"> 2586.00 </TD> <TD align="right"> 2600.00 </TD> <TD> Clyde </TD> <TD align="right"> 3.90 </TD> <TD align="right"> 143.00 </TD> <TD align="right"> 18.08 </TD> </TR>
  <TR> <TD align="right"> 5391.00 </TD> <TD align="right"> 6063.00 </TD> <TD align="right"> 5539.00 </TD> <TD> Marlon </TD> <TD align="right"> 3.92 </TD> <TD align="right"> 346.00 </TD> <TD align="right"> 17.52 </TD> </TR>
  <TR> <TD align="right"> 2544.00 </TD> <TD align="right"> 2631.00 </TD> <TD align="right"> 2638.00 </TD> <TD> William </TD> <TD align="right"> 3.97 </TD> <TD align="right"> 153.00 </TD> <TD align="right"> 17.20 </TD> </TR>
  <TR> <TD align="right"> 10451.00 </TD> <TD align="right"> 8401.00 </TD> <TD align="right"> 8429.00 </TD> <TD> Thomas </TD> <TD align="right"> 3.67 </TD> <TD align="right"> 517.00 </TD> <TD align="right"> 16.25 </TD> </TR>
  <TR> <TD align="right"> 9003.00 </TD> <TD align="right"> 12233.00 </TD> <TD align="right"> 11270.00 </TD> <TD> Jennifer </TD> <TD align="right"> 4.08 </TD> <TD align="right"> 764.00 </TD> <TD align="right"> 16.01 </TD> </TR>
   <A NAME=tab:UsefulTable></A>
</TABLE>


---

## Usefulness by Star Rating
![plot of chunk usefulbystars](figure/usefulbystars.png) 


## Preprocessing and Classification

---

## R Memory and Computation Time Issues

---

## Classification

---





## Characteristics of Useful Reviews
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:41 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> Summary statistics for all reviews by whether the review was voted as useful or not.  The variables include the number of characters, percentage of letters capitalized, percentage of letters that are punctuation characters, paragraphs per length of review, the number of useful votes for the particular user writing the review over the total number of reviews for that user, and the average star rating of the business being reviewed. </CAPTION>
<TR> <TH>  </TH> <TH> useful_bin </TH> <TH> numChar </TH> <TH> numCap </TH> <TH> numPunc </TH> <TH> numPar </TH> <TH> useful.per </TH> <TH> average_stars </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> FALSE </TD> <TD align="right"> 536.6503 </TD> <TD align="right"> 0.0303 </TD> <TD align="right"> 0.0403 </TD> <TD align="right"> 0.0031 </TD> <TD align="right"> 0.8648 </TD> <TD align="right"> 3.5536 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> TRUE </TD> <TD align="right"> 830.0923 </TD> <TD align="right"> 0.0297 </TD> <TD align="right"> 0.0428 </TD> <TD align="right"> 0.0048 </TD> <TD align="right"> 2.0467 </TD> <TD align="right"> 3.5290 </TD> </TR>
   <A NAME=tab:SummaryTable></A>
</TABLE>


---




## Random Forest Importance
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:44 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> A list of the variables and their importance as determined by the randomForest algorithm.  We ultimately selected six of these variables, numChar, numPar, numCap, and numPunc, useful.per, and average stars for use in our SVM. </CAPTION>
<TR> <TH>  </TH> <TH> FALSE </TH> <TH> TRUE </TH> <TH> MeanDecreaseAccuracy </TH> <TH> MeanDecreaseGini </TH>  </TR>
  <TR> <TD align="right"> stars </TD> <TD align="right"> 0.0057 </TD> <TD align="right"> 0.0035 </TD> <TD align="right"> 0.0044 </TD> <TD align="right"> 349.3500 </TD> </TR>
  <TR> <TD align="right"> numChar </TD> <TD align="right"> 0.0154 </TD> <TD align="right"> 0.0159 </TD> <TD align="right"> 0.0157 </TD> <TD align="right"> 1451.2652 </TD> </TR>
  <TR> <TD align="right"> numCap </TD> <TD align="right"> -0.0007 </TD> <TD align="right"> 0.0024 </TD> <TD align="right"> 0.0011 </TD> <TD align="right"> 1221.3895 </TD> </TR>
  <TR> <TD align="right"> numPunc </TD> <TD align="right"> 0.0009 </TD> <TD align="right"> 0.0064 </TD> <TD align="right"> 0.0041 </TD> <TD align="right"> 1246.2444 </TD> </TR>
  <TR> <TD align="right"> numPar </TD> <TD align="right"> 0.0127 </TD> <TD align="right"> 0.0068 </TD> <TD align="right"> 0.0093 </TD> <TD align="right"> 817.7550 </TD> </TR>
  <TR> <TD align="right"> useful.per </TD> <TD align="right"> 0.0782 </TD> <TD align="right"> 0.0934 </TD> <TD align="right"> 0.0871 </TD> <TD align="right"> 2274.3753 </TD> </TR>
  <TR> <TD align="right"> average_stars </TD> <TD align="right"> -0.0146 </TD> <TD align="right"> 0.0342 </TD> <TD align="right"> 0.0138 </TD> <TD align="right"> 1111.7662 </TD> </TR>
   <A NAME=tab:RandomForest></A>
</TABLE>


---

## Our Final SVM

---

## Truth Table
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:45 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> Truth Table for the results of our model </CAPTION>
<TR> <TH>  </TH> <TH> FALSE </TH> <TH> TRUE </TH>  </TR>
  <TR> <TD align="right"> FALSE </TD> <TD align="right"> 527 </TD> <TD align="right"> 340 </TD> </TR>
  <TR> <TD align="right"> TRUE </TD> <TD align="right"> 264 </TD> <TD align="right"> 869 </TD> </TR>
   <A NAME=tab:SVM></A>
</TABLE>


---

## Results
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Fri Apr 26 18:56:45 2013 -->
<TABLE border=1>
<CAPTION ALIGN="bottom"> Individual and overall class error rates for our model </CAPTION>
<TR> <TH>  </TH> <TH> Type </TH> <TH> ErrorRates </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Useful Error </TD> <TD align="right"> 0.2330 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Not Useful Error </TD> <TD align="right"> 0.3922 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Overall Error </TD> <TD align="right"> 0.3126 </TD> </TR>
   <A NAME=tab:ClassErrorTable></A>
</TABLE>


---
