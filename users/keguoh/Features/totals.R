setwd("C:/Users/huangke/Documents/GitHub/dmc2016/data/raw_data")
train <- read.table("orders_train.txt", header = T, sep = ";")
class <- read.table("orders_class.txt", header = T, sep = ";")
class$returnQuantity <- 0
all <- rbind(train, class)


# 6. total 


all$ID <- 1:nrow(all)

all0 <- all
all0$voucherID0 <- all$voucherID
all0$voucherID0[is.na(all$voucherID)] <- 0
all0$rrp0 <- all$rrp
all0$rrp0[is.na(all$rrp)] <- 0
all0$productGroup0 <- all$productGroup
all0$productGroup0[is.na(all$productGroup)] <- 0

qnties <- c("price","voucherAmount","rrp0")
ids <- c("articleID","orderID","customerID","colorCode","productGroup0")
totals_per_ids_all <- as.data.frame(matrix(0, nrow(all0), length(qnties)*length(ids)))
for(i in 1:length(qnties)){
  for(j in 1:length(ids)){
    all_sort <- all0[order(all0[ ,ids[j]]), c(qnties[i], ids[j], "ID")]
    totals <- tapply(all_sort[, qnties[i]], all_sort[, ids[j]], function(x){rep(sum(x), length(x))})
    all_sort$totals <- unlist(totals, use.names = F)
    totals_per_ids_all[ ,j+length(ids)*(i-1)] <- all_sort$totals[order(all_sort$ID)]
    names(totals_per_ids_all)[j+length(ids)*(i-1)] = paste("total_", qnties[i], "_by_", ids[j], sep = "")
  }
}
head(totals_per_ids_all)

d <- totals_per_ids_all[1:nrow(train), ]
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_totals_train.csv", row.names = F)
d <- totals_per_ids_all[-(1:nrow(train)), ]
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_totals_class.csv", row.names = F)


qnties <- c("paymentMethod")
ids <- c("customerID")
i <- 1
j <- 1
all_sort <- all0[order(all0[ ,ids[j]]), c(qnties[i], ids[j], "ID")]
totals <- tapply(all_sort[, qnties[i]], all_sort[, ids[j]], function(x){rep(unique(length(unique(x))), length(x))})
all_sort$totals <- unlist(totals, use.names = F)
paymentMethod_per_customer <- all_sort$totals[order(all_sort$ID)]
paymentMethod_per_customer_train <- paymentMethod_per_customer[1:nrow(train)]
paymentMethod_per_customer_class <- paymentMethod_per_customer[-(1:nrow(train))]
write.csv(data.frame(paymentMethod_per_customer = paymentMethod_per_customer_train), file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_paymentMethod_per_customer_train.csv", row.names = F)
write.csv(data.frame(paymentMethod_per_customer = paymentMethod_per_customer_class), file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_paymentMethod_per_customer_class.csv", row.names = F)


