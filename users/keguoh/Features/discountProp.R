setwd("C:/Users/huangke/Documents/GitHub/dmc2016/data/raw_data")
train <- read.table("orders_train.txt", header = T, sep = ";")
class <- read.table("orders_class.txt", header = T, sep = ";")
class$returnQuantity <- 0
all <- rbind(train, class)
setwd("C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/")

# 2. Compare rrp and price
# define unit_price
unit_price <- price
unit_price[price!=0] <- price[price!=0] / quantity[price!=0]
d <- data.frame(unit_price)
names(d) <- "keguoh_unitprice_train"
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_unitprice_train.csv", row.names = F)

test_unit_price <- test$price
test_unit_price[test$price!=0] <- test$price[test$price!=0] / test$quantity[test$price!=0]
test_d <- data.frame(test_unit_price)
names(test_d) <- "keguoh_unitprice_test"
write.csv(test_d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_unitprice_test.csv", row.names = F)


# Proportion paid (similar to Manju's)
ftr$rrp_minus_price <- train$rrp - unit_price  # the obtained discounts 
ftr$rrp_price_ratio <- train$rrp/train$price # similar to above, make more sense as $10 discount means different for a $20 order and a $200 order.
# two special cases for the ratio: 5/0=Inf, 0/0=NaN
table(ftr$rrp_price_ratio=="NaN")
sum(price==0 & rrp==0)       # 15205 items
table(ftr$rrp_price_ratio=="Inf")
sum(price==0 & rrp!=0)       # 31638 items

head(train[price==0 & rrp==0, ])
table(train[price==0 & rrp==0, "returnQuantity"]) # 1602 out of 15205 return for this category
head(train[price==0 & rrp!=0, ])  
table(train[price==0 & rrp!=0, "returnQuantity"]) # only 8 out of 31638 return for this category!!



all$ID <- 1:nrow(all)
all0 <- all
all0$voucherID0 <- all$voucherID
all0$voucherID0[is.na(all$voucherID)] <- 0
all0$rrpfill <- all$rrp
all0$rrpfill[is.na(all$rrp)] <- all0$price[is.na(all$rrp)]/all0$quantity[is.na(all$rrp)] # fill rrp0 with
all0$productGroup0 <- all$productGroup
all0$productGroup0[is.na(all$productGroup)] <- 0
all0$totalrrpfill <- all0$rrpfill * all0$quantity

sum(is.na(all0$totalrrpfill))
sum(is.na(all0$quantity))
sum(is.na(all0$price))

ids <- c("articleID","sizeCode","orderID","customerID2","colorCode","productGroup0")
discountProps <- as.data.frame(matrix(0, nrow(all0), length(ids)))
for(j in 1:length(ids)){
  all_sort <- all0[order(all0[ ,ids[j]]), c("price", "quantity", "totalrrpfill", ids[j], "ID")]
  price_sort <- tapply(all_sort[, "price"], all_sort[, ids[j]], function(x){rep(sum(x), length(x))})
  totalrrpfill_sort <- tapply(all_sort[, "totalrrpfill"], all_sort[, ids[j]], function(x){rep(sum(x), length(x))})
  all_sort$discountProps_sort <- unlist(price_sort, use.names = F)/unlist(totalrrpfill_sort, use.names = F)
  discountProps[ ,j] <- all_sort$discountProps_sort[order(all_sort$ID)]
  names(discountProps)[j] = paste("discountProp_by_", ids[j], sep = "")
}
head(discountProps)
nrow(discountProps)
discountProps[2666263,]


### check
head(all$customerID2)
all[all$customerID2 == 9963, c("quantity", "price", "rrpfill")]
sum(all0$price[all0$customerID2 == 9963])/sum(all0$rrpfill[all$customerID2 == 9963])

head(all$sizeCode)
all[all$sizeCode == 44, c("quantity", "price", "rrpfill")]
sum(all0$price[all0$sizeCode == 44])/sum(all0$rrpfill[all0$sizeCode == 44]*all0$quantity[all0$sizeCode == 44])

apply(discountProps, 2, function(x){sum(x %in% c(Inf))})
apply(discountProps, 2, function(x){sum(x %in% c("NaN"))})
head(discountProps$discountProp_by_articleID[is.na(discountProps$discountProp_by_articleID)])
head(which(discountProps$discountProp_by_articleID == "NaN"))
head(which(discountProps$discountProp_by_colorCode == "NaN"))
discountProps[1700,]
all0[1700,]
discountProps[1118709,]
all0[1118709,]

## deal with NaN's
str(discountProps)
discountProps[is.na.data.frame(discountProps)] <- 1
apply(discountProps, 2, function(x){sum(x %in% c(Inf))})
apply(discountProps, 2, function(x){sum(x %in% c("NaN"))})

## write 

dt <- discountProps[1:nrow(train), ]
write.csv(dt, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_discountProps_train.csv", row.names = F)
dc <- discountProps[-(1:nrow(train)), ]
write.csv(dc, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_discountProps_class.csv", row.names = F)

sum(is.na(dt))
sum(is.na(dc))
