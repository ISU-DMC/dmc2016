######################################################
########## Price - voucher amount ###########
library(ggplot2)
setwd("/Users/rodrigoplazolaortiz/Desktop/Data Mining cup 2016/raw_data")

#Training data
data<-read_delim("orders_train.txt",";")

data$price_min_voucheamoun<-data$price-data$voucherAmount

priceVoucheramount<-data.frame(price.min.Vouch=data$price-data$voucherAmount)

#Missing values
table(is.na(priceVoucheramount))

write.csv(priceVoucheramount,file="rodrigoplazola_priceVoucheramount_train.csv")

##see return rate
table(data[which(data$price_min_voucheamoun<0),]$returnQuantity)
table(data[which(data$price_min_voucheamoun>0),]$returnQuantity)

##### Test data
data.test<-read_delim("orders_class.txt",";")
priceVoucheramount<-data.frame(price.min.Vouch=data.test$price-data.test$voucherAmount)

#missing values
table(is.na(priceVoucheramount))

write.csv(priceVoucheramount,file="rodrigoplazola_priceVoucheramount_class.csv")
