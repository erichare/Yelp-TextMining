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
reviews.data[3, ]
```

```
##   funny useful cool                user_id              review_id stars
## 3     0      1    0 0hT2KtfLiobPvh6cDC8JQg IESLBzqUCLdSzSqm0eCSxQ     4
##         date
## 3 2012-06-14
##                                                                           text
## 3 love the gyro plate. Rice is so good and I also dig their candy selection :)
##     type            business_id
## 3 review 6oRAC4uyJCsJl1X0WZpVSA
```


---

## Initial Data Analysis
...

---

## Useful vs Funny/Cool
![plot of chunk usefulvfunny](figure/usefulvfunny.png) 


---

## City Data
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Wed Apr 24 14:48:31 2013 -->
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

## Exploratory Data Analysis
...

---

## Useful Users
<!-- html table generated in R 2.15.3 by xtable 1.7-1 package -->
<!-- Wed Apr 24 14:48:32 2013 -->
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


