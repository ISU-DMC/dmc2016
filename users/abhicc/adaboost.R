library(adabag)
#change the version of the feature matrix as it is updated
train=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/data/feature_matrix/featureMatrix_v03b/train.csv",header=TRUE)
test=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/data/feature_matrix/featureMatrix_v03b/test.csv",header=TRUE)

colnames(train)[colSums(is.na(train)) > 0]
train[is.na(train)]=0
sum(is.na(train))
#[1] "discountProp"       "rrp"               
#[3] "unit_price_min_avg" "discountProp.1"    
#nacols <- function(x){
#   y <- sapply(x, function(xx)any(is.na(xx)))
#   names(y[y])
# }  
#sum(is.na(train$discountProp))
train$returnQuantity=as.factor(train$returnQuantity)
#train=train[,-1]

boost=boosting(returnQuantity~.,data=train,boos=TRUE,mfinal=5,coeflearn='Breiman')
errorevol(boost,train)
summary(boost)
boost$trees
boost$weights
boost$importance
pred=predict(boost,test[,-1])
t1<-boost$trees[[5]]
library(tree)
plot(t1)
text(t1,pretty=0)
test$pred=as.numeric(pred$class)
mae=mean(abs(test$returnQuantity-test$pred))
mae

############ RESULTS ##############
# v01   0.3528965  6 level response as factor, fill all NA's by 0, 8mins
# v01b  0.3587551  6 level response as factor, fill all NA's by 0, 10mins
# v02   0.322586   6 level response as factor, fill all NA's by 0, 15mins
# v02b  0.3216718  6 level response as factor, fill all NA's by 0, 20mins
# v03   0.3220863  6 level response as factor, fill all NA's by 0, >30mins
# v03b  0.3236995  6 level response as factor, fill all NA's by 0, >30mins