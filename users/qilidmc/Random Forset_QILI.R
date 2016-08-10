###get the train and test data
train1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v08/train.csv", header=T, sep=",")
test1 <- read.table("/Users/LiQi/Desktop/featureMatrix_v08/test.csv", header=T, sep=",")


## if you just want to use some most important feature, do the following code
imp <- read.table("/Users/LiQi/Desktop/featureMatrix_v05b/imp.csv", header=T, sep=",")
var<-as.vector(imp[1:300,1])
train1<-train1[,var]
test1<-test1[,var]


##library and options
library(e1071)
library(randomForest)
gc()
library(rJava)
options( java.parameters = "-Xmx8g" )
library(extraTrees)


# deal with the NA, I set NA to 0
train1[is.na(train1)] <- 0
# you could also do train1<-na.omit(train1)

train1$returnQuantity<-as.factor(train1$returnQuantity)
summary(train1$returnQuantity)
# fit the model, the most important parameters are ntree,
# I suggest to use ntree=1000,
forest.model<-randomForest(returnQuantity ~ ., data=train1, ntree=1000,
             keep.forest=FALSE, importance=TRUE)

a<-as.factor(test1$returnQuantity)
summary(a)
# predict the result
return<-predict(forest.model,newdata = test1[,-1])
summary(return)

###get the important features
importance(forest.model)
importance(forest.model, type=1)

sum(abs(as.numeric(a)-as.numeric(return)))/as.numeric(length(test1$returnQuantity))
#0.3068281
# write the results
return<-as.data.frame(return)
write.csv(return, file = "/Users/LiQi/Desktop/raw_data/qili_predict.csv")

##############################################################################
