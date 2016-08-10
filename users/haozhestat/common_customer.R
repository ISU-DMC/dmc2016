library(dplyr)
library(plyr)

data.path <- "C:/Users/haozhe/Documents/GitHub/dmc2016/data/raw_data/"
train <- read.table(paste0(data.path,"orders_train.txt"),sep=";",header=TRUE)
class <- read.table(paste0(data.path,"orders_class.txt"),sep=";",header=TRUE)
train$customerID <- as.character(train$customerID)
class$customerID <- as.character(class$customerID)

train.quantity <- ddply(train,.(customerID),summarise,articleQuantity=sum(quantity))
class.quantity <- ddply(class,.(customerID),summarise,articleQuantity=sum(quantity))

train$businessCustomer <- 0
index <- which(train.quantity$articleQuantity>100)
for(i in index){
  train[which(train$customerID==train.quantity[i,1]),"businessCustomer"] <- 1
  print(i)
}

class$businessCustomer <- 0
index <- which(class.quantity$articleQuantity>100)
for(i in index){
  class[which(class$customerID==class.quantity[i,1]),"businessCustomer"] <- 1
  print(i)
}

write.csv(data.frame(businessCustomer=train$businessCustomer),file=paste0(data.path,"haozhe_businessCustomer_train.csv"),row.names=FALSE)
write.csv(data.frame(businessCustomer=class$businessCustomer),file=paste0(data.path,"haozhe_businessCustomer_class.csv"),row.names=FALSE)

########################################################################
common.customer <- intersect(unique(train$customerID),unique(class$customerID))
length(common.customer )/length(unique(class$customerID))
#58% customers have previous record
subset(train,customerID==common.customer[1]&productGroup==3)
subset(class,customerID==common.customer[1])

plot(train$paymentMethod,train$returnQuantity)



which(train$quantity>10000)
table(train$customerID)[which(table(train$customerID)>100)]

table(class$customerID)[which(table(class$customerID)>100)]

businessCustomer
private customer

allcustomer <- unique(train$customerID)
train$businessCustomer <- 0
for(i in 1:length(allcustomer)){
  tmp <- train[train$customerID==allcustomer[i],]
  if(nrow(tmp)>50){
    if(max(table(tmp$articleID))>50){
      train[train$customerID==allcustomer[i],"businessCustomer"] <- 1
    }
  }
  print(i)
}



