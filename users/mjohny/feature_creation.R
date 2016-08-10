library(ggplot2)
library(reshape2)
library(dplyr)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")

dim(d)
dim(class)

#########

#fix price NA stuff. There are na s bc were divind by 0
d$price_unit<-d$price/d$quantity
#d$price_unit[d$quantity==0]<-0
summary(d$price_unit)

class$price_unit<-class$price/class$quantity
#class$price_unit[class$quantity==0]<-0
summary(class$price_unit)

######### discountProp ############


summary(d$price)
summary(d$quantity)
summary(d$price_unit)
summary(d$rrp)

#rrp*x=price_unit => x = price_unit/rrp
d$discountPropt<-d$price_unit/d$rrp

summary(d$discountPropt)
d$discountPropt[d$price==0]<-0
summary(d$discountPropt)
discountPropt<-data.frame(d$discountPropt)
summary(discountPropt)
names(discountPropt)<-"discountProp"
head(discountPropt)
write.csv(discountPropt, file = "/Users/manjujohny/Documents/Features/mjohny_discountProp_train.csv", row.names=FALSE)
dp<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_discountProp_train.csv",header=TRUE)
head(dp)


class$discountPropc<-class$price_unit/class$rrp
class$discountPropc[class$price==0]<-0
discountPropc<-data.frame(class$discountPropc)
summary(discountPropc)
names(discountPropc)<-"discountProp"
write.csv(discountPropc, file = "/Users/manjujohny/Documents/Features/mjohny_discountProp_class.csv", row.names=FALSE)
dp2<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_discountProp_class.csv",header=TRUE)
dp1<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_discountProp_train.csv",header=TRUE)

discountPropRoundc<-data.frame(round(dp2$discountProp,2))
discountPropRoundt<-data.frame(round(dp1$discountProp,2))


dim(discountPropRoundc)
dim(discountPropRoundt)
names(discountPropRoundc)<-"discountProp"
names(discountPropRoundt)<-"discountProp"
write.csv(discountPropRoundc, file = "/Users/manjujohny/Documents/Features/mjohny_discountPropRound_class.csv", row.names=FALSE)
write.csv(discountPropRoundt, file = "/Users/manjujohny/Documents/Features/mjohny_discountPropRound_train.csv", row.names=FALSE)
dpr1<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_discountPropRound_class.csv",header=TRUE)
dpr2<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_discountPropRound_train.csv",header=TRUE)
head(dpr1)
head(dpr2)

########### 
