setwd("~/Dropbox/projects/DMC2016/featureMatrix")


########### logistic ridge regression
library("glmnet")

train <- read.table("featureMatrix_v03b/train.csv",header=TRUE,sep=",")
class <- read.table("featureMatrix_v03b/test.csv",header=TRUE,sep=",")

train[is.na(train)] <- 0
class[is.na(class)] <- 0
train$returnQuantity[train$returnQuantity>1] <- 1

opt.lambda <- cv.glmnet(as.matrix(train[,-1]),y=as.matrix(train$returnQuantity),family="binomial",alpha=0)
opt.lambda$lambda.min
logist.ridge <- glmnet(as.matrix(train[,-1]),y=as.matrix(train$returnQuantity),family="binomial",lambda=opt.lambda$lambda.min,alpha=0)
pred.link <- predict.glmnet(logist.ridge,type="link",newx=as.matrix(class[,-1]))
pred.ridge <- as.numeric((1-1/(exp(pred.link)+1))>=0.5)
mean(abs(pred.ridge-class[,1]))

write.csv(as.matrix(logist.ridge$beta),file="haozhe_logisticRidge_v03b.csv")

##################### logistic lasso regression
library("glmnet")

train <- read.table("featureMatrix_v01b/train.csv",header=TRUE,sep=",")
class <- read.table("featureMatrix_v01b/test.csv",header=TRUE,sep=",")

train[is.na(train)] <- 0
class[is.na(class)] <- 0
train$returnQuantity[train$returnQuantity>1] <- 1

opt.lambda <- cv.glmnet(as.matrix(train[,-1]),y=as.matrix(train$returnQuantity),family="binomial",alpha=1)
opt.lambda$lambda.min
logist.lasso <- glmnet(as.matrix(train[,-1]),y=as.matrix(train$returnQuantity),family="binomial",lambda=opt.lambda$lambda.min,alpha=1)
pred.link <- predict.glmnet(logist.lasso ,type="link",newx=as.matrix(class[,-1]))
pred.lasso <- as.numeric((1-1/(exp(pred.link)+1))>=0.5)
mean(abs(pred.lasso-class[,1]))

write.csv(as.matrix(logist.lasso$beta),file="haozhe_logisticLasso_v01b.csv")

############ SVM
library(e1071)
train <- read.table("featureMatrix_v01/train.csv",header=TRUE,sep=",")
class <- read.table("featureMatrix_v01/test.csv",header=TRUE,sep=",")
train[is.na(train)] <- 0
class[is.na(class)] <- 0
train$returnQuantity[train$returnQuantity>1] <- 1
train$returnQuantity <- as.factor(train$returnQuantity)
train.svm <- svm(returnQuantity ~ ., data=train, cross = 5)
svm.pred <- predict(train.svm, newdata = class)
plot(density(svm.pred))
trun.svm <- svm.pred>0.5
mean(abs(trun.svm-class[,1]))
