setwd("~/Dropbox/projects/DMC2016/")

train <- read.table("rawData/orders_train.txt",sep=";",header=TRUE)
class <- read.table("rawData/orders_class.txt",sep=";",header=TRUE)

tmp1 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_timeBetween_train.csv",sep=",",header=TRUE)
tmp2 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_orders3_train.csv",sep=",",header=TRUE)
tmp3 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_orders2_train.csv",sep=",",header=TRUE)
tmp4 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_customerCounts_train.csv",sep=",",header=TRUE)
tmp5 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_customerBehavior_train.csv",sep=",",header=TRUE)

train.behaviour <- cbind(tmp1,tmp2,tmp3,tmp4,tmp5)
train <- cbind(train,train.behaviour)

tmp1 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_timeBetween_class.csv",sep=",",header=TRUE)
tmp2 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_orders3_class.csv",sep=",",header=TRUE)
tmp3 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_orders2_class.csv",sep=",",header=TRUE)
tmp4 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_customerCounts_class.csv",sep=",",header=TRUE)
tmp5 <- read.csv("rawData/epwalsh_customerBehaviour/epwalsh_customerBehavior_class.csv",sep=",",header=TRUE)

class.behaviour <- cbind(tmp1,tmp2,tmp3,tmp4,tmp5)
class <- cbind(class,class.behaviour)

library(cluster)
behaviour <- rbind(train.behaviour,class.behaviour)
for(i in 1:ncol(behaviour)){
  behaviour[is.na(behaviour[,i]),i] <- mean(behaviour[,i],na.rm=TRUE)
}
behaviour.stand <- data.frame(scale(behaviour))
clustCustomer <- kmeans(behaviour.stand,6)
table(clustCustomer$cluster)
write.csv(data.frame(clustCustomer6=clustCustomer$cluster[1:nrow(train)]),
          file="outputFiles/haozhe_clustCustomer6_train.csv",row.names=FALSE)
write.csv(data.frame(clustCustomer6=clustCustomer$cluster[(nrow(train)+1):(nrow(train)+nrow(class))]),
          file="outputFiles/haozhe_clustCustomer6_class.csv",row.names=FALSE)
