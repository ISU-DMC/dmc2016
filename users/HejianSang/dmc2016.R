###### ####### This document is used to understand the data

names(train)
names(test)

#### OrderID

summary(train$orderID)
length(unique(train$orderID))
length(unique(test$orderID))

time=as.Date(train$orderDate)
