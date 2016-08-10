
###get the data
train1 <- read.table("/Users/LiQi/Desktop/raw_data/orders_train.txt", header=T, sep=";")
test1 <- read.table("/Users/LiQi/Desktop/raw_data/orders_class.txt", header=T, sep=";")


total<-rbind(train1[,-15],test1)

total$article_number_t_h<-as.factor(substr(total$articleID,5,6))
total$order_number<-substr(total$orderID,5,10)
total$month<-substr(total$orderDate,6,7)
summary(as.factor(total$article_number_t_h))
summary(as.factor(total$productGroup))

total_1289<-subset(total,total$productGroup=="1289")
summary(total_1289$article_number_t_h)
# 45
summary(total_1289$sizeCode)
# all sizeCode A

total_1258<-subset(total,total$productGroup=="1258")
summary(total_1258$article_number_t_h)
# 45
summary(total_1258$sizeCode)
# 75-100,A L.M.S ???

total_1257<-subset(total,total$productGroup=="1257")
summary(total_1257$article_number_t_h)
# 44,45
summary(total_1257$sizeCode)
# all sizeCode A
plot(total_1237$price)

total_1237<-subset(total,total$productGroup=="1237")
summary(total_1237$article_number_t_h)
# all total$article_number_t_h 43,44
summary(total_1237$sizeCode)
#25-33,34,36,38,40,42,44, shoes or???

total_1236<-subset(total,total$productGroup=="1236")
summary(total_1236$article_number_t_h)
# only 43
summary(total_1236$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1234<-subset(total,total$productGroup=="1234")
summary(total_1234$article_number_t_h)
# only 43
summary(total_1234$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1231<-subset(total,total$productGroup=="1231")
summary(total_1231$article_number_t_h)
#41 42
summary(total_1231$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1230<-subset(total,total$productGroup=="1230")
summary(total_1230$article_number_t_h)
# only 41
summary(total_1230$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1225<-subset(total,total$productGroup=="1225")
summary(total_1225$article_number_t_h)
# 40,41
summary(total_1225$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1222<-subset(total,total$productGroup=="1222")
summary(total_1222$article_number_t_h)
# only 40
summary(total_1222$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1221<-subset(total,total$productGroup=="1221")
summary(total_1221$article_number_t_h)
# only 40
summary(total_1221$sizeCode)
# only 34,36,38,40,42,44, shoes?


total_1220<-subset(total,total$productGroup=="1220")
summary(total_1220$article_number_t_h)
# only 40
summary(total_1220$sizeCode)
# only 34,36,38,40,42,44, shoes?

total_1214<-subset(total,total$productGroup=="1214")
summary(total_1214$article_number_t_h)
# only 40
summary(total_1214$sizeCode)
# only 34,36,38,40,42,44, shoes?


train1$order_first_letter<-substr(train1$orderID,0,1)
train1$order_number<-substr(train1$orderID,2,10)

train1$article_first_letter<-substr(train1$articleID,0,1)
train1$article_number<-substr(train1$articleID,6,10)

summary(as.factor(train1$article_number))
summary(as.factor(train1$productGroup))
summary(as.factor(test1$productGroup))

train1$article_first_3_number<-substr(train1$articleID,2,4)
train1$article_number_t_h<-substr(train1$articleID,5,6)

require(ggplot2)
qplot(data = train1,x=train1$article_number_t_h, facets = train1$productGroup)


summary(as.factor(train1$article_first_3_number))

train1$article_the_4_number<-substr(train1$articleID,5,5)


summary(as.factor(train1$article_the_4_number))
unique(train1$articleID)


test1$order_first_letter<-substr(test1$orderID,0,1)
test1$order_number<-substr(test1$orderID,2,10)
test1$article_number<-substr(test1$articleID,2,10)

test1$article_first_3_number<-substr(test1$articleID,2,4)


summary(as.factor(test1$article_first_3_number))


train1<-as.data.frame(data)

summary(train1)
# basic try


unique(data1$paymentMethod)
#######features matrix
f_tr <- data.frame(returnQuantity <- train1$returnQuantity) # initial feature matrix
# Features

# 1. Compare rrp and price, rrp should be higher
f_tr$rrp_minus_price <- train1$rrp - train1$price  # the obtained discounts 
summary(f_tr$rrp_minus_price)
f_tr$lower_than_price <- f_tr$rrp_minus_price<0 

# 2. Compare the obtrained discounts and voucherAmount
f_tr$voucher_minus_discounts <- train1$voucherAmount - f_tr$rrp_minus_price # the obtained discounts 

summary(f_tr$voucher_minus_discounts)
f_tr$discounts_larger_than_voncher <- f_tr$voucher_minus_discounts<0 

# 3. voucher rate
f_tr$voucher_rate<-train1$voucherAmount/train1$rrp
summary(f_tr$voucher_rate)
# 4. discounts rate
f_tr$discounts_rate<-f_tr$rrp_minus_price/train1$rrp
summary(f_tr$voucher_rate)
##########
f_tr1<-f_tr[,-1]

write.csv(f_tr1, file = "/Users/LiQi/Desktop/raw_data/qili_train_voucher_rrp_price.csv")

#apply feature to test data
#######features matestix
f_test <- data.frame(orderID <- test1$orderID) # initial feature matestix
# Features

# 1. Compare rrp and price, rrp should be higher
f_test$rrp_minus_price <- test1$rrp - test1$price  # the obtained discounts 
summary(f_test$rrp_minus_price)
f_test$lower_than_price <- f_test$rrp_minus_price<0 

# 2. Compare the obtested discounts and voucherAmount
f_test$voucher_minus_discounts <- test1$voucherAmount - f_test$rrp_minus_price # the obtained discounts 

summary(f_test$voucher_minus_discounts)
f_test$discounts_larger_than_voncher <- f_test$voucher_minus_discounts<0 

# 3. voucher rate
f_test$voucher_rate<-test1$voucherAmount/test1$rrp
summary(f_test$voucher_rate)
# 4. discounts rate
f_test$discounts_rate<-f_test$rrp_minus_price/test1$rrp
summary(f_test$voucher_rate)
f_test1<-f_test[,-1]
##########
write.csv(f_test1, file = "/Users/LiQi/Desktop/raw_data/qili_test_voucher_rrp_price.csv")








ftr$Group_size<-as.numeric(train1$sizeCode) as.numeric(train1$productGroup)

table(train1$voncherID,train1$voncherAmount)

te1<-subset(train1, train1$voncherAmount==0)
summary(train1$voncherAmount)


require("ggplot2")

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