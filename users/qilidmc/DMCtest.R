data <- read.table("/Users/LiQi/Desktop/raw_data/orders_train.txt", header=T, sep=";")

train1<-as.data.frame(data)

summary(train1)
write.csv(data1, file = "/Users/LiQi/Desktop/raw_data/MyData.csv")

unique(data1$paymentMethod)

ftr <- data.frame(returnQuantity <- train1$returnQuantity) # initial feature matrix
# Features

# 1. Returns
ftr$return_or_not <- train1$returnQuantity>0  # return or not

# 2. Compare rrp and price
ftr$rrp_minus_price <- train1$rrp - train1$price  # the obtained discounts 
summary(ftr$rrp_minus_price)


ftr$Group_size<-as.numeric(train1$sizeCode) as.numeric(train1$productGroup)

table(train1$voncherID,train1$voncherAmount)

te1<-subset(train1, train1$voncherAmount==0)
summary(train1$voncherAmount)


require("ggplot2")
ftr$lower_than_price <- ftr$rrp_minus_price<0 
summary(ftr$lower_than_price)

te1<-subset(ftr)

qplot(train1$returnQuantity,  margins=ftr$lower_than_price)



ftr$rrp_price_ratio <- train1$rrp/train1$price # similar to above, make more sense as $10 discount means different for a $20 order and a $200 order.
# two special cases for the ratio: 5/0=Inf, 0/0=NaN
table(ftr$rrp_price_ratio=="NaN")
sum(price==0 & rrp==0)       # 15205 items
table(ftr$rrp_price_ratio=="Inf")
sum(price==0 & rrp!=0)       # 31638 items

head(train1[price==0 & rrp==0, ])
table(train1[price==0 & rrp==0, "returnQuantity"]) # 1602 out of 15205 return for this category!!
head(train1[price==0 & rrp!=0, ])  
table(train1[price==0 & rrp!=0, "returnQuantity"]) # only 8 out of 31638 return for this category!!
head(ftr)