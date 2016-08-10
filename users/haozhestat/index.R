setwd("~/Dropbox/projects/DMC2016/rawData/")

train <- read.table("orders_train.txt",sep=";",header=TRUE)
class <- read.table("orders_class.txt",sep=";",header=TRUE)
index_train <- read.csv("index_train.csv")
index_test <- read.csv("index_test.csv")
index_historical <- read.csv("index_historical.csv")

index_train <- index_train[,1]
index_test <- index_test[,1]
index_historical <- index_historical[,1]

#nrow(train[c(index_train,index_test),])

#length(intersect(as.character(unique(class$customerID)),as.character(unique(train$customerID))))/length(unique(class$customerID))

newtrain <- train[c(index_train,index_test),]
length(index_train)/length(index_test)
nrow(train)/nrow(class)

set.seed(12345)
totalindex <- c(index_train,index_test)
newcustomerIDindex <- sample(1:length(unique(newtrain$customerID)),floor(length(unique(newtrain$customerID))*0.1),replace=FALSE)
newindex <- totalindex[which(as.character(newtrain$customerID) %in% newtrain$customerID[newcustomerIDindex])]
oldindex <- setdiff(totalindex,newindex)
ratio_samplesize <- length(index_train)/length(index_test)
num_train <- floor(ratio_samplesize*(length(oldindex)+length(newindex))/(1+ratio_samplesize))
new_index_train <- sample(oldindex,num_train,replace=FALSE)
new_index_test <- c(setdiff(oldindex,new_index_train),newindex)
length(new_index_train)+length(new_index_test)
length(totalindex)

write.table(new_index_train,file="haozhe_index_train.csv",col.names=FALSE,row.names=FALSE,quote=FALSE)
write.table(new_index_test,file="haozhe_index_test.csv",col.names=FALSE,row.names=FALSE,quote=FALSE)
write.table(data.frame(index_historical),file="haozhe_index_historical.csv",col.names=FALSE,row.names=FALSE,quote=FALSE)

sum((c(new_index_train,new_index_test) %in% c(index_train,index_test)))
