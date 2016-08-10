library(ggplot2)
library(reshape2)
library(dplyr)
library(stringi)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")
names(d)
# new variable for last 3 digits of voucher ID 
d$voucherID_last3<-as.numeric(stri_sub(d$voucherID, -3,-1))
class$voucherID_last3<-as.numeric(stri_sub(class$voucherID, -3,-1))

# new variable for last 2 digits of voucher ID 
d$voucherID_last2<-as.numeric(stri_sub(d$voucherID, -2,-1))
class$voucherID_last2<-as.numeric(stri_sub(class$voucherID, -2,-1))

# hundreds digit of voucher ID 
d$voucherID_hundreds<-as.numeric(stri_sub(d$voucherID, -3,-3))
class$voucherID_hundreds<-as.numeric(stri_sub(class$voucherID, -3,-3))

# tens digit of voucher ID 
d$voucherID_tens<-as.numeric(stri_sub(d$voucherID, -2,-2))
class$voucherID_tens<-as.numeric(stri_sub(class$voucherID, -2,-2))

# ones digit of voucher ID 
d$voucherID_ones<-as.numeric(stri_sub(d$voucherID, -1,-1))
class$voucherID_ones<-as.numeric(stri_sub(class$voucherID, -1,-1))

FeatureVoucherIDDigitT<-cbind(d$voucherID_last3, d$voucherID_last2, d$voucherID_hundreds, d$voucherID_tens, d$voucherID_ones)
FeatureVoucherIDDigitC<-cbind(class$voucherID_last3, class$voucherID_last2, class$voucherID_hundreds, class$voucherID_tens, class$voucherID_ones)
FeatureVoucherIDDigitT<-data.frame(FeatureVoucherIDDigitT)
FeatureVoucherIDDigitC<-data.frame(FeatureVoucherIDDigitC)

names(FeatureVoucherIDDigitT)<-c("voucherID_last3", "voucherID_last2", "voucherID_hundreds", "voucherID_tens", "voucherID_ones")
names(FeatureVoucherIDDigitC)<-c("voucherID_last3", "voucherID_last2", "voucherID_hundreds", "voucherID_tens", "voucherID_ones")

write.csv(FeatureVoucherIDDigitT, file = "/Users/manjujohny/Documents/Features/mjohny_voucherIDdigits_train.csv", row.names=FALSE)
write.csv(FeatureVoucherIDDigitC, file = "/Users/manjujohny/Documents/Features/mjohny_voucherIDdigits_class.csv", row.names=FALSE)

which(is.na(FeatureArticleDigitT)==TRUE)
which(is.na(FeatureArticleDigitC)==TRUE)
which(is.na(FeatureVoucherIDDigitT)==TRUE)
