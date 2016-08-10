library(lubridate)
library(dplyr)


train_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_train.csv")

train_raw$orderMonth <- month(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderYear <- year(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))

season_4_2014 <- subset(train_raw, orderMonth >=10 & orderMonth <=12 & orderYear ==2014)
season_3_2014 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2014)
season_2_2014 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2014)
season_1_2014 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2014)

season_3_2015 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2015)
season_2_2015 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2015)
season_1_2015 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2015)

## method 6 use season 3 2014 to predict season 3 2015
set.seed(0)
sub6_unique_test_ID<- unique(season_3_2015$orderID)
sub6_test_0.25_ID <- sub6_unique_test_ID[sample(1:length(sub6_unique_test_ID), round(length(sub6_unique_test_ID)*0.25 ))]
sub6_test_0.25 <- subset(season_3_2015, season_3_2015$orderID %in% sub6_test_0.25_ID)
sub6_test_index <- sub6_test_0.25$X
sub6_test_index_minus_1 <- sub6_test_index-1

set.seed(0)
sub6_unique_train_ID<- unique(season_3_2014$orderID)
sub6_train_0.75_ID <- sub6_unique_train_ID[sample(1:length(sub6_unique_train_ID), round(length(sub6_unique_train_ID)*0.75 ))]
sub6_train_0.75 <- subset(season_3_2014, season_3_2014$orderID %in% sub6_train_0.75_ID)
sub6_train_index <- sub6_train_0.75$X
sub6_train_index_minus_1 <- sub6_train_index-1

sub6_train_0.25_to_historical <- subset(season_3_2014, !(season_3_2014$orderID %in% sub6_train_0.75_ID))
sub6_historicals <- rbind(season_1_2014,season_2_2014,sub6_train_0.25_to_historical,season_4_2014,season_1_2015,season_2_2015)
sub6_historical_index <- sub6_historical$X
sub6_historical_index_minus_1 <- sub6_historical_index-1

write.table(sub6_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V6.csv", row.names = FALSE, col.names = F)
write.table(sub6_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V6.csv", row.names = FALSE,col.names = F)
write.table(sub6_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V6.csv", row.names = FALSE,col.names = F)




## method 7 use season 2 2015 to predict season 3 2015
set.seed(0)
sub7_test_index_minus_1 <- sub6_test_index_minus_1

set.seed(0)
sub7_unique_train_ID<- unique(season_2_2015$orderID)
sub7_train_0.75_ID <- sub7_unique_train_ID[sample(1:length(sub7_unique_train_ID), round(length(sub7_unique_train_ID)*0.75 ))]
sub7_train_0.75 <- subset(season_2_2015, season_2_2015$orderID %in% sub7_train_0.75_ID)
sub7_train_index <- sub7_train_0.75$X
sub7_train_index_minus_1 <- sub7_train_index-1

sub7_train_0.25_to_historical <- subset(season_2_2015, !(season_2_2015$orderID %in% sub7_train_0.75_ID))
sub7_historicals <- rbind(season_1_2014,season_2_2014,season_3_2014,season_4_2014,season_1_2015,sub7_train_0.25_to_historical)
sub7_historical_index <- sub7_historicals$X
sub7_historical_index_minus_1 <- sub7_historical_index-1


write.table(sub7_train_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_V7.csv", row.names = FALSE, col.names = F)
write.table(sub7_test_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_V7.csv", row.names = FALSE,col.names = F)
write.table(sub7_historical_index_minus_1, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_V7.csv", row.names = FALSE,col.names = F)
