## sizeCode

setwd("C:/Users/huangke/Documents/GitHub/dmc2016/data/raw_data")
train <- read.table("orders_train.txt", header = T, sep = ";")
class <- read.table("orders_class.txt", header = T, sep = ";")
class$returnQuantity <- 0
all <- rbind(train, class)

attach(all)

table(all$sizeCode, all$productGroup)
# For productGroup 1237
table(all[all$productGroup == 1237, c("sizeCode","colorCode")])
table(all[all$productGroup == 1237 & all$colorCode == 10110, c("sizeCode","rrp")])

all$size_num=NULL
all$size_num[sizeCode == 100] <- 1
all$size_num[sizeCode == 95] <- .6
all$size_num[sizeCode == 90] <- .2
all$size_num[sizeCode == 85] <- -.2
all$size_num[sizeCode == 80] <- -.6
all$size_num[sizeCode == 75] <- -1

all$size_num[sizeCode == "XL"] <- 1
all$size_num[sizeCode == "L"] <- .5
all$size_num[sizeCode == "M"] <- 0
all$size_num[sizeCode == "S"] <- -.5
all$size_num[sizeCode == "XS"] <- -1
all$size_num[sizeCode == "A"] <- 0
all$size_num[sizeCode == "I"] <- 0


all$size_num[sizeCode == 44] <- 1
all$size_num[sizeCode == 42] <- 2/3
all$size_num[sizeCode == 40] <- 1/3
all$size_num[sizeCode == 38] <- 0
all$size_num[sizeCode == 36] <- -1/3
g1 <- c(1,3:9,13,14,15,17,26,50,1214,1220,1221,1222,1225,1230,1231,1234,1236)
all$size_num[sizeCode == 34 & productGroup %in% g1] <- -2/3
all$size_num[sizeCode == 32 & productGroup %in% g1] <- -1
g2 <- c(10001,10107,10109,10112,10114:10118,10186,10194,10294,10313,20001,20114,30001,30109,30114)
all$size_num[sizeCode == 34 & productGroup == 1237 & colorCode %in% g2] <- -2/3
all$size_num[sizeCode == 32 & productGroup == 1237 & colorCode %in% g2] <- -1
all$size_num[sizeCode == 34 & productGroup == 1237 & colorCode == 10110 & rrp == 79.99] <- -2/3
all$size_num[sizeCode == 32 & productGroup == 1237 & colorCode == 10110 & rrp == 79.99] <- -1


all$size_num[sizeCode == 33] <- .8
all$size_num[sizeCode == 31] <- .4
all$size_num[sizeCode == 30] <- .2
all$size_num[sizeCode == 29] <- 0
all$size_num[sizeCode == 28] <- -.2
all$size_num[sizeCode == 27] <- -.4
all$size_num[sizeCode == 26] <- -.6
all$size_num[sizeCode == 25] <- -.8
all$size_num[sizeCode == 24] <- -1
all$size_num[sizeCode == 34 & productGroup == 2] <- 1
all$size_num[sizeCode == 32 & productGroup == 2] <- .6
g2c <- c(10220:10227,10302,10303,10304,10306,10307,10308,10310,10311,10364,10367)
all$size_num[sizeCode == 34 & productGroup == 1237 & colorCode %in% g2c] <- 1
all$size_num[sizeCode == 32 & productGroup == 1237 & colorCode %in% g2c] <- .6
all$size_num[sizeCode == 34 & productGroup == 1237 & colorCode == 10110 & rrp == 59.99] <- 1
all$size_num[sizeCode == 32 & productGroup == 1237 & colorCode == 10110 & rrp == 59.99] <- .6

all$extreme_size <- as.numeric(abs(all$size_num)==1)


### check
table(d$extreme_size,returnQuantity[1:nrow(train)])
all[productGroup == 1 & sizeCode == 32, c("sizeCode", "size_num","extreme_size")]
all[productGroup == 7, c("sizeCode", "size_num","extreme_size")]
summary(all$size_num)
all[is.na(productGroup)==TRUE, "size_num"]
all[is.na(productGroup)==TRUE, "sizeCode"]

# write
d <- all[1:nrow(train),c("size_num","extreme_size")]
names(d) <- c("size_num_train", "extreme_size_train")
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_SizeNum_train.csv", row.names = F)

d <- all[-(1:nrow(train)),c("size_num","extreme_size")]
names(d) <- c("size_num_test", "extreme_size_test")
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_SizeNum_class.csv", row.names = F)


#size_group
attach(all)

all$size_group=NULL
all$size_group[sizeCode == 100] <- 1
all$size_group[sizeCode == 95] <- 1
all$size_group[sizeCode == 90] <- 1
all$size_group[sizeCode == 85] <- 1
all$size_group[sizeCode == 80] <- 1
all$size_group[sizeCode == 75] <- 1

all$size_group[sizeCode == "XL"] <- 2
all$size_group[sizeCode == "L"] <- 2
all$size_group[sizeCode == "M"] <- 2
all$size_group[sizeCode == "S"] <- 2
all$size_group[sizeCode == "XS"] <- 2
all$size_group[sizeCode == "A"] <- 3
all$size_group[sizeCode == "I"] <- 4


all$size_group[sizeCode == 44] <- 5
all$size_group[sizeCode == 42] <- 5
all$size_group[sizeCode == 40] <- 5
all$size_group[sizeCode == 38] <- 5
all$size_group[sizeCode == 36] <- 5
g1 <- c(1,3:9,13,14,15,17,26,50,1214,1220,1221,1222,1225,1230,1231,1234,1236)
all$size_group[sizeCode == 34 & productGroup %in% g1] <- 5
all$size_group[sizeCode == 32 & productGroup %in% g1] <- 5
g2 <- c(10001,10107,10109,10112,10114:10118,10186,10194,10294,10313,20001,20114,30001,30109,30114)
all$size_group[sizeCode == 34 & productGroup == 1237 & colorCode %in% g2] <- 5
all$size_group[sizeCode == 32 & productGroup == 1237 & colorCode %in% g2] <- 5
all$size_group[sizeCode == 34 & productGroup == 1237 & colorCode == 10110 & rrp == 79.99] <- 5
all$size_group[sizeCode == 32 & productGroup == 1237 & colorCode == 10110 & rrp == 79.99] <- 5


all$size_group[sizeCode == 33] <- 6
all$size_group[sizeCode == 31] <- 6
all$size_group[sizeCode == 30] <- 6
all$size_group[sizeCode == 29] <- 6
all$size_group[sizeCode == 28] <- 6
all$size_group[sizeCode == 27] <- 6
all$size_group[sizeCode == 26] <- 6
all$size_group[sizeCode == 25] <- 6
all$size_group[sizeCode == 24] <- 6
all$size_group[sizeCode == 34 & productGroup == 2] <- 6
all$size_group[sizeCode == 32 & productGroup == 2] <- 6
g2c <- c(10220:10227,10302,10303,10304,10306,10307,10308,10310,10311,10364,10367)
all$size_group[sizeCode == 34 & productGroup == 1237 & colorCode %in% g2c] <- 6
all$size_group[sizeCode == 32 & productGroup == 1237 & colorCode %in% g2c] <- 6
all$size_group[sizeCode == 34 & productGroup == 1237 & colorCode == 10110 & rrp == 59.99] <- 6
all$size_group[sizeCode == 32 & productGroup == 1237 & colorCode == 10110 & rrp == 59.99] <- 6

### check
all[productGroup == 1 & sizeCode == 32, c("sizeCode", "size_group")]
all[productGroup == 7, c("sizeCode", "size_group")]
summary(all$size_group)
all[is.na(productGroup)==TRUE, "size_group"]
all[is.na(productGroup)==TRUE, "sizeCode"]

# write
d <- all[1:nrow(train),c("size_group")]
names(d) <- c("size_group_train")
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_SizeGroup_train.csv", row.names = F)

d <- all[-(1:nrow(train)),c("size_group")]
names(d) <- c("size_group_test")
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_SizeGroup_class.csv", row.names = F)



#### Recheck

size_num_trn <- read.table("keguoh_SizeNum_train.csv", header = T, sep = ",")
size_num_cls <- read.table("keguoh_SizeNum_class.csv", header = T, sep = ",")
names(size_num_trn)<-c("size_num", "extreme_size")
names(size_num_cls)<-c("size_num", "extreme_size")
paymentMethod_per_customer_trn <- read.table("keguoh_paymentMethod_per_customer_train.csv", header = T, sep = ",")
paymentMethod_per_customer_cls <- read.table("keguoh_paymentMethod_per_customer_class.csv", header = T, sep = ",")
names(paymentMethod_per_customer_cls) <- "paymentMethod_per_customer"
names(paymentMethod_per_customer_trn) <- "paymentMethod_per_customer"

size_num <- rbind(size_num_trn, size_num_cls)
paymentMethod_per_customer <- rbind(paymentMethod_per_customer_trn, paymentMethod_per_customer_cls)
head(size_num)
head(paymentMethod_per_customer)

d <- data.frame(size_num = size_num[(1:nrow(train)),c("size_num")], paymentMethod_per_customer = paymentMethod_per_customer[(1:nrow(train)),])
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_size and paymentMehtod_train.csv", row.names = F)
d <- data.frame(size_num = size_num[-(1:nrow(train)),c("size_num")], paymentMethod_per_customer = paymentMethod_per_customer[-(1:nrow(train)),])
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_size and paymentMehtod_class.csv", row.names = F)

d <- data.frame(extreme_size = size_num[(1:nrow(train)),c("extreme_size")])
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_extreme size_train.csv", row.names = F)
d <- data.frame(extreme_size = size_num[-(1:nrow(train)),c("extreme_size")])
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/keguoh_extreme size_class.csv", row.names = F)
head(d,200)
head(class$sizeCode,200)
