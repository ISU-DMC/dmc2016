library(lubridate)
library(dplyr)

train_raw = read.csv(file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/orders_train.csv")

train_raw$orderMonth <- month(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))
train_raw$orderYear <- year(as.POSIXlt(train_raw$orderDate, format="%Y-%m-%d"))


test_row <- read.table(file="/Users/yaosuhan/Desktop/DMC_2016_local/epwalsh_index_test.txt")
test_row_new <- test_row + 1

test_pete <- read.table(file="/Users/yaosuhan/Desktop/DMC_2016_local/epwalsh_index_test.txt")






season_4_2014 <- subset(train_raw, orderMonth >=10 & orderMonth <=12 & orderYear ==2014)
season_3_2014 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2014)
season_2_2014 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2014)
season_1_2014 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2014)

season_3_2015 <- subset(train_raw, orderMonth >=7 & orderMonth <=9 & orderYear ==2015)
season_2_2015 <- subset(train_raw, orderMonth >=4 & orderMonth <=6 & orderYear ==2015)
season_1_2015 <- subset(train_raw, orderMonth >=1 & orderMonth <=3 & orderYear ==2015)



test_0.25 <- subset(season_4_2014, season_4_2014$X %in% test_row_new$V1)
# remove 

season_4_2014_to_his_temp <- subset(season_4_2014, !(season_4_2014$X %in% test_0.25$X))
season_4_2014_to_his <- subset(season_4_2014_to_his_temp, !(season_4_2014_to_his_temp$orderID %in% test_0.25$orderID))

intersect(season_4_2014_to_his$orderID, test_0.25$orderID)

test_unique_ID <- unique(test_0.25$orderID)
set.seed(0)
train_unique_ID <- unique(season_3_2014$orderID)
train_0.5_ID <- train_unique_ID[sample(1:length(train_unique_ID), round(length(test_unique_ID)*3))]
train_0.5 <- subset(season_3_2014, season_3_2014$orderID %in% train_0.5_ID)
season_3_2014_to_his <- subset(season_3_2014,!(season_3_2014$X %in% train_0.5$X))

historical <- rbind(season_1_2014, season_2_2014, season_3_2014_to_his, season_4_2014_to_his,
                    season_1_2015, season_2_2015, season_3_2015)


test<-test_0.25
train<- train_0.5

test_row <- test$X-1
train_row <- train$X-1
historical_row <- historical$X-1

intersect(train_row, test_row)
intersect(train_row, historical_row)
intersect(historical_row, test_row)
length(train_row) + length(test_row) + length(historical_row) - dim(train_raw)[1]



write.table(test_row, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_test_new_V1.csv", row.names = FALSE, col.names = F)
write.table(train_row, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_new_V1.csv", row.names = FALSE,col.names = F)
write.table(historical_row, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_new_V1.csv", row.names = FALSE,col.names = F)






season_3_15_unique_ID <- unique(season_3_2015$orderID)
final_train_ID <- season_3_15_unique_ID[sample(1:length(season_3_15_unique_ID), round(length(season_3_15_unique_ID)*0.75))]
final_train_v1 <- subset(season_3_2015, season_3_2015$orderID %in% final_train_ID)
season_3_15_to_his <- subset(season_3_2015, !(season_3_2015$orderID %in% final_train_ID))
final_historical_v1_temp <- rbind(season_1_2014, season_2_2014, season_3_2014, season_4_2014,season_1_2015,season_2_2015)

final_historical_v1 <- rbind(final_historical_v1_temp, season_3_15_to_his)
final_train_v1_row <- final_train_v1$X - 1
final_historical_v1_row <- final_historical_v1$X - 1
write.table(final_train_v1_row, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_train_final_V1.csv", row.names = FALSE,col.names = F)
write.table(final_historical_v1_row, file="/Users/yaosuhan/Desktop/DMC_2016_local/raw_data/hanye_index_historical_final_V1.csv", row.names = FALSE,col.names = F)
