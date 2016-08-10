library(lubridate)
library(dplyr)


train_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_train.csv")
test_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_test.csv")

train_raw$orderMonth <- month(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderYear <- year(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
test_raw$orderMonth <- month(as.POSIXlt(test_raw$orderDate, format="%Y-%m-%d"))
test_raw$orderYear <- year(as.POSIXlt(test_raw$orderDate, format="%Y-%m-%d"))




sub_season_4_2014 <- subset(train_raw, orderMonth >=10 & orderMonth <=12 & orderYear ==2014)
sub_season_3_2014 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2014)
sub_season_1_2_2014 <- subset(train_raw, orderMonth >=1 & orderMonth <=6 & orderYear ==2014)
sub_season_1_2_3_2014 <- subset(train_raw, orderMonth >=1 & orderMonth <=9 & orderYear ==2014)


sub_season_historical<- subset(train_raw, (orderMonth >=1 & orderMonth <=6 & orderYear ==2014) | (orderMonth >=1 & orderMonth <=10 & orderYear ==2015))
sub_season_historical_2015<- subset(train_raw,  (orderMonth >=1 & orderMonth <=10 & orderYear ==2015))


#method 5
set.seed(0)
sub5_test_0.25 <- sub4_test_0.25
sub5_test_index <- sub5_test_0.25$X
sub5_test_index_minus_1 <- sub5_test_index-1


sub5_unique_train_0.5_ID<- unique(sub_season_3_2014$orderID)
sub5_train_0.5_ID <- sub5_unique_train_0.5_ID[sample(1:length(sub5_unique_train_0.5_ID), round(length(sub5_unique_train_0.5_ID)*0.5) )]
sub5_train_0.5 <- subset(sub_season_3_2014, sub_season_3_2014$orderID %in% sub5_train_0.5_ID)

set.seed(0)
sub5_unique_train_0.25_ID <- unique(sub_season_1_2_2014$orderID)
sub5_train_0.25_ID <- sub5_unique_train_0.25_ID[sample(1:length(sub5_unique_train_0.25_ID), round(length(sub5_unique_train_0.25_ID)*0.125) )]
sub5_train_0.25 <- subset(sub_season_1_2_2014, sub_season_1_2_2014$orderID %in% sub5_train_0.25_ID)

sub5_train_0.75 <- rbind(sub5_train_0.25, sub5_train_0.5)
sub5_train_index <- sub5_train_0.75$X
sub5_train_index_minus_1 <- sub5_train_index-1

sub5_train_0.5_to_historical <- subset(sub_season_3_2014, !(sub_season_3_2014$orderID %in% sub5_train_0.5_ID))
sub5_train_0.25_to_historical <- subset(sub_season_1_2_2014, !(sub_season_1_2_2014$orderID %in% sub5_train_0.25_ID))
sub5_historical <- rbind(sub5_train_0.25_to_historical, sub5_train_0.5_to_historical, sub_season_historical_2015)

sub5_historical_index <- sub5_historical$X
sub5_historical_index_minus_1 <- sub5_historical_index-1

write.table(sub5_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V5.csv", row.names = FALSE,col.names = F)
write.table(sub5_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V5.csv", row.names = FALSE,col.names = F)
write.table(sub5_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V5.csv", row.names = FALSE,col.names = F)





#method 4
set.seed(0)
sub4_test_0.25 <- sub4_test_0.25
sub4_test_index <- sub4_test_0.25$X
sub4_test_index_minus_1 <- sub4_test_index-1


sub4_unique_train_ID<- unique(sub_season_1_2_3_2014$orderID)
sub4_train_0.75_ID <- sub4_unique_train_ID[sample(1:length(sub4_unique_train_ID), round(length(sub4_unique_train_ID)*0.75) )]
sub4_train_0.75 <- subset(sub_season_1_2_3_2014, sub_season_1_2_3_2014$orderID %in% sub4_train_0.75_ID)
sub4_train_index <- sub4_train_0.75$X
sub4_train_index_minus_1 <- sub4_train_index-1

sub4_train_0.25_to_historical <- subset(sub_season_1_2_3_2014, !(sub_season_1_2_3_2014$orderID %in% sub4_train_0.75_ID))
sub4_train_0.25_to_historical_index <- sub4_train_0.25_to_historical$X
sub4_historical_index <- c(sub4_train_0.25_to_historical_index, sub_season_historical_2015$X)
sub4_historical_index_minus_1 <- sub4_historical_index-1

write.table(sub4_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V4.csv", row.names = FALSE,col.names = F)
write.table(sub4_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V4.csv", row.names = FALSE,col.names = F)
write.table(sub4_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V4.csv", row.names = FALSE,col.names = F)








#method 1
set.seed(0)
sub1_unique_train_ID<- unique(sub_season_3_2014$orderID)
sub1_train_0.75_ID <- sub1_unique_train_ID[sample(1:length(sub1_unique_train_ID), round(length(sub1_unique_train_ID)*0.75) )]
sub1_train_0.75 <- subset(sub_season_3_2014, sub_season_3_2014$orderID %in% sub1_train_0.75_ID)
sub1_train_index <- sub1_train_0.75$X
sub1_train_index_minus_1 <- sub1_train_index-1



set.seed(0)
sub1_unique_test_ID<- unique(sub_season_4_2014$orderID)
sub1_test_0.25_ID <- sub1_unique_test_ID[sample(1:length(sub1_unique_test_ID), round(length(sub1_unique_test_ID)*0.25 ))]
sub1_test_0.25 <- subset(sub_season_4_2014, sub_season_4_2014$orderID %in% sub1_test_0.25_ID)
sub1_test_index <- sub1_test_0.25$X
sub1_test_index_minus_1 <- sub1_test_index-1



sub1_train_0.25_to_historical <- subset(sub_season_3_2014, !(sub_season_3_2014$orderID %in% sub1_train_0.75_ID))
sub1_train_0.25_to_historical_index <- sub1_train_0.25_to_historical$X
sub1_historical_index <- c(sub_season_historical$X, sub1_train_0.25_to_historical_index)
sub1_historical_index_minus_1 <- sub1_historical_index-1

#method 2

set.seed(0)
sub2_test_0.25 <- sub1_test_0.25
sub2_test_index <- sub2_test_0.25$X
sub2_test_index_minus_1 <- sub2_test_index-1

sub2_train_0.75<- subset(sub_season_4_2014, !(sub_season_4_2014$orderID %in% sub1_test_0.25_ID))
sub2_train_index <- sub2_train_0.75$X
sub2_train_index_minus_1 <- sub2_train_index-1


sub2_historical_index <- c(sub_season_historical$X, sub_season_3_2014$X)
sub2_historical_index_minus_1 <- sub2_historical_index-1
## need to add sub_season_3_2014 into historical

#method 3

set.seed(0)
sub3_test_0.25 <- sub1_test_0.25
sub3_test_index <- sub3_test_0.25$X

sub3_train_0.375_1_temp <- subset(sub_season_4_2014, !(sub_season_4_2014$orderID %in% sub1_test_0.25_ID))
sub3_train_0.375_1_temp_uniqueID <- unique(sub3_train_0.375_1_temp$orderID)
sub3_train_0.375_1_ID <- sub3_train_0.375_1_temp_uniqueID[sample(1:length(sub3_train_0.375_1_temp_uniqueID), round(length(sub3_train_0.375_1_temp_uniqueID)*0.5))]
sub3_train_0.375_1 <- subset(sub3_train_0.375_1_temp, sub3_train_0.375_1_temp$orderID %in% sub3_train_0.375_1_ID)


set.seed(0)
sub3_train_0.375_2_temp <- sub_season_3_2014
sub3_train_0.375_2_temp_uniqueID <-unique(sub3_train_0.375_2_temp$orderID)
sub3_train_0.375_2_ID <- sub3_train_0.375_2_temp_uniqueID[sample(1:length(sub3_train_0.375_2_temp_uniqueID), round(length(sub3_train_0.375_1_temp_uniqueID)*0.5))]
sub3_train_0.375_2 <- subset(sub3_train_0.375_2_temp, sub3_train_0.375_2_temp$orderID %in% sub3_train_0.375_2_ID)

sub3_train_0.75 <- rbind(sub3_train_0.375_1,sub3_train_0.375_2)
sub3_train_index <- sub3_train_0.75$X

sub3_train_0.625_to_historical <- subset(sub_season_3_2014, !(sub_season_3_2014$orderID %in% sub3_train_0.375_2_ID))
sub3_train_0.625_to_historical_index <- sub3_train_0.625_to_historical$X
sub3_historical_index <- c(sub_season_historical$X, sub3_train_0.625_to_historical_index)

sub3_test_index_minus_1 <- sub3_test_index-1
sub3_train_index_minus_1 <- sub3_train_index-1
sub3_historical_index_minus_1 <- sub3_historical_index-1








#### write to csv
#method 1
write.csv(sub1_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V1.csv", row.names = FALSE, col.names = F)
write.csv(sub1_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V1.csv", row.names = FALSE,col.names = F)
write.csv(sub1_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V1.csv", row.names = FALSE,col.names = F)

#method 2
write.table(sub2_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V2.csv", row.names = FALSE,col.names = F)
write.table(sub2_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V2.csv", row.names = FALSE,col.names = F)
write.table(sub2_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V2.csv", row.names = FALSE,col.names = F)


#method 3
write.table(sub3_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V3.csv", row.names = FALSE,col.names = F)
write.table(sub3_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V3.csv", row.names = FALSE,col.names = F)
write.table(sub3_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V3.csv", row.names = FALSE,col.names = F)






sub_historical_2014<- subset(train_raw, orderYear == 2014)
sub_historical_2015<- subset(train_raw, orderYear == 2015)

order_month <-sub_historical_2014 %>% group_by( orderMonth) %>% summarise(freq = length(unique(orderID))) 
order_month_2015 <-sub_historical_2015 %>% group_by( orderMonth) %>% summarise(freq = length(unique(orderID))) 


#method 8 selected by customer ID

season_4_2014 <- subset(train_raw, orderMonth >=10 & orderMonth <=12 & orderYear ==2014)
season_3_2014 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2014)
season_2_2014 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2014)
season_1_2014 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2014)

season_3_2015 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2015)
season_2_2015 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2015)
season_1_2015 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2015)

set.seed(0)
sub8_unique_test_ID<- unique(season_4_2014$orderID)
sub8_test_0.25_orderID <- sub8_unique_test_ID[sample(1:length(sub8_unique_test_ID), round(length(sub8_unique_test_ID)*0.25))]

sub8_test_0.25 <- subset(season_4_2014, season_4_2014$orderID %in% sub8_test_0.25_orderID)

set.seed(0)
sub8_test_0.25_unique_customerID <- unique(sub8_test_0.25$customerID)
sub8_temp_1 <- rbind(season_1_2014,season_2_2014,season_1_2015,season_2_2015,season_3_2015)
same_customer_all <- subset(sub8_temp_1, sub8_temp_1$customerID %in% sub8_test_0.25_unique_customerID)
sub8_smp_1 <- sample(dim(same_customer_all)[1], 1.2 * (dim(sub8_test_0.25)[1]))
sub8_smp_1 <- sort(sub8_smp_1,decreasing = FALSE)
sub8_train_1 <- same_customer_all[sub8_smp_1, ]
sub8_histo_1 <- subset(sub8_temp_1, !(sub8_temp_1$X %in% sub8_train_1$X))

set.seed(0)
same_customer_season_3_2014 <- subset(season_3_2014, season_3_2014$customerID %in% sub8_test_0.25_unique_customerID)
sub8_temp_2 <- subset(season_3_2014, !(season_3_2014$X %in% same_customer_season_3_2014$X))
sub8_smp_2 <-sample(dim(sub8_temp_2)[1], 1.8 * (dim(sub8_test_0.25)[1]))
sub8_smp_2 <- sort(sub8_smp_2,decreasing = FALSE)
sub8_train_2<- sub8_temp_2[sub8_smp_2,]
sub8_histo_2 <- subset(season_3_2014, !(season_3_2014$X %in% sub8_train_2$X))

sub8_histo_temp<- rbind(sub8_histo_1, sub8_histo_2)
sub8_histo_row_id <- unique(sub8_histo_temp$X)-1

sub8_train<- rbind(sub8_train_1,sub8_train_2)
sub8_train_row_id <- unique(sub8_train$X)-1

sub8_test_row_id <- unique(sub8_test_0.25$X)-1

write.csv(sub8_train_row_id, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V8.csv", row.names = FALSE, col.names = F)
write.csv(sub8_test_row_id, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V8.csv", row.names = FALSE,col.names = F)
write.csv(sub8_historical_row_id, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V8.csv", row.names = FALSE,col.names = F)



