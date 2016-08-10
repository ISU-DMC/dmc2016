
library(MASS)
########### featureMatrix_v03b ############
train = read.csv('~/dmc2016/data/feature_matrix/featureMatrix_v03b/train.csv')
test = read.csv('~/dmc2016/data/feature_matrix/featureMatrix_v03b/test.csv')
str(train)

#no 0 columns to remove 
train2<-train
test2<-test
#make returnQuantity binary
train2$returnQuantity[train2$returnQuantity>=1]<-1
length(train$returnQuantity)
length(which(train2$returnQuantity>=1))
length(which(train2$returnQuantity==0))

# fit LDA 
lda.fit<- lda(returnQuantity ~., data=train2, na.action=na.omit)
lda.class=predict(lda.fit, test2)$class

# fill NA with 0 in predictions 
lda.class[is.na(lda.class)] <- 0
table(lda.class, test2$returnQuantity)
length(lda.class)
length(test$returnQuantity)
#MAE 
mean(abs(as.numeric(as.character(lda.class)) - test$returnQuantity))
#0.3088751


########### featureMatrix_v03 ############
train = read.csv('~/dmc2016/data/feature_matrix/featureMatrix_v03/train.csv')
test = read.csv('~/dmc2016/data/feature_matrix/featureMatrix_v03/test.csv')
str(train)

#no 0 columns to remove 
train2<-train
test2<-test
#make returnQuantity binary
train2$returnQuantity[train2$returnQuantity>=1]<-1
length(train$returnQuantity)
length(which(train2$returnQuantity>=1))
length(which(train2$returnQuantity==0))

# fit LDA 
lda.fit<- lda(returnQuantity ~., data=train2, na.action=na.omit)
lda.class=predict(lda.fit, test2)$class

# fill NA with 0 in predictions 
lda.class[is.na(lda.class)] <- 0
table(lda.class, test2$returnQuantity)
length(lda.class)
length(test$returnQuantity)
#MAE 
mean(abs(as.numeric(as.character(lda.class)) - test$returnQuantity))
#0.3100383

########### featureMatrix_v02 ############

train = read.csv('~/documents/Features/featureMatrix_v02/train.csv')
test = read.csv('~/documents/Features/featureMatrix_v02/test.csv')

str(train)
#remove 0 column
summary(train[c(75)])
train2<-train[-c(75)]
test2<-test[-c(75)]


#make returnQuantity binary
train2$returnQuantity[train2$returnQuantity>=1]<-1
length(which(train2$returnQuantity>=1))
length(which(train2$returnQuantity==0))


# fit LDA 
lda.fit<- lda(returnQuantity ~., data=train2, na.action=na.omit)
lda.class=predict(lda.fit, test2)$class

# fill NA with 0 in predictions 
lda.class[is.na(lda.class)] <- 0
table(lda.class, test2$returnQuantity)
length(lda.class)
length(test$returnQuantity)
#MAE 
mean(abs(as.numeric(as.character(lda.class)) - test$returnQuantity))
#0.3107529

#try QDA
qda.fit<- qda(returnQuantity ~., data=train2, na.action=na.omit)
qda.class=predict(qda.fit, test2)$class
qda.class[is.na(qda.class)] <- 0
table(qda.class, test2$returnQuantity)
length(qda.class)
length(test$returnQuantity)
mean(abs(as.numeric(as.character(qda.class)) - test$returnQuantity))





########### featureMatrix_v01 ############

train = read.csv('~/documents/Features/featureMatrix_v01/train.csv')
test = read.csv('~/documents/Features/featureMatrix_v01/test.csv')

str(train2)
#remove 0 column
train2<-train[-c(19)]
test2<-test[-c(19)]
names(train2)

#make returnQuantity binary
train2$returnQuantity[train2$returnQuantity>=1]<-1
length(which(train2$returnQuantity>=1))
length(which(train2$returnQuantity==0))


# fit LDA 
lda.fit<- lda(returnQuantity ~., data=train2, na.action=na.omit)
lda.class=predict(lda.fit, test2)$class

# fill NA with 0 in predictions 
lda.class[is.na(lda.class)] <- 0
table(lda.class, test2$returnQuantity)
length(lda.class)
length(test$returnQuantity)
#MAE 
mean(abs(as.numeric(as.character(lda.class)) - test$returnQuantity))
# 0.3461236

#try qda
qda.fit<- qda(returnQuantity ~., data=train2, na.action=na.omit)
qda.class=predict(qda.fit, test2)$class
qda.class[is.na(qda.class)] <- 0
table(qda.class, test2$returnQuantity)
length(qda.class)
length(test$returnQuantity)
mean(abs(as.numeric(as.character(qda.class)) - test$returnQuantity))
# 0.38622

########## featureMatrix_v01b ############
train2<-NA
test2<-NA
lda.fit<-NA
lda.class<-NA

train = read.csv('~/documents/Features/featureMatrix_v01b/train.csv')
test = read.csv('~/documents/Features/featureMatrix_v01b/test.csv')
summary(train[c(19,43,49,55,57,28,36,54,56,58)])

#remove 0 columns
train2 <- train[-c(19,43,49,55,57,28,36,54,56,58)]
test2 <- test[-c(19,43,49,55,57,28,36,54,56,58)]

str(train2)

#make returnQuantity binary
train2$returnQuantity[train2$returnQuantity>=1]<-1
length(which(train2$returnQuantity>=1))
length(which(train2$returnQuantity==0))
names(train2)

#fit LDA 
lda.fit<- lda(returnQuantity ~., data=train2, na.action=na.omit)
lda.class=predict(lda.fit, test2)$class
lda.class[is.na(lda.class)] <- 0
table(lda.class, test2$returnQuantity)
length(lda.class)
length(test$returnQuantity)
mean(abs(as.numeric(as.character(lda.class)) - test$returnQuantity))
#[1] 0.345673

#fit QDA #doesnt work 
qda.fit<- qda(returnQuantity ~., data=train2, na.action=na.omit)
