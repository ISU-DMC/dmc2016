######################### Logistic Regression ##########
########################################################
library(ISLR)
library(MASS)
library(class)
#setwd("/Users/rodrigoplazolaortiz/Desktop/Model_DCM 2016/hanye_train_test_V2")
setwd("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/FinalFeatureMatrix")

dat.train<-read.csv("featureMatrix_final_v2/train.csv",header=TRUE,sep=",")
dat.train[is.na(dat.train)]=0

dat.test<-read.csv("featureMatrix_final_v2/test.csv",header=TRUE,sep=",")
dat.test[is.na(dat.test)]=0

dat.class<-read.csv("featureMatrix_final_v2/class.csv",header=TRUE,sep=",")
dat.class[is.na(dat.class)]=0


###### Logistic regression for 0-1
train=rbind(dat.train,dat.test)
train.01=train
dat.class.01=dat.class

#dat.test.01$returned<-as.numeric(dat.test.01$returnQuantity>0)

train.01$returned<-as.numeric(train.01$returnQuantity>0)
train.01<-train.01[,-1]

lr.train.01<-glm(returned~.,family=binomial,data=train.01)

#### We can see the  significant variables here
summary(lr.train.01)

#contrasts(dat.train.01$returnQuantity)

pre.lr<-as.numeric(predict(lr.train.01,newdata=dat.class.01,type="response")>0.5)
pre.cont.lr<-as.numeric(predict(lr.train.01,newdata=dat.class.01,type="response"))
pre.lr[dat.class.01$quantity==0]=0

#diff=pre.lr-dat.test.01$returnQuantity
#MAE.log=sum(abs(diff)) /length(diff)
#MAE.log     # This is the prediction error
#0.3049201
pred=cbind(pre.lr,pre.cont.lr)
write.csv(pred,file="featureMatrix_final_v2/predictions_final.csv")
