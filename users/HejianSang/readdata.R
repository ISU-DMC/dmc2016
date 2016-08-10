#######
#setwd("C:/Users/hjsang/Desktop")
library(ggplot2)
library(lubridate)
library(reshape2)
library(plyr)
library(dplyr)


# train=read.table("orders_train.txt",head=T,sep=";")
# saveRDS(train,"order_train.rds")
train=readRDS("order_train.rds")
dim(train)
head(train)

 # test=read.table("orders_class.txt",head=T,sep=";")
 # saveRDS(test,"order_class.rds")
test=readRDS("order_class.rds")
######
summary(train)
names(train)
# [1] "orderID"        "orderDate"      "articleID"      "colorCode"      "sizeCode"       "productGroup"  
# [7] "quantity"       "price"          "rrp"            "voucherID"      "voucherAmount"  "customerID"    
# [13] "deviceID"       "paymentMethod"  "returnQuantity"
##plot data with quantity 
plot(1:dim(train)[1],train$returnQuantity)
ggplot(aes(as.Date(orderDate),returnQuantity),data=train)+geom_point()


#### for colorCode
color.train=train$colorCode
color.test=test$colorCode
unique(color.test)[which(!unique(color.test)%in%unique(color.train))]
### There are some colorcodes not in train data
### I want to figure our If someone likes one color or similar colors
## freqency of customerID
### I want to figure out the prefernce of the customer
### Fisrt I want to make sure that all customer IDs in test data are in train data too
all(unique(test$customerID)%in% unique(train$customerID))
# False
## How much customers not in train data
sum(!unique(test$customerID)%in% unique(train$customerID))
# 30669 
## proportion 
sum(!unique(test$customerID)%in% unique(train$customerID))/dim(test)[1]
# 0.08991258
## small proportion

#### Next I want figure out what kind of size ,color  for the specific customer

# check some group with same size ?
group.size=ddply(train,.(productGroup),summarise,range=paste(unique(sizeCode),collapse="_"),freq=length(sizeCode))
size.customer=ddply(train,.(articleID,productGroup),summarise,freq=paste(unique(colorCode),collapse="_"))
pref.size=subset(size.customer,returnQuantity==0)

v.sub=ddply(train,.(orderID),summarise,coupon=unique(voucherAmount),s.price=sum(price),s.rrp=sum(rrp))

color.customer=ddply(train,.(customerID,returnQuantity),summarise,freq=paste(sort(unique(colorCode)),collapse="_"))
V=ddply(train,.(orderID),summarise,freq=length(unique(voucherID)))
plot(v.sub$s.price,v.sub$coupon)
plot(v.sub$s.price,v.sub$s.rrp)
abline(0,1)
##############################################################
train$unitprice=train$price/train$quantity
v.sub=ddply(train,.(orderID),summarise,coupon=unique(voucherAmount),s.price=sum(price),s.rrp=sum(rrp*quantity))
which.min(((v.sub$s.rrp-v.sub$s.price)[!is.na(v.sub$s.rrp-v.sub$s.price)]))

cos=ddply(train,.(orderID),summarise,total_quantity=sum(quantity),total_returnQuantity=sum(returnQuantity))
ggplot(aes(total_quantity,total_returnQuantity),data=cos)+geom_point()




#################################################################################
### Explore Voucher

train$unitprice=0
train$unitprice[train$quantity!=0]=train$price[train$quantity!=0]/train$quantity[train$quantity!=0]
test$unitprice=0
test$unitprice[test$quantity!=0]=test$price[test$quantity!=0]/test$quantity[test$quantity!=0]

voucher=d_ply(train,.(customerID,orderID,articleID,voucherID,voucherAmount),function(x)
              ind.coupon=as.numeric(sum(x$voucherAmount)!=0), total.price=sum(x$price))


##############################################################
### Feature 1 
### If the order use the voucher
### Remove quantity =0 beacause quantity 0 we predict 0
# train=subset(train, quantity!=0)
# test=subset(train, quantity!=0)


train$unitprice=train$price/train$quantity
train$unitprice[train$price==0]=0
test$unitprice=test$price/test$quantity
test$unitprice[test$price==0]=0
train$sale=round(train$unitprice/train$rrp,2)
train$sale[train$rrp==0]=0
test$sale=round(test$unitprice/test$rrp,2)
test$sale[test$rrp==0]=0
train$rate=train$returnQuantity/train$quantity


ddply(train,.(sale),summarise,r=sum(returnQuantity)/sum(quantity))

write.csv(data.frame(orderID=train$orderID,articleID=train$articleID,hejian_sale_train=train$sale),"hejian_sale_train.csv",row.names =F)
write.csv(data.frame(orderID=test$orderID,articleID=test$articleID,hejian_sale_test=test$sale),"hejian_sale_test.csv",row.names = F)


####
## If the order use the voucher
# train$ind_voucher=as.numeric(train$voucherAmount>0)
# 
# test$ind_voucher=as.numeric(test$voucherAmount>0)
ddply(train,.(ind_voucher),summarise,rate=sum(returnQuantity)/sum(quantity))
# ind_voucher      rate
# 1           0 0.5213178
# 2           1 0.5351798

train$voucherAmount1=train$voucherAmount[train$voucherAmount%in% 1:300]
order.train=ddply(train,.(orderID),summarise,
                  coupon=ifelse(unique(voucherAmount)%in%1:300,unique(voucherAmount),
                                unique(voucherAmount)/sum(price)))
order.train=group_by(train,orderID)
order.test=group_by(test,orderID)
s.order.train=summarise(order.train,total.price=sum(price),coupon=unique(voucherAmount),total.quantity=sum(quantity),total.returnQuantity=sum(returnQuantity))
s.order.test=summarise(order.test,total.price=sum(price),coupon=unique(voucherAmount),total.quantity=sum(quantity))
summary(s.order.train$coupon)

tag.train=summarise(group_by(s.order.train,orderID),tag1=round(coupon/total.price,2),tag2=coupon)
tag.test=summarise(group_by(s.order.test,orderID),tag1=round(coupon/total.price,2),tag2=coupon)
#plot(s.order.train$total.price,s.order.train$coupon)

train=merge(train,tag.train,by="orderID")
test=merge(test,tag.test,by="orderID")
ddply(train,.(tag2),summarise,rate=sum(returnQuantity)/sum(quantity))


write.csv(train[,c("orderID","tag1","tag2")],"hejian_percentage_numeric_voucheramount_train.csv",row.names = F)
write.csv(train[,c("orderID","tag1","tag2")],"hejian_percentage_numeric_voucheramount_test.csv",row.names = F)
