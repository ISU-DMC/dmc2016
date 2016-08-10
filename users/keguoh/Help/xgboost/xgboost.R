setwd("C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/featureMatrix_v01")
trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")

# analyse data
trn$returned <- as.numeric(trn$returnQuantity > 0)
tst$returned <- as.numeric(tst$returnQuantity > 0)

# 2. xgboost
library(xgboost)
# (1) simple xgboost
set.seed(8)
param <- list("objective" = "binary:logistic",booster = "gbtree",  "eval_metric" = "error")

# f-fold CV to find nrounds 
f<-5
trn1<-trn[sample(nrow(trn)),]  #Randomly shuffle the data
folds <- cut(seq(1,nrow(trn1)),breaks=f,labels=FALSE)
tst.err <- matrix(0, 7, f)  #Perform 10 fold cross validation
for (i in seq(80,320,40)) {
  for(k in 1:f){
    #Segement your data by fold using the which() function 
    testIndexes <- which(folds==k,arr.ind=TRUE)
    testData <- trn1[testIndexes, ]
    trainData <- trn1[-testIndexes, ]
    xgbmodel <- xgboost(data = as.matrix(trainData[, -c(1,24)]), params = param,
                        nrounds = i, label = trainData$returned, missing = NA)
    res <- predict(xgbmodel, newdata = data.matrix(testData[,-c(1,24)]), missing = NA)
    prdt.xg <- as.numeric(res > 0.5)
    tst.err[(i/40-1), k] <- 1 - mean(prdt.xg == testData$returnQuantity)  
  }
}

tst.err
which.min(apply(tst.err, 1, mean))
plot(seq(80,320,40), apply(tst.err, 1, mean), xlab = "nrounds", ylab = "mean of test errors")

i = 200 # nrounds by CV
xgbmodel <- xgboost(data = as.matrix(trn[,-c(1,24)]), params = param,
                    nrounds = i, label = trn$returned, missing = NA)
res <- predict(xgbmodel, newdata = data.matrix(tst[,-c(1,24)]), missing = NA)
prdt.xg <- as.numeric(res > 0.5)
tst.err <- 1 - mean(prdt.xg == tst$returnQuantity)  
tst.err                                                     #test error: 0.3461751

xgb.importance(names(trn)[-c(1,24)], model = xgbmodel)

# (2) different parameters

set.seed(8)
param <- list("objective" = "binary:logistic",booster = "gbtree",
              "eval_metric" = "error",colsample_bytree = 0.85, subsample = 0.95)
# f-fold CV to find nrounds 
f=5
trn2<-trn[sample(nrow(trn)),]  #Randomly shuffle the data
folds <- cut(seq(1,nrow(trn2)),breaks=f,labels=FALSE)
tst.err <- matrix(0, 3, f)  #Perform f-fold cross validation
for (i in seq(1100,1300,100)) {
  for(k in 1:f){
    #Segement your data by fold using the which() function 
    testIndexes <- which(folds==k,arr.ind=TRUE)
    testData <- trn2[testIndexes, ]
    trainData <- trn2[-testIndexes, ]
    xgbmodel <- xgboost(data = as.matrix(trainData[, -c(1,24)]), params = param,
                        nrounds = i, max.depth = 5, eta = 0.03,
                        label = trainData$returned, maximize = T, missing = NA)
    res <- predict(xgbmodel, newdata = data.matrix(testData[,-c(1,24)]), missing = NA)
    prdt.xg <- as.numeric(res > 0.5)
    tst.err[(i/100-10), k] <- 1 - mean(prdt.xg == testData$returnQuantity)  
  }
}
tst.err
which.min(apply(tst.err, 1, mean))
plot(seq(700,1300,100), apply(tst.err, 1, mean), xlab = "nrounds", ylab = "mean of test errors")

tst.err1

i = 1300 # nrounds by CV
xgbmodel <- xgboost(data = as.matrix(trn[,-c(1,24)]), params = param,
                    nrounds = i, max.depth = 5, eta = 0.03,
                    label = trn$returned, maximize = T, missing = NaN)
res <- predict(xgbmodel, newdata = data.matrix(tst[,-c(1,24)]), missing = NaN)
prdt.xg <- as.numeric(res > 0.5)
tst.err <- 1 - mean(prdt.xg == tst$returnQuantity)  
tst.err
#0.3380632 for 1300


