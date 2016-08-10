###get the data
train1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v03/train.csv", header=T, sep=",")
test1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v03/test.csv", header=T, sep=",")

library(ggplot2)

library(e1071)
library(randomForest)
gc()
library(rJava)
options( java.parameters = "-Xmx7g" )
library(extraTrees)

train0<-train1
train1[is.na(train1)] <- 0
train1$returnQuantity<-as.factor(train1$returnQuantity)
summary(train1$returnQuantity)

forest.model_extra = extraTrees(train1[,-c(1)],train1[,c(1)],ntree=800)


a<-as.factor(test1$returnQuantity)
summary(a)
return<-predict(forest.model_extra,newdata = test1[,-1])
summary(return)
sum(abs(as.numeric(a)-as.numeric(return)))/117779
#0.3101996



###get the data
train1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v03/train.csv", header=T, sep=",")
test1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v03/test.csv", header=T, sep=",")

library(ggplot2)

library(e1071)
library(randomForest)
gc()
library(rJava)
options( java.parameters = "-Xmx7g" )
library(extraTrees)

train0<-train1
train1[is.na(train1)] <- 0
train1$returnQuantity<-as.factor(train1$returnQuantity)
summary(train1$returnQuantity)

forest.model_extra = extraTrees(train1[,-c(1)],train1[,c(1)],ntree=500)


a<-as.factor(test1$returnQuantity)
summary(a)
return<-predict(forest.model_extra,newdata = test1[,-1])
summary(return)
sum(abs(as.numeric(a)-as.numeric(return)))/117779
#0.3101996