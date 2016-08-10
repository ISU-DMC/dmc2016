library(ggplot2)
library(reshape2)
library(dplyr)
library(stringi)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")

# new variable for last 4 digits of article ID 
d$articleID_last4<-as.numeric(stri_sub(d$articleID, -4,-1))
class$articleID_last4<-as.numeric(stri_sub(class$articleID, -4,-1))

# new variable for last 3 digits of article ID 
d$articleID_last3<-as.numeric(stri_sub(d$articleID, -3,-1))
class$articleID_last3<-as.numeric(stri_sub(class$articleID, -3,-1))

# new variable for last 2 digits of article ID 
d$articleID_last2<-as.numeric(stri_sub(d$articleID, -2,-1))
class$articleID_last2<-as.numeric(stri_sub(class$articleID, -2,-1))

# thousands digit of article ID 
d$articleID_thousands<-as.numeric(stri_sub(d$articleID, -4,-4))
class$articleID_thousands<-as.numeric(stri_sub(class$articleID, -4,-4))

# hundreds digit of article ID 
d$articleID_hundreds<-as.numeric(stri_sub(d$articleID, -3,-3))
class$articleID_hundreds<-as.numeric(stri_sub(class$articleID, -3,-3))

# tens digit of article ID 
d$articleID_tens<-as.numeric(stri_sub(d$articleID, -2,-2))
class$articleID_tens<-as.numeric(stri_sub(class$articleID, -2,-2))

# ones digit of article ID 
d$articleID_ones<-as.numeric(stri_sub(d$articleID, -1,-1))
class$articleID_ones<-as.numeric(stri_sub(class$articleID, -1,-1))

FeatureArticleDigitT<-cbind(d$articleID_last4, d$articleID_last3, d$articleID_last2, d$articleID_thousands, d$articleID_hundreds, d$articleID_tens, d$articleID_ones)
FeatureArticleDigitC<-cbind(class$articleID_last4, class$articleID_last3, class$articleID_last2, class$articleID_thousands, class$articleID_hundreds, class$articleID_tens, class$articleID_ones)
FeatureArticleDigitT<-data.frame(FeatureArticleDigitT)
FeatureArticleDigitC<-data.frame(FeatureArticleDigitC)

names(FeatureArticleDigitT)<-c("articleID_last4", "articleID_last3", "articleID_last2", "articleID_thousands", "articleID_hundreds", "articleID_tens", "articleID_ones")
names(FeatureArticleDigitC)<-c("articleID_last4", "articleID_last3", "articleID_last2", "articleID_thousands", "articleID_hundreds", "articleID_tens", "articleID_ones")

write.csv(FeatureArticleDigitT, file = "/Users/manjujohny/Documents/Features/mjohny_articleDigits_train.csv", row.names=FALSE)
write.csv(FeatureArticleDigitC, file = "/Users/manjujohny/Documents/Features/mjohny_articleDigits_class.csv", row.names=FALSE)

