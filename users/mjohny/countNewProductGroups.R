library(ggplot2)
library(reshape2)
library(dplyr)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")
dim(d)
dim(class)
names(d[,1:14])
names(class)
newprod_train<-read.csv(file="/Users/manjujohny/Downloads/binned_new_productGroup/binned_new_productGroup_train.csv",header=TRUE)
newprod_test<-read.csv(file="/Users/manjujohny/Downloads/binned_new_productGroup/binned_new_productGroup_test.csv",header=TRUE)
dnew<-cbind(d[,1:14],newprod_train)
classnew<-cbind(class,newprod_test)
dim(dnew)
dim(classnew)
new<-rbind(dnew,classnew)
names(new)


#option 1
p1<-summarise(group_by(new, binned_new_productGroup_option_1), 
              frequency=length(binned_new_productGroup_option_1)
) 


p1<-data.frame(p1)
dim(p1)
sort(unique(p1$frequency))
sort(unique(p1$binned_new_productGroup_option_1))


for (i in 1:50){
  new$countProductGroupOption1[new$binned_new_productGroup_option_1==i]<-p1$frequency[p1$binned_new_productGroup_option_1==i][1]}
new$countProductGroupOption1[new$binned_new_productGroup_option_1==1237]<-p1$frequency[p1$binned_new_productGroup_option_1==1237][1]
new$countProductGroupOption1[new$binned_new_productGroup_option_1==1257]<-p1$frequency[p1$binned_new_productGroup_option_1==1257][1]
new$countProductGroupOption1[new$binned_new_productGroup_option_1==1258]<-p1$frequency[p1$binned_new_productGroup_option_1==1258][1]

sort(unique(new$countProductGroupOption1))

#option2
p2<-summarise(group_by(new, binned_new_productGroup_option_2), 
              frequency=length(binned_new_productGroup_option_2)
) 


p2<-data.frame(p2)
dim(p2)
sort(unique(p2$frequency))
sort(unique(p2$binned_new_productGroup_option_2))


for (i in 1:50){
  new$countProductGroupOption2[new$binned_new_productGroup_option_2==i]<-p2$frequency[p2$binned_new_productGroup_option_2==i][1]}
new$countProductGroupOption2[new$binned_new_productGroup_option_2==1237]<-p2$frequency[p2$binned_new_productGroup_option_2==1237][1]
new$countProductGroupOption2[new$binned_new_productGroup_option_2==1257]<-p2$frequency[p2$binned_new_productGroup_option_2==1257][1]
new$countProductGroupOption2[new$binned_new_productGroup_option_2==1258]<-p2$frequency[p2$binned_new_productGroup_option_2==1258][1]

sort(unique(new$countProductGroupOption2))

#option 3
p3<-summarise(group_by(new, binned_new_productGroup_option_3), 
              frequency=length(binned_new_productGroup_option_3)
) 


p3<-data.frame(p3)
dim(p3)
sort(unique(p3$frequency))
sort(unique(p3$binned_new_productGroup_option_3))

for (i in 1:50){
  new$countProductGroupOption3[new$binned_new_productGroup_option_3==i]<-p3$frequency[p3$binned_new_productGroup_option_3==i][1]}
new$countProductGroupOption3[new$binned_new_productGroup_option_3==1237]<-p3$frequency[p3$binned_new_productGroup_option_3==1237][1]
new$countProductGroupOption3[new$binned_new_productGroup_option_3==1257]<-p3$frequency[p3$binned_new_productGroup_option_3==1257][1]
new$countProductGroupOption3[new$binned_new_productGroup_option_3==1258]<-p3$frequency[p3$binned_new_productGroup_option_3==1258][1]

sort(unique(new$countProductGroupOption3))

#option 4
p4<-summarise(group_by(new, binned_new_productGroup_option_4), 
              frequency=length(binned_new_productGroup_option_4)
) 


p4<-data.frame(p4)
dim(p4)
sort(unique(p4$frequency))
sort(unique(p4$binned_new_productGroup_option_4))


for (i in 1:50){
  new$countProductGroupOption4[new$binned_new_productGroup_option_4==i]<-p4$frequency[p4$binned_new_productGroup_option_4==i][1]}
new$countProductGroupOption4[new$binned_new_productGroup_option_4==1237]<-p4$frequency[p4$binned_new_productGroup_option_4==1237][1]
new$countProductGroupOption4[new$binned_new_productGroup_option_4==1257]<-p4$frequency[p4$binned_new_productGroup_option_4==1257][1]
new$countProductGroupOption4[new$binned_new_productGroup_option_4==1258]<-p4$frequency[p4$binned_new_productGroup_option_4==1258][1]

sort(unique(new$countProductGroupOption1))

#
summary(new$countProductGroupOption3)
summary(dnew$binned_new_productGroup_option_2)
summary(classnew$binned_new_productGroup_option_2)
countNewBinnedProductGroup<-cbind(new$countProductGroupOption1,new$countProductGroupOption2,new$countProductGroupOption3,new$countProductGroupOption4)
countNewBinnedProductGroupT<-countNewBinnedProductGroup[1:2325165,]
countNewBinnedProductGroupC<-countNewBinnedProductGroup[2325166:2666263,]
countNewBinnedProductGroupT<-data.frame(countNewBinnedProductGroupT)
countNewBinnedProductGroupC<-data.frame(countNewBinnedProductGroupC)

names(countNewBinnedProductGroupT)<-c("countProductGroupOption1", "countProductGroupOption2","countProductGroupOption3","countProductGroupOption4")
names(countNewBinnedProductGroupC)<-c("countProductGroupOption1", "countProductGroupOption2","countProductGroupOption3","countProductGroupOption4")

