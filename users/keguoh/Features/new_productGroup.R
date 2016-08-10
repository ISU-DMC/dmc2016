pG_train <- read.table("binned_new_productGroup_train.csv", header = T, sep = ",")
pG_class <- read.table("binned_new_productGroup_class.csv", header = T, sep = ",")
pG_all <- rbind(pG_train, pG_class)
all$pG1 <- pG_all$binned_new_productGroup_option_1
all$pG2 <- pG_all$binned_new_productGroup_option_2
all$pG3 <- pG_all$binned_new_productGroup_option_3
all$pG4 <- pG_all$binned_new_productGroup_option_4
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
ids <- c("pG1","pG2","pG3","pG4")
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
