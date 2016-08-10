library(lubridate)

data.path <- "C:/Users/haozhe/Documents/GitHub/dmc2016/data/raw_data/"
data <- read.table(paste0(data.path,"orders_train.txt"),sep=";",header=TRUE)
str(data)

nrow(data)/nlevels(data$orderID)
nrow(data)/nlevels(data$articleID)
### whether there are new articles in the testing data?

data$yearDate <- year(as.character(data$orderDate))
data$monthDate <- month(as.character(data$orderDate))
data$dayDate <- day(as.character(data$orderDate))
table(data$yearDate)
table(data$monthDate)
table(data$monthDate)
### the effect of holiday or festival on return?

table(data$colorCode)
### Is colorCode a factor variable or numeric variable?

table(data$sizeCode)
## trousers/top

table(data$productGroup)
data[which(data$productGroup==26),]

table(data$quantity)
data[which(data$quantity>5),]

plot(density(data$price))

plot(density(na.omit(data$rrp)))

table(data$voucherID)

plot(density(data$voucherAmount))

nrow(data)/nlevels(data$customerID)

table(data$deviceID)

table(data$paymentMethod)

########################
plot(returnQuantity/quantity~price,data=data)

which(data$returnQuantity>data$quantity)  #####some wrong recordings!!

plot(returnQuantity/quantity~monthDate,data=data)
plot(returnQuantity/quantity~sizeCode,data=data)
plot(returnQuantity/quantity~paymentMethod,data=data)
plot(returnQuantity/quantity~quantity,data=data)
plot(price~rrp,data=data)
