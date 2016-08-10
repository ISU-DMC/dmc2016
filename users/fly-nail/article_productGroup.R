install.packages('xgboost')
install.packages('ggplot2')
install.packages('dplyr')
install.packages('lubridate')

library(ggplot2)
library(tcltk)
library(e1071)
library(randomForest)
library(xgboost)
library(dplyr)
library(lubridate)



train_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_train.csv")
test_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_test.csv")

write.csv(train_raw, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/train.csv",row.names = FALSE)
write.csv(test_raw, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/test.csv",row.names = FALSE)


train_raw<-train_raw[,-c(16)]

total_raw <- rbind(train_raw, test_raw)

total_raw$article_t_h <- substr(total_raw$articleID,5,6)
total_raw$article_number_4<-substr(total_raw$articleID,5,5)
total_raw$article_number_hundred<-substr(total_raw$articleID,6,8)
total_raw$article_number<-substr(total_raw$articleID,5,10)
write.csv(total_raw, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/total.csv", row.names = FALSE)





train_raw$article_number<-substr(train_raw$articleID,2,10)
train_raw$article_number_4<-substr(train_raw$articleID,5,5)
train_raw$article_number_hundred<-substr(train_raw$articleID,6,8)
train_raw$article_t_h <- substr(train_raw$articleID,5,6)


test_raw$article_number<-substr(test_raw$articleID,2,10)
test_raw$article_number_4<-substr(test_raw$articleID,5,5)
test_raw$article_number_hundred<-substr(test_raw$articleID,6,8)
test_raw$article_t_h <- substr(test_raw$articleID,5,6)

train_raw<-train_raw[,-c(1,16)]
test_raw<-test_raw[,-c(1,16)]
total_raw<-total_raw[,-c(17)]

train_raw$productGroup_article_t_h<- paste(train_raw$productGroup, train_raw$article_t_h, sep="")
test_raw$productGroup_article_t_h<- paste(test_raw$productGroup, test_raw$article_t_h, sep="")
total_raw$productGroup_article_t_h<- paste(total_raw$productGroup, total_raw$article_t_h, sep="")


productGroup_article_t_h_in_train_raw <- train_raw[,(18:19)]
productGroup_article_t_h_in_test_raw <- test_raw[,(18:19)]

write.csv(productGroup_article_t_h_in_train_raw, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/productGroup_article_t_h_in_train_raw.csv", row.names = FALSE)
write.csv(productGroup_article_t_h_in_test_raw, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/productGroup_article_t_h_in_test_raw.csv", row.names = FALSE)


##### create sales frequency of productGroup_article_t_h by month

total_raw$orderMonth <- month(as.POSIXlt(total_raw$orderDate, format="%Y-%m-%d"))
total_raw$orderYear <- year(as.POSIXlt(total_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderMonth <- month(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderYear <- year(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
test_raw$orderMonth <- month(as.POSIXlt(test_raw$orderDate, format="%Y-%m-%d"))
test_raw$orderYear <- year(as.POSIXlt(test_raw$orderDate, format="%Y-%m-%d"))



sales_productGroup_article_t_h = total_raw %>% group_by(productGroup_article_t_h, orderMonth, orderYear) %>% summarise(productFreq = length(productGroup_article_t_h)) 
total_raw_trail <- left_join(total_raw,sales_productGroup_article_t_h,by=c("productGroup_article_t_h","orderMonth","orderYear"))
train_raw_trail <- left_join(train_raw,sales_productGroup_article_t_h,by=c("productGroup_article_t_h","orderMonth","orderYear"))
test_raw_trail <- left_join(test_raw,sales_productGroup_article_t_h,by=c("productGroup_article_t_h","orderMonth","orderYear"))

total_raw_trail<-total_raw_trail[,-c(17)]



productFreq_productGroup_article_t_h_trian <- train_raw_trail[, 21]

productFreq_productGroup_article_t_h_test <- test_raw_trail[, 21]

write.csv(productFreq_productGroup_article_t_h_trian, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/productFreq_vs_productGroup_article_t_h_train.csv", row.names = FALSE)
write.csv(productFreq_productGroup_article_t_h_test, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/productFreq_vs_productGroup_article_t_h_test.csv", row.names = FALSE)

table(total_raw$productGroup, total_raw$sizeCode)




sub_product_group_17 <- total_raw[which(total_raw$productGroup == 17),]
new_group = sub_product_group_17 %>% group_by(article_t_h, orderDate) %>% summarise(freq = length(article_t_h)) 
ggplot(new_group, aes(x = orderDate, y = freq, group = article_t_h)) + geom_point()+ geom_line(aes(color = article_t_h)) 
sub_product_group_17$orderMonth <- month(as.POSIXlt(sub_product_group_17$orderDate, format="%Y-%m-%d"))
group_month <-sub_product_group_17 %>% group_by(article_t_h, orderMonth) %>% summarise(freq = length(article_t_h)) 
p_productGroup_17 <- ggplot(group_month, aes(x = orderMonth, y = freq)) + geom_point()+ geom_line(aes(color = article_t_h))+facet_wrap(~article_t_h)






