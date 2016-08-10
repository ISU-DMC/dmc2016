library(randomForest)
library(foreach)
library(doParallel)

c1=0.5
c2=0.5

train<-read.csv("train.csv",header=T)

test<-read.csv("test.csv",header=T)

#replace NA with 0 in test
test[is.na(test)]=0
train[is.na(train)]=0
#make the response to be factor
train[,1]=as.factor(train[,1])

pick=floor((ncol(train)-1)/3*c1)
Nnode=floor(5*c2)

cores <- 16

cl <- makePSOCKcluster(cores)
registerDoParallel(cl)
model.forest <- foreach(ntree=rep(60, cores), .combine=combine,.packages='randomForest') %dopar% randomForest(train[,-1],train[,1] ,ntree=ntree ,mtry=pick,nodesize=Nnode, importance =T)
stopCluster(cl)


binary=predict(model.forest,newdata=test[,-1])
continuous=predict(model.forest,newdata=test[,-1],type="prob")
y_hat=data.frame(binary,continuous)

write.csv(y_hat,"prediction16.csv",row.names=F)








