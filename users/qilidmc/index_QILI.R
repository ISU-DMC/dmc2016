###get the data
train_raw <- read.table("/Users/LiQi/Desktop/raw_data/orders_train.txt", header=T, sep=";")
#test1 <- read.table("/Users/LiQi/Desktop/raw_data/orders_class.txt", header=T, sep=";")


require("lubridate")

train_raw$orderMonth <- month(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderYear <- year(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))

# train subset for 789
train_789<-subset(train_raw,train_raw$orderMonth >=7& train_raw$orderMonth <=9 & train_raw$orderYear=="2014")
summary(train_789)
# train subset for 101112
train_101112<-subset(train_raw, train_raw$orderMonth >=10 & train_raw$orderYear=="2014" )
summary(train_101112)

# rest train
train_rest1<-subset(train_raw,train_raw$orderMonth<=6 & train_raw$orderYear=="2014")
summary(train_rest1)
train_rest2<-subset(train_raw,train_raw$orderMonth<=9 & train_raw$orderYear=="2015")
summary(train_rest2)

train_rest<-rbind(train_rest1,train_rest2)
summary(train_rest)

set.seed(0)
##group by orderID
require(dplyr)

length(unique(train_789$orderID))

A<-round(length(unique(train_789$orderID))*0.25)

test<-sample(unique(train_789$orderID),A)
print(test)

train_111<-subset(train_789,!train_789$orderID %in% test)
train_qili<-as.data.frame(row.names(train_111))

hist_789<-subset(train_789,train_789$orderID %in% test)

hist<-rbind(train_rest,hist_789)
hist_qili_789<-as.data.frame(row.names(hist))
names(hist_qili_789)<-"row"

length(unique(hist_qili_789$row))

#################
set.seed(0)
length(unique(train_101112$orderID))

A<-round(length(unique(train_101112$orderID))*0.25)

test<-sample(unique(train_101112$orderID),A)
print(test)

train_111<-subset(train_101112,train_101112$orderID %in% test)
test_qili<-as.data.frame(row.names(train_111))

