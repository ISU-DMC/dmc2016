library(ggplot2)
library(reshape2)
library(dplyr)
setwd("/Users/manjujohny/dmc2016/data/raw_data")
d<-read.csv(file="orders_train.txt",header=TRUE, sep=";")
attach(d)
dim(d)
#target attribute = returnQuntity 
class<-read.csv(file="orders_class.txt",header=TRUE, sep=";")
#dim(class)

############## Explore the Data ###############
names(d)
#summary of variables 
summary(returnQuantity)
str(orderID)
str(orderDate)
str(articleID)
str(colorCode)
str(sizeCode)
summary(sizeCode)
#different sizes levels could indicate different clothing types 
summary(productGroup)
#bunch of NA's in product group -_-
summary(quantity) 
#between 0 and 24 items ordered
#how do you order 0 items?

##### Why are some rrp < price? ######
drsub<-subset(d, rrp<price)
drsub[1:25,]

#create new vector for rrp*quantity = totalrrp 
#weird rounding problems fixed by rounding all $ amounts to 2 decimal places
d$price_unit<-d$price/d$quantity
d$trrp<-d$rrp*d$quantity
d$rrp<-round(d$rrp,2)
d$trrp<-round(d$trrp,2)
d$price<-round(d$price,2)
length(d$price[d$price>d$rrp])
length(d$price[round(d$price,2)>round(d$trrp,2)])
d[which(round(d$price,2)>round(d$trrp,2)),]


length(unique(d$articleID[round(d$price,2)>round(d$trrp,2)]))
length(unique(d$voucherID[round(d$price,2)>round(d$trrp,2)]))
length(unique(d$price[round(d$price,2)>round(d$trrp,2)]))
length(unique(d$rrp[round(d$price,2)>round(d$trrp,2)]))
length(unique(d$productGroup[round(d$price,2)>round(d$trrp,2)]))

d$price[unique(d$articleID[round(d$price,2)>round(d$trrp,2)])]<d$trrp[unique(d$articleID[round(d$price,2)>round(d$trrp,2)])]

###### Relationship between discount (difference in trrp & price), and returns
### how about indicator is price < some percent of trrp?###
mean(d$returnQuantity[which(d$price<d$trrp)])
p<-seq(from = 0, to = 100, by = 1)
discount.return<-matrix(NA, nrow=length(p), ncol=3)
for (i in 1:length(p)){
  discount.return[i,1]<-p[i]
  discount.return[i,2]<-mean(d$returnQuantity[which(d$price<(p[i]/100)*d$trrp)])
  discount.return[i,3]<-var(d$returnQuantity[which(d$price<(p[i]/100)*d$trrp)])
}
discount.return<-data.frame(discount.return)
names(discount.return)<-c("percent.discounted", "meanReturn", "varReturn")
qplot(discount.return$percent.discounted,discount.return$meanReturn)+xlab("percent of total rrp paid or lower")+ylab("mean number of returns per order")
#looks like there are some interesting clusters here. Could group discount percentages. 

###### Relationship between quantity and returns ######
q<-summarise(group_by(d, quantity), 
             frequency=length(sizeCode),
             returnRatio=sum(returnQuantity)/sum(quantity),
             meanReturn=mean(returnQuantity)
) 

q


###### Relationship between size and product group ######

#takes forever to run. could freeze r. figure out better way to do this
qplot(d$sizeCode, as.factor(d$productGroup), na.rm=TRUE)

###### Relationship between size and return percentage ######
s<-summarise(group_by(d, sizeCode), 
             returnPercent=sum(returnQuantity)/sum(quantity)
) 
qplot(s$sizeCode, s$returnPercent)+xlab("size")+ylab("ratio Returned/Bought")


###### What happens when you have repeat items in order ######

# look at only order quantity > 0
dsub<-subset(d, quantity>0)
dim(dsub)
length(unique(d$productGroup)) #19 different product groups
length(unique(d$articleID)) #3823 different articles
length(unique(d$sizeCode)) #29 different sizes 
length(unique(d$colorCode)) #546 different colors 
names(dsub)
#for each order, how many have more than 1 item with same articleID


#Relationship between repeat products in an order & return percent
s<-summarise(group_by(dsub, orderID), 
             article = length(articleID),
             uniqueArticles=length(unique(articleID)),
             returnPercent=sum(returnQuantity)/sum(quantity)
          ) 
head(s)
s$repeatitem<-s$article-s$uniqueArticles
s$repeatitem2<-s$repeatitem
s$repeatitem2[s$repeatitem==0]<-"No"
s$repeatitem2[s$repeatitem>0]<-"Yes"
s1<-summarise(group_by(s, repeatitem2), 
             avReturn = mean(returnPercent)
) 
head(s1)
ggplot(s1, aes(x = repeatitem2, y = avReturn)) + geom_bar(stat = "identity")+xlab("repeat items in order")+ylab("ratio returned/bought")

###### Payment method & Returns ######
p<-summarise(group_by(d, paymentMethod), 
             frequency=length(sizeCode),
             avrrp_noNA=mean(rrp, na.rm=TRUE),
             avrrp=mean(rrp),
             avprice=mean(price),
             voucheramt=mean(voucherAmount),
             returnPercent=sum(returnQuantity)/sum(quantity)
) 
p
#why is there only av rrp for paymentMethod BPPL and KGRG? weird.
#no RG payment returns. but so few frequency.
#it wasn't free b/c mean voucher amount was 0

qplot(p$paymentMethod, p$returnPercent)+xlab("paymentMethod")+ylab("ratio Returned/Bought")

pclass<-summarise(group_by(class, paymentMethod), 
             frequency=length(sizeCode),
             avrrp_noNA=mean(rrp, na.rm=TRUE),
             avrrp=mean(rrp),
             avprice=mean(price),
             voucheramt=mean(voucherAmount),
             returnPercent=sum(returnQuantity)/sum(quantity)
) 
pclass
#only one person bought something using RG in class dataset. maybe RG not so important.
orderprice.return<-NA
orderprice.return<-summarise(group_by(d, orderID), 
                      orderPrice=sum(price),
                      meanReturn=mean(returnQuantity),
                      diffSizes=length(unique(sizeCode)),
                      diffColor=length(unique(colorCode))
)

orderprice.return<-data.frame(orderprice.return)
head(orderprice.return)
names(orderprice.return)<-c("orderID", "orderPrice", "meanReturn", "diffSizes", "diffColor")
qplot(orderprice.return$orderPrice, orderprice.return$meanReturn, color=orderprice.return$diffColor)
