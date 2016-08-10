library(ggplot2)
library(reshape2)
library(dplyr)
library(stringi)


d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")

#combine class and train
new<-rbind(d[,1:14],class)

#create new variable for last 3 digits of color code 
new$colorCode_last3<-as.numeric(stri_sub(new$colorCode, -3,-1))
head(new$colorCode_last3)

#create new variable for last 2 digits of color code 
new$colorCode_last2<-as.numeric(stri_sub(new$colorCode, -2,-1))
head(new$colorCode_last2)

#create new variable for hundreds place of color code 
new$colorCode_hundreds<-as.numeric(stri_sub(new$colorCode, -3,-3))
head(new$colorCode_hundreds)

#create new variable for tens place of color code 
new$colorCode_tens<-as.numeric(stri_sub(new$colorCode, -2,-2))
head(new$colorCode_tens)

#create new variable for ones place of color code 
new$colorCode_ones<-as.numeric(stri_sub(new$colorCode, -1,-1))
head(new$colorCode_ones)

#Frequency of ColorCode last 3 digits = how many times does each color appear in the dataset?

# freq last 3 
sort(unique(new$colorCode_last3))

c3<-summarise(group_by(new, colorCode_last3), 
              frequency=length(colorCode_last3)
) 
c3<-data.frame(c3)

sort(unique(c3$colorCode_last3))
for (i in 0:999){
  new$freqColorCode_last3[new$colorCode_last3==i]<-c3$frequency[c3$colorCode_last3==i]}

sort(unique(new$freqColorCode_last3))
sort(unique(c3$frequency))

# freq last 2
sort(unique(new$colorCode_last2))

c2<-summarise(group_by(new, colorCode_last2), 
              frequency=length(colorCode_last2)
) 
c2<-data.frame(c2)

sort(unique(c2$colorCode_last2))
for (i in 0:99){
  new$freqColorCode_last2[new$colorCode_last2==i]<-c2$frequency[c2$colorCode_last2==i]}

sort(unique(new$freqColorCode_last2))
sort(unique(c2$frequency))

#freq hundreds place 
sort(unique(new$colorCode_hundreds))

ch<-summarise(group_by(new, colorCode_hundreds), 
              frequency=length(colorCode_hundreds)
) 
ch<-data.frame(ch)

sort(unique(ch$colorCode_hundreds))
for (i in 0:9){
  new$freqColorCode_hundreds[new$colorCode_hundreds==i]<-ch$frequency[ch$colorCode_hundreds==i]}

sort(unique(new$freqColorCode_hundreds))
sort(unique(ch$frequency))

# freq tens 
sort(unique(new$colorCode_tens))

ct<-summarise(group_by(new, colorCode_tens), 
              frequency=length(colorCode_tens)
) 
ct<-data.frame(ct)

sort(unique(ct$colorCode_tens))
for (i in 0:9){
  new$freqColorCode_tens[new$colorCode_tens==i]<-ct$frequency[ct$colorCode_tens==i]}

sort(unique(new$freqColorCode_tens))
sort(unique(ct$frequency))

# freq ones place 
sort(unique(new$colorCode_ones))

co<-summarise(group_by(new, colorCode_ones), 
              frequency=length(colorCode_ones)
) 
co<-data.frame(co)

sort(unique(co$colorCode_ones))
for (i in 0:9){
  new$freqColorCode_ones[new$colorCode_ones==i]<-co$frequency[co$colorCode_ones==i]}

sort(unique(new$freqColorCode_ones))
sort(unique(co$frequency))

FeatureFreqColorDigits<-cbind(new$freqColorCode_last3,new$freqColorCode_last2,new$freqColorCode_hundreds,new$freqColorCode_tens, new$freqColorCode_ones)
# divide by length of unique order ids to make number smaller 
length(unique(new$orderID))
FeatureFreqColorDigits<-FeatureFreqColorDigits/849185
dim(d)
dim(class)
freqColorDigitsT<-FeatureFreqColorDigits[1:2325165,]
freqColorDigitsC<-FeatureFreqColorDigits[2325166:2666263,]
freqColorDigitsT<-data.frame(freqColorDigitsT)
freqColorDigitsC<-data.frame(freqColorDigitsC)

names(freqColorDigitsT)<-c("freqColorCode_last3", "freqColorCode_last2", "freqColorCode_hundreds", "freqColorCode_tens", "freqColorCode_ones")
names(freqColorDigitsC)<-c("freqColorCode_last3", "freqColorCode_last2", "freqColorCode_hundreds", "freqColorCode_tens", "freqColorCode_ones")

write.csv(freqColorDigitsT, file = "/Users/manjujohny/Documents/Features/mjohny_freqColorCodeDigits_train.csv", row.names=FALSE)
write.csv(freqColorDigitsC, file = "/Users/manjujohny/Documents/Features/mjohny_freqColorCodeDigits_class.csv", row.names=FALSE)
which(is.na(freqColorDigitsT)==TRUE)
which(is.na(freqColorDigitsC)==TRUE)
