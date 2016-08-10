train=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/data/raw_data/orders_train.txt",sep=";")
# train has data from 01/2014 to 09/2015
train$month=month(train$orderDate)
train$year=year(train$orderDate)
train$index=0:(dim(train)[1]-1)
train14=subset(train,year==2014)
train15=subset(train,year==2015)
train14_1=subset(train14,month %in% c(1,2,3,4,5,6))
train14_2=subset(train14,month %in% c(7,8,9))
train14_3=subset(train14,month %in% c(10,11,12))
unique_orderID_14_2=unique(train14_2$orderID)
unique_orderID_14_3=unique(train14_3$orderID)
'%ni%' <- Negate('%in%')

#For year 2014
set.seed(0)
train14_2_hist_orderID=sample(unique_orderID_14_2,round(0.25*length(unique_orderID_14_2)),replace=FALSE)
train14_2_tr_orderID=subset(unique_orderID_14_2,unique_orderID_14_2 %ni% train14_2_hist_orderID)
train14_3_test_orderID=sample(unique_orderID_14_3,round(0.25*length(unique_orderID_14_3)),replace=FALSE)
train14_3_eg_orderID=subset(unique_orderID_14_3,unique_orderID_14_3 %ni% train14_3_test_orderID)
train14_hist1=train14_1
train14_hist2=subset(train14_2,orderID %in% train14_2_hist_orderID)
train14_tr=subset(train14_2,orderID %in% train14_2_tr_orderID)
train14_test=subset(train14_3,orderID %in% train14_3_test_orderID)
train14_hist=rbind(train14_hist1,train14_hist2)
train14_eg=subset(train14_3,train14_3$orderID %in% train14_3_eg_orderID)
nrow(train14_hist)+nrow(train14_tr)+nrow(train14_test)+nrow(train14_eg)

#For year 2015
train15_hist=train15

#Splitting into historical,training,test data set
historical=rbind(train14_hist,train15_hist)
training=train14_tr
testing=train14_test
nrow(historical)+nrow(training)+nrow(testing)+nrow(train14_eg)

hist=data.frame(h=historical[,18])
names(hist)<-NULL
train=data.frame(h=training[,18])
names(train)<-NULL
test=data.frame(h=testing[,18])
names(test)<-NULL

#writing the csv files
write.csv(hist,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Index/V1/abhishek_index_historical_V1.csv",row.names=FALSE)
write.csv(train,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Index/V1/abhishek_index_train_V1.csv",row.names=FALSE)
write.csv(test,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Index/V1/abhishek_index_test_V1.csv",row.names=FALSE)

