setwd("C:/Users/huangke/Documents/GitHub/dmc2016/data/raw_data")
train <- read.table("orders_train.txt", header = T, sep = ";")
test <- read.table("orders_class.txt", header = T, sep = ";")

head(train)
attach(train)

round(table(returnQuantity)/nrow(train),4)

table(paymentMethod, returnQuantity)  #BPRG

table(deviceID, returnQuantity)

table(as.integer(voucherAmount), returnQuantity)

#what is voucherID=0?
table(which(voucherID == 0) %in% which(voucherAmount == 0)) # VoucherID == 0 -> VoucherAmount == 0
head(train[which(voucherAmount == 0),])


pairs(train[,c("rrp", "returnQuantity")]) #slow
rrp[which(rrp>700)]
idx <- cut(rrp, breaks = c(seq(0,300,30),800), labels = 1:11, include.lowest = TRUE)  # seem to have a cor, more expensitve more returns
head(idx)
table(idx, returnQuantity)

# price
pairs(train[, c("price", "returnQuantity")])
idx <- cut(price, breaks = c(seq(0,400,40),700), labels = 1:11, include.lowest = TRUE)  # seem to have a cor, 
table(idx, returnQuantity)

# unit price
table(which(quantity == 0) %in% which(price == 0))   # quantity == 0 ---> price == 0, not the other way around
table(which(test$quantity == 0) %in% which(test$price == 0))   # quantity == 0 ---> price == 0, not the other way aroundtable(quantity, returnQuantity) 
# when quantity = 1, it seems there is a high return rate

table(productGroup, returnQuantity) # some cor

table(sizeCode, returnQuantity)

table(colorCode, returnQuantity)

table(articleID, returnQuantity)

table(orderDate, returnQuantity) # time trend?

table(quantity, returnQuantity)


#####

# 3. quantity and returnQuantity
# (price==0 & rrp!=0) ---> quantity = 0 
table(train[quantity == 0, "returnQuantity" ])
(train[quantity == 0 & returnQuantity > 0, ])  #of 31643 items with quantity = 0, only 8 returns, 
table(train[price==0 & rrp!=0 & returnQuantity == 0, "orderID"] %in% train[quantity == 0 & returnQuantity == 0, "orderID"]) #same as "price==0 & rrp!=0"
table(train[quantity > 0, "returnQuantity" ]) # no particular patterns
(train[price==0 & rrp!=0 & returnQuantity > 0, ])  #same 8 items
table(test$quantity == 0)/nrow(test) # 2 %

# 4. rrp*quantity+price-voucherAmount (no pattern found here)
summary(rrp*quantity-price-voucherAmount > 0)
table(train[rrp*quantity-price-voucherAmount > 0, "returnQuantity"])
table(train[rrp*quantity-price-voucherAmount == 0 & voucherID == 0, "returnQuantity"])
summary(rrp*quantity-price-voucherAmount < 0)
table(train[rrp*quantity-price-voucherAmount < 0, "returnQuantity"])
summary(rrp*quantity-price-voucherAmount == 0)
table(train[rrp*quantity-price-voucherAmount == 0, "returnQuantity"])


table(returnQuantity[quantity==1])
table(returnQuantity[quantity==2])
table(returnQuantity[quantity==3])
table(returnQuantity[quantity==4])
(train[quantity==3, ])[1:10, ]

str(cbind(returnQuantity, quantity))



# 5. return rate per article
total_return <- tapply(returnQuantity, articleID, function(x){rep(sum(x), length(x))})
total_buy <- tapply(quantity, articleID, function(x){rep(sum(x), length(x))})
total_return <- unlist(total_return, use.names = F)
total_buy <- unlist(total_buy, use.names = F)
return_rate <- total_return/total_buy
return_rate[return_rate == "NaN"] = 0

# check the code
sum(train[articleID == "i1000008", "returnQuantity"])
length(train[articleID == "i1000008", "returnQuantity"])
train[articleID == "i1000008", "returnQuantity"]
length(train[which(return_rate>0.7), "returnQuantity"]) #total number of item 

# One could put return rate into 10 bins
# indx <- cut(x = return_rate, breaks = seq(min(return_rate), max(return_rate), length = 11), labels = FALSE, include.lowest = TRUE)





############## Another way
t<-length(unique(all$customerID2))
qu=list(b="b")
length(qu)<-t
names(qu)<-1:t
for(i in 1:t){
  qu[[i]] <- 1:length(unique(all$day[all$customerID2 %in% c(i)]))
  print(i)
}

for(i in 1:t){
  names(qu[[i]]) <- unique(all$day[all$customerID2 %in% c(i)])
}

for(i in 1:730){
  alltemp <- all[all$day %in% c(i), ]
  for(j in 1:length(qu[[i]])){
    qu[[i]][j] <- sum(alltemp$quantity[alltemp$customerID2 %in% c(names(qu[[i]])[j])])
  }
  print(i)
}
