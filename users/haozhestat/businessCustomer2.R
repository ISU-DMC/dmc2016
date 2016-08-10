library(dplyr)
library(plyr)

data.path <- "~/Dropbox/projects/DMC2016/rawData/"
train <- read.table(paste0(data.path,"orders_train.txt"),sep=";",header=TRUE)
class <- read.table(paste0(data.path,"orders_class.txt"),sep=";",header=TRUE)

train$customerID <- as.character(train$customerID)
class$customerID <- as.character(class$customerID)

data <- rbind(train[,-ncol(train)],class)

data.articlenum <- ddply(data,.(customerID),summarise,articlenum=length(unique(articleID)))
str(data.articlenum)
sum(!(data.articlenum[,1]==data.quantity[,1]))
data.quantity$avequantity <- data.quantity[,2]/data.articlenum[,2]

data$businessCustomer2 <- 0
index <- which(data.articlenum$articlenum>50)
for(i in index){
  data[which(data$customerID==data.articlenum[i,1]),"businessCustomer2"] <- 1
}


write.csv(data.frame(businessCustomer2=data$businessCustomer2[1:nrow(train)]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_businessCustomer2_train.csv",row.names=FALSE,quote=FALSE)
write.csv(data.frame(businessCustomer2=data$businessCustomer2[(nrow(train)+1):(nrow(train)+nrow(class))]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_businessCustomer2_class.csv",row.names=FALSE,quote=FALSE)


table(data$businessCustomer2)
table(data$businessCustomer2[1:nrow(train)])
table(data$businessCustomer2[(nrow(train)+1):(nrow(train)+nrow(class))])

