setwd("C:/Users/huangke/Documents/GitHub/dmc2016/data/raw_data")
train <- read.table("orders_train.txt", header = T, sep = ";")
class <- read.table("orders_class.txt", header = T, sep = ";")
class$returnQuantity <- 0
all <- rbind(train, class)
setwd("C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/Features")
all$ID <- 1:nrow(all)

date_train <- read.table("mxjki_date_train.csv", header = T, sep = ",")
date_class <- read.table("mxjki_date_class.csv", header = T, sep = ",")
date_all <- rbind(date_train, date_class)
all$day <- date_all$orderDate_day_of_total

timebtw_train <- read.table("epwalsh_timeBetween_train.csv", header = T, sep = ",")
timebtw_class <- read.table("epwalsh_timeBetween_class.csv", header = T, sep = ",")
timebtw_all <- rbind(timebtw_train, timebtw_class)
all$timebtw <- timebtw_all$time_between2
head(all)
all$customerID2 <- all$customerID
levels(all$customerID2) <- 1:length(unique(all$customerID2))
head(all$customerID2)

#1 week
attach(all)
idx1w <- which(all$timebtw <= 7)
all1w <- all[idx1w, ]
# levels(all1w$customerID) <- levels(customerID)[levels(customerID) %in% all1w$customerID]
# n_quantity <- matrix(0, nrow(all),5)
# for(j in c(7,14,30,91,182)){

for(i in idx){
  all$n_quantity_1w[i] <- sum(quantity[day %in% (day[i]-7):(day[i]-1) & customerID2 %in% c(customerID2[i])])
  print(i)
}

all1w$group1w <- paste(all1w$customerID , all1w$day)
attach(all1w)
length(unique(all1w$group1w))
system.time( expr = ( for(i in unique(group1w)){
  daytemp <- as.numeric(substr(i,10,nchar(i)))
  custemp <- substr(i,1,8)
  all1w$n_quantity_1w[group1w %in% c(i)] <- rep(sum(all$quantity[all$day %in% (daytemp-7):(daytemp-1) 
                                & all$customerID %in% c(custemp)]), sum(group1w %in% c(i)))
  print(i)
}))
# i = unique(all1w$customerID)[1]
all$n_quantity_1w <- 0
all$n_quantity_1w[idx1w] <- all1w$n_quantity_1w 
detach()


# 2 weeks
idx2w <- which(all$timebtw <= 14)
all2w <- all[idx2w, ]
all2w$group2w <- paste(all2w$customerID , all2w$day)
attach(all2w)
length(unique(group2w))
system.time( expr = ( for(i in unique(group2w)){
  daytemp <- as.numeric(substr(i,10,nchar(i)))
  custemp <- substr(i,1,8)
  all2w$n_quantity_2w[group2w %in% c(i)] <- rep(sum(all$quantity[all$day %in% (daytemp-14):(daytemp-1) 
                                                                 & all$customerID %in% c(custemp)]), sum(group2w %in% c(i)))
  print(i)
}))
all$n_quantity_2w <- 0
all$n_quantity_2w[idx2w] <- all2w$n_quantity_2w 

# 1 month
idx1m <- which(all$timebtw <= 30)
all1m <- all[idx1m, ]
all1m$group1m <- paste(all1m$customerID , all1m$day)
attach(all1m)
length(unique(group1m))
system.time( expr = ( for(i in unique(group1m)){
  daytemp <- as.numeric(substr(i,10,nchar(i)))
  custemp <- substr(i,1,8)
  all1m$n_quantity_1m[group1m %in% c(i)] <- rep(sum(all$quantity[all$day %in% (daytemp-30):(daytemp-1) 
                                                                 & all$customerID %in% c(custemp)]), sum(group1m %in% c(i)))
  print(i)
}))
all$n_quantity_1m <- 0
all$n_quantity_1m[idx1m] <- all1m$n_quantity_1m 


# 3 month
# all$n_price_3m <- 0
idx3m <- which(all$timebtw <= 91)
all3m <- all[idx3m, ]
all3m$group3m <- paste(all3m$customerID , all3m$day)
attach(all3m)
length(unique(group3m))
system.time( expr = ( for(i in unique(group3m)){
  daytemp <- as.numeric(substr(i,10,nchar(i)))
  custemp <- substr(i,1,8)
  all3m$n_quantity_3m[group3m %in% c(i)] <- rep(sum(all$quantity[all$day %in% (daytemp-91):(daytemp-1) 
                                                                 & all$customerID %in% c(custemp)]), sum(group3m %in% c(i)))
  # all3m$n_price_3m[group3m %in% c(i)] <- rep(sum(all$price[all$day %in% (daytemp-91):(daytemp-1) 
                                                                 # & all$customerID %in% c(custemp)]), sum(group3m %in% c(i)))
  print(i)
}))
detach()
all$n_quantity_3m <- 0
all$n_quantity_3m[idx3m] <- all3m$n_quantity_3m 


# 6 month
all$n_quantity_6m <- 0
all$n_price_6m <- 0
idx6m <- which(all$timebtw <= 182)
all6m <- all[idx6m, ]
all6m$group6m <- paste(all6m$customerID , all6m$day)
attach(all6m)
length(unique(all$customerID))
length(unique(group6m))
system.time( expr = ( for(i in unique(group6m)){
  daytemp <- as.numeric(substr(i,10,nchar(i)))
  custemp <- substr(i,1,8)
  all6m$n_quantity_6m[group6m %in% c(i)] <- rep(sum(all$quantity[all$day %in% (daytemp-182):(daytemp-1) 
                                                                 & all$customerID %in% c(custemp)]), sum(group6m %in% c(i)))
  # all6m$n_price_6m[group6m %in% c(i)] <- rep(sum(all$price[all$day %in% (daytemp-182):(daytemp-1) 
                                                                 # & all$customerID %in% c(custemp)]), sum(group6m %in% c(i)))
  print(i)
}))
detach()
unique(all6m$group6m)[220000]
all$n_quantity_6m[idx6m] <- all6m$n_quantity_6m 

#check
all[13930,]
all[187918,]
#write data files

d <- all[1:nrow(train), c("n_quantity_1w", "n_quantity_2w", "n_quantity_1m", "n_quantity_3m", "n_quantity_6m")]
write.csv(d, file = "C:/Users/yjiang1/Documents/GitHub/dmc2016/users/keguoh/keguoh_n_quantity_train.csv", row.names = F)
d <- all[-(1:nrow(train)), c("n_quantity_1w", "n_quantity_2w", "n_quantity_1m", 
                             "n_quantity_3m", "n_quantity_6m")]
write.csv(d, file = "C:/Users/yjiang1/Documents/GitHub/dmc2016/users/keguoh/keguoh_n_quantity_class.csv", row.names = F)



######### another more efficient way
ls=list(b="b")
length(ls)<-730
names(ls)<-1:730
for(i in 1:730){
  ls[[i]]<-1:length(unique(all$customerID2[which(all$day==i)]))
  print(i)
}
for(i in 1:730){
  names(ls[[i]])<-unique(all$customerID2[all$day%in%c(i)])
  print(i)
}
for(i in 1:730){
  alltemp <- all[all$day %in% c(i), ]
  for(j in 1:length(ls[[i]])){
    id <- which(alltemp$customerID2 %in% c(names(ls[[i]])[j]))
    ls[[i]][j] <- sum(alltemp$quantity[id])
  }
  print(i)
}


# 1w
ls1w <- ls
for(i in 1:730){
  alltemp <- all[all$day %in% ((i-7):(i-1)), ]
  for(j in 1:length(ls[[i]])){
    ls1w[[i]][j] <- sum(alltemp$quantity[alltemp$customerID2 %in% c(names(ls[[i]])[j])])
  }
  print(i)
}

all$n_quantity_1w <- 0
idx1w <- which(all$timebtw <= 7)
all1w <- all[idx1w, ]
nrow(all1w)
for(i in 1:nrow(all1w)){
  d <- all1w$day[i]
  c <- all1w$customerID2[i]
  all1w$n_quantity_1w[i] <- ls1w[[d]][c]
  print(i)
}
all$n_quantity_1w[idx1w] <- all1w$n_quantity_1w


# 9m
ls9m <- ls
for(i in 171:730){                                         #done with 171
  alltemp <- all[all$day %in% ((i-273):(i-1)), ]
  for(j in 1:length(ls[[i]])){
    ls9m[[i]][j] <- sum(alltemp$quantity[alltemp$customerID2 %in% c(names(ls[[i]])[j])])
  }
  print(i)
}


all$n_quantity_9m <- 0
idx9m <- which(all$timebtw <= 273) 
all9m <- all[idx9m, ]
nrow(all9m)
for(i in 1:nrow(all9m)){     
  d <- all9m$day[i]
  c <- all9m$customerID2[i]
  all9m$n_quantity_9m[i] <- ls9m[[d]][c]
  print(i)
}
all$n_quantity_9m[idx9m] <- all9m$n_quantity_9m
sum(is.na(all$n_quantity_9m))

d <- all[, c("n_quantity_9m")]
write.csv(d, file = "C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/9m.csv", row.names = F)
