library(dplyr)
library(lubridate)

dat.class <- read.table("orders_class.txt", header = TRUE, sep = ";")
dat.train <- read.table("orders_train.txt", header = TRUE, sep = ";")
# dat.whole <- rbind(dat.train[, -15], dat.class)
dat.class$returnQuantity <- NA
dat.whole <- rbind(dat.train, dat.class)

## Exploration of class & train data
class(dat.class)
dim(dat.class) # 341,098 * 14
str(dat.class)
sum(is.na(dat.class)) # 216: 107 in "productGroup" = 107 in "rrp", 2 in "voucherID" (250436, 283001)
colnames(dat.class)
# "orderID"       "orderDate"     "articleID"     "colorCode"     "sizeCode"      "productGroup"  "quantity"      "price"         "rrp"           "voucherID"     "voucherAmount"   "customerID"    "deviceID"      "paymentMethod"
length(unique(dat.class$orderID)) # 110,487
length(unique(dat.class$orderDate)) # 92
length(unique(dat.class$articleID)) # 1573
length(unique(dat.class$colorCode)) # 335
length(unique(dat.class$sizeCode)) # 29
length(unique(dat.class$productGroup)) # 29
length(unique(dat.class$quantity)) # 6
length(unique(dat.class$price)) # 211
length(unique(dat.class$rrp)) # 32 
length(unique(dat.class$voucherID)) # 229
length(unique(dat.class$voucherAmount)) # 996
length(unique(dat.class$customerID)) # 73,030
length(unique(dat.class$deviceID)) # 5
length(unique(dat.class$paymentMethod)) # 10 (BPLS BPPL BPRG CBA KGRG KKE NN PAYPALVC RG VORAUS)

class(dat.train)
dim(dat.train) # 2,325,165 * 15
str(dat.train)
sum(is.na(dat.train)) # 708: 351 in "productGroup" = 351 in "rrp", 6 in "voucherID" (51238, 51239, 899763, 1903296 | 2225950, 2225951)
colnames(dat.train)
# "orderID"       "orderDate"     "articleID"     "colorCode"     "sizeCode"      "productGroup"  "quantity"      "price"         "rrp"           "voucherID"     "voucherAmount"   "customerID"    "deviceID"      "paymentMethod" "returnQuantity"
length(unique(dat.train$orderID)) # 738,698
length(unique(dat.train$orderDate)) # 638
length(unique(dat.train$articleID)) # 3823
length(unique(dat.train$colorCode)) # 546
length(unique(dat.train$sizeCode)) # 29
length(unique(dat.train$productGroup)) # 19
length(unique(dat.train$quantity)) # 11
length(unique(dat.train$price)) # 235
length(unique(dat.train$rrp)) # 46
length(unique(dat.train$voucherID)) # 671
length(unique(dat.train$voucherAmount)) # 1549
length(unique(dat.train$customerID)) # 311,369
length(unique(dat.train$deviceID)) # 5
length(unique(dat.train$paymentMethod)) # 10 (BPLS BPPL BPRG CBA KGRG KKE NN PAYPALVC RG VORAUS)
length(unique(dat.train$returnQuantity)) # 6

sum(unique(dat.class$orderID) %in% unique(dat.train$orderID)) # 0
sum(unique(dat.class$orderDate) %in% unique(dat.train$orderDate)) # 0
sum(unique(dat.class$articleID) %in% unique(dat.train$articleID)) # 1155
sum(unique(dat.class$colorCode) %in% unique(dat.train$colorCode)) # 239
sum(unique(dat.class$sizeCode) %in% unique(dat.train$sizeCode)) # 29
sum(unique(dat.class$productGroup) %in% unique(dat.train$productGroup)) # 16
sum(unique(dat.class$quantity) %in% unique(dat.train$quantity)) # 6
sum(unique(dat.class$price) %in% unique(dat.train$price)) # 173
sum(unique(dat.class$rrp) %in% unique(dat.train$rrp)) # 32
sum(unique(dat.class$voucherID) %in% unique(dat.train$voucherID)) # 56
sum(unique(dat.class$voucherAmount) %in% unique(dat.train$voucherAmount)) # 745
sum(unique(dat.class$customerID) %in% unique(dat.train$customerID)) # 42,361
sum(unique(dat.class$deviceID) %in% unique(dat.train$deviceID)) # 5
sum(unique(dat.class$paymentMethod) %in% unique(dat.train$paymentMethod)) # 10


## Create feature for weekends & Christmas
day.week.class <- as.POSIXlt(dat.class$orderDate)$wday # 341098
day.week.train <- as.POSIXlt(dat.train$orderDate)$wday # 2325165
IsWeekend.class <- ifelse(day.week.class == 0 | day.week.class == 6, 1, 0) # 93245
IsWeekend.train <- ifelse(day.week.train == 0 | day.week.train == 6, 1, 0) # 598934

month.class <- as.POSIXlt(dat.class$orderDate)$mon
month.train <- as.POSIXlt(dat.train$orderDate)$mon
date.class <- as.POSIXlt(dat.class$orderDate)$mday
date.train <- as.POSIXlt(dat.train$orderDate)$mday
IsChris.class <- ifelse(month.class == 11 & (date.class == 25 | date.class == 26), 1, 0) # 3917
IsChris.train <- ifelse(month.train == 11 & (date.train == 25 | date.train == 26), 1, 0) # 3528

IsWeekendChris.class <- as.data.frame(cbind(IsWeekend.class, IsChris.class))
colnames(IsWeekendChris.class) <- c("IsWeekend", "IsChristmas")
IsWeekendChris.train <- as.data.frame(cbind(IsWeekend.train, IsChris.train))
colnames(IsWeekendChris.train) <- c("IsWeekend", "IsChristmas")

write.csv(IsWeekendChris.class, file = "LiXinyi_IsWeekendChristmas_class.csv", row.names = FALSE, quote = FALSE)
write.csv(IsWeekendChris.train, file = "LiXinyi_IsWeekendChristmas_train.csv", row.names = FALSE, quote = FALSE)



## Create features of ending for price and rrp
EndPrice.class <- round(dat.class$price - trunc(dat.class$price), digits = 3)
EndPrice.train <- round(dat.train$price - trunc(dat.train$price), digits = 3)

Endrrp.class <- round(dat.class$rrp - trunc(dat.class$rrp), digits = 3)
Endrrp.train <- round(dat.train$rrp - trunc(dat.train$rrp), digits = 3)

EndPriceRrp.class <- as.data.frame(cbind(EndPrice.class, Endrrp.class))
colnames(EndPriceRrp.class) <- c("EndPrice", "Endrrp")
EndPriceRrp.train <- as.data.frame(cbind(EndPrice.train, Endrrp.train))
colnames(EndPriceRrp.train) <- c("EndPrice", "Endrrp")

write.csv(EndPriceRrp.class, file = "LiXinyi_EndPriceRrp_class.csv", row.names = FALSE, quote = FALSE)
write.csv(EndPriceRrp.train, file = "LiXinyi_EndPriceRrp_train.csv", row.names = FALSE, quote = FALSE)



## Check the histograms
article = unique(c(as.character(dat.train$articleID), as.character(dat.class$articleID))) # 4241
plot(as.numeric(filter(dat.train, dat.train$articleID == article[1])$orderDate), (filter(dat.train, dat.train$articleID == article[1]))$price)
plot(as.numeric(filter(dat.train, dat.train$articleID == article[2])$orderDate), (filter(dat.train, dat.train$articleID == article[2]))$price)

dim(filter(dat.train, dat.train$price == 0))
filter(dat.train, dat.train$articleID == article[2], dat.train$price == 40)
dim(filter(dat.train, dat.train$price == 0, dat.train$returnQuantity != 0))
dim(filter(dat.train, dat.train$quantity == 0, dat.train$returnQuantity != 0)) ## 8
dim(filter(dat.train, voucherID == 0, voucherAmount != 0)) ## 0
dim(filter(dat.class, voucherID == 0, voucherAmount != 0)) ## 0
filter(dat.class, customerID == "c1196456")

dim(filter(dat.whole, dat.whole$sizeCode == "A"))


plot(dat.whole$orderDate, dat.whole$articleID)
plot(dat.whole$orderDate, dat.whole$colorCode)
plot(dat.whole$orderDate, dat.whole$productGroup)

table(dat.whole$productGroup, dat.whole$rrp)
table(dat.whole$productGroup, dat.whole$sizeCode)
table(dat.whole$productGroup, dat.whole$colorCode)

whole.size32 <- filter(dat.whole, dat.whole$sizeCode == 32)
whole.size34 <- filter(dat.whole, dat.whole$sizeCode == 34)
table(whole.size32$productGroup, whole.size32$rrp)
table(whole.size34$productGroup, whole.size34$rrp)
dim(filter(dat.whole, dat.whole$productGroup == 1237))