library(ggplot2)
library(reshape2)
library(dplyr)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
class<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_class.txt",header=TRUE, sep=";")
dim(d)
names(d[,1:14])
names(class)
new<-rbind(d[,1:14],class)

######## Frequence SizeCode #######

#Frequency of sizeCode = how many times does each size appears in the dataset?

#all set 
head(new)
st<-summarise(group_by(new, sizeCode), 
             frequency=length(sizeCode)
) 
st<-data.frame(st)
for (i in 24:100){
new$freqSizeCode[new$sizeCode==i]<-st$frequency[st$sizeCode==i]}
new$freqSizeCode[new$sizeCode=="A"]<-st$frequency[st$sizeCode=="A"]
new$freqSizeCode[new$sizeCode=="I"]<-st$frequency[st$sizeCode=="I"]
new$freqSizeCode[new$sizeCode=="L"]<-st$frequency[st$sizeCode=="L"]
new$freqSizeCode[new$sizeCode=="M"]<-st$frequency[st$sizeCode=="M"]
new$freqSizeCode[new$sizeCode=="S"]<-st$frequency[st$sizeCode=="S"]
new$freqSizeCode[new$sizeCode=="XL"]<-st$frequency[st$sizeCode=="XL"]
new$freqSizeCode[new$sizeCode=="XS"]<-st$frequency[st$sizeCode=="XS"]

sort(unique(st$frequency))
sort(unique(new$freqSizeCode))



#Frequency of ColorCode = how many times does each color appears in the dataset?
sort(unique(class$colorCode))


ct<-summarise(group_by(new, colorCode), 
             frequency=length(colorCode)
) 
ct<-data.frame(ct)

sort(unique(ct$colorCode))
for (i in 1000:7221){
  new$freqColorCode[new$colorCode==i]<-ct$frequency[ct$colorCode==i]}
new$freqColorCode[new$colorCode==8888]<-ct$frequency[ct$colorCode==8888]
for (i in 10000:10367){
  new$freqColorCode[new$colorCode==i]<-ct$frequency[ct$colorCode==i]}
for (i in 20001:20363){
  new$freqColorCode[new$colorCode==i]<-ct$frequency[ct$colorCode==i]}
for (i in 30001:30363){
  new$freqColorCode[new$colorCode==i]<-ct$frequency[ct$colorCode==i]}
new$freqColorCode[new$colorCode==88888]<-ct$frequency[ct$colorCode==88888]
sort(unique(new$freqColorCode))
sort(unique(ct$frequency))


####### Frequency Product Group #########
pt<-summarise(group_by(new, productGroup), 
             frequency=length(productGroup)
) 
pt<-data.frame(pt)
dim(pt)
sort(unique(pt$frequency))

new$freqProductGroup[new$productGroup=="NA"]<-351
#didn't work
new$freqProductGroup<-351
for (i in 1:90){
new$freqProductGroup[new$productGroup==i]<-pt$frequency[pt$productGroup==i][1]}
for (i in 1214:1289){
  new$freqProductGroup[new$productGroup==i]<-pt$frequency[pt$productGroup==i][1]}
sort(unique(new$freqProductGroup))

######## frequency article ids ########
new$articleIDnum<-as.numeric(new$articleID)
length(new$articleIDnum)
length(unique(new$articleID))
sort(unique(new$articleIDnum))

at<-summarise(group_by(new, articleIDnum), 
              frequency=length(articleIDnum)
)
at<-data.frame(at)
head(at)
for (i in 1:4241){
  new$freqArticleID[new$articleIDnum==i]<-at$frequency[at$articleIDnum==i][1]}


sort(unique(at$frequency))
sort(unique(new$freqArticleID))
which(is.na(new$freqProductGroup))
which(is.na(new$freqArticleID))
which(is.na(new$freqSizeCode))
which(is.na(new$freqColorCode))

freqFeature<-cbind(new$freqSizeCode,new$freqColorCode,new$freqArticleID,new$freqProductGroup)
dim(freqFeature)
dim(d)
length(unique(new$orderID))

freqT<-freqFeature[1:2325165,]
freqC<-freqFeature[2325166:2666263,]

freqT<-data.frame(freqT)
freqT$freqSizeCode<-freqT$freqSizeCode/849185
freqC<-data.frame(freqC)
names(freqT)<-c("freqSizeCode", "freqColorCode","freqArticleID","freqProductGroup")
names(freqC)<-c("freqSizeCode", "freqColorCode","freqArticleID","freqProductGroup")

write.csv(freqT, file = "/Users/manjujohny/Documents/Features/mjohny_FreqVariables_train.csv", row.names=FALSE)
write.csv(freqC, file = "/Users/manjujohny/Documents/Features/mjohny_FreqVariables_class.csv", row.names=FALSE)
freqT<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_FreqVariables_train.csv",header=TRUE)
freqC<-read.csv(file="/Users/manjujohny/Documents/Features/mjohny_FreqVariables_class.csv",header=TRUE)

freqT<-freqT/length(unique(new$orderID))
freqC<-freqC/length(unique(new$orderID))
head(freqT)
head(freqC)
write.csv(freqT, file = "/Users/manjujohny/Documents/Features/mjohny_FreqVariables_train.csv", row.names=FALSE)
write.csv(freqC, file = "/Users/manjujohny/Documents/Features/mjohny_FreqVariables_class.csv", row.names=FALSE)
