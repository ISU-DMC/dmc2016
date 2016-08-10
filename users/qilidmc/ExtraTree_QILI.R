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
# fit the model, the most important parameters are ntree and numRandomCuts,
# I suggest to use ntree=1000, numRandomCuts =1 or 3.
forest.model_extra = extraTrees(train1[,-c(1)],train1[,c(1)],ntree=1000,numRandomCuts =3)

a<-as.factor(test1$returnQuantity)
summary(a)
# predict the result
return<-predict(forest.model_extra,newdata = test1[,-1])
summary(return)


sum(abs(as.numeric(a)-as.numeric(return)))/as.numeric(length(test1$returnQuantity))
#0.3068281
# write the results
return<-as.data.frame(return)
write.csv(return, file = "/Users/LiQi/Desktop/raw_data/qili_predict.csv")

##############################################################################

# if you want to do two level predictions
train1$return[as.numeric(train1$returnQuantity)>1]<-1
train1$return<-as.factor(train1$return)
summary(train1$return)

# put the demention of new train as n,
n<-dim(train1)[2]
forest.model_extra = extraTrees(train1[,-c(1,n)],train1[,c(n)],ntree=1000,numRandomCuts =3)


