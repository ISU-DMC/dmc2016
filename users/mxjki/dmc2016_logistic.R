setwd("~/Dropbox/dmc2016_mxjki/featureMatrix_v01")
library("xgboost")
library("Ckmeans.1d.dp")
library("DiagrammeR")
train=read.csv("train.csv",header=T)
test=read.csv("test.csv",header=T)

#llr_customerID all equals to 0 useless
unique(train$llr_customerID)

#remove llr_customerID
train=train[,-c(19)]
#fill NA by 0
train[is.na(train)]=0

#remove llr_customerID
test=test[,-c(19)]
#fill NA by 0
test[is.na(test)]=0

train$returned=as.numeric(train$returnQuantity>0)
train1=train[,-1]

mylogit <- glm(returned ~ ., data = train1, family = "binomial")
mylogit$coefficients

#transform the result to binary
predict_binary=as.numeric(predict(mylogit, newdata = test[,-1],type="response")>0.5)
predict_binary[test$quantity==0]=0

#measure model performance
diff=predict_binary-test$returnQuantity

MAE=sum(abs(diff))/length(diff)
MAE
