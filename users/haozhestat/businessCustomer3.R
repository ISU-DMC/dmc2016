library(dplyr)
library(plyr)

data.path <- "~/Dropbox/projects/DMC2016/rawData/"
train <- read.table(paste0(data.path,"orders_train.txt"),sep=";",header=TRUE)
class <- read.table(paste0(data.path,"orders_class.txt"),sep=";",header=TRUE)
train.date <- read.csv(paste0(data.path,"mxjki_date/mxjki_date_train.csv"),header=TRUE)
class.date <- read.csv(paste0(data.path,"mxjki_date/mxjki_date_class.csv"),header=TRUE)


train$customerID <- as.character(train$customerID)
class$customerID <- as.character(class$customerID)

data <- rbind(train[,-15],class)
data.price <- ddply(data,.(customerID),summarise,totalPrice=sum(quantity*price))

cutoff <- quantile(data.price$totalPrice,probs=c(0.95))

data$businessCustomer3 <- 0

data$businessCustomer3[data$customerID %in% data.price$customerID[data.price$totalPrice>=cutoff]] <- 1

write.csv(data.frame(businessCustomer3=data$businessCustomer3[1:nrow(train)]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_businessCustomer3_train.csv",row.names=FALSE)
write.csv(data.frame(businessCustomer3=data$businessCustomer3[(nrow(train)+1):(nrow(train)+nrow(class))]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_businessCustomer3_class.csv",row.names=FALSE)

data$totalPrice <- NA
for(index in 1:nrow(data.price))
  a <- Sys.time()
  data$totalPrice[data$customerID== data.price$customerID[index]] <- data.price$totalPrice[index]
print(Sys.time()-a)
  print(index)
}

