library(dplyr)
library(plyr)

data.path <- "~/Dropbox/projects/DMC2016/rawData/"
train <- read.table(paste0(data.path,"orders_train.txt"),sep=";",header=TRUE)
class <- read.table(paste0(data.path,"orders_class.txt"),sep=";",header=TRUE)
train.date <- read.csv(paste0(data.path,"mxjki_date/mxjki_date_train.csv"),header=TRUE)
class.date <- read.csv(paste0(data.path,"mxjki_date/mxjki_date_class.csv"),header=TRUE)
train <- cbind(train,train.date)
class <- cbind(class,class.date)
train$articleID <- as.character(train$articleID)
class$articleID <- as.character(class$articleID)

data <- rbind(train[,-15],class)
firstday_articleID <- ddply(data,.(articleID),summarise,firstday=min(orderDate_day_of_total))
newdata <- merge(data,firstday_articleID)
newdata$TimeArticleID_firstday <- newdata$orderDate_day_of_total-newdata$firstday

write.csv(data.frame(TimeArticleID_firstday=newdata$TimeArticleID_firstday[1:nrow(train)]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_TimeArticleIDfirstday_train.csv",row.names=FALSE)
write.csv(data.frame(TimeArticleID_firstday=newdata$TimeArticleID_firstday[(nrow(train)+1):nrow(data)]),
          file="~/Dropbox/projects/DMC2016/outputFiles/haozhe_TimeArticleIDfirstday_class.csv",row.names=FALSE)

newdata$TimeArticleID_firstday[newdata$articleID=="i1000008"]
