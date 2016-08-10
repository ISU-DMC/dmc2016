library(utils)
library(readr)
library(ggplot2)
############################################################
##############  Freq. of paymentMethod by articleID
# Training data
#data.train<-read_delim("orders_train.txt",";")
#data.train.1<-data.train[,-15]
train=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/data/raw_data/orders_train.txt",sep=";")

# Test data
#data.test<-read_delim("orders_class.txt",";")
class=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/data/raw_data/orders_class.txt",sep=";")

#Combine data
com<-as.data.frame(rbind(train[,-15],class))

###group by article and paymentMethod
library(dplyr)
art_payMet<-com %>% group_by(articleID,paymentMethod) %>%
  summarise(freq=length(paymentMethod))

### Train data
train.1=train[,-15]
train.1$id<-1:dim(train.1)[1]
freq.art_payMet_train=merge(train.1,art_payMet)
freq.art_payMet_train<-freq.art_payMet_train[order(freq.art_payMet_train$id),]
freq.art_payMet_train<-data.frame(freq_payMet_by_art=freq.art_payMet_train$freq)

#write.csv(freq.art_col,file="freq_art_by_color_train.csv",row.names=FALSE)


############## class
#data.test<-read_delim("orders_class.txt",";")
class$id<-1:dim(class)[1]
freq.art_payMet_class=merge(class,art_payMet)
freq.art_payMet_class<-freq.art_payMet_class[order(freq.art_payMet_class$id),]
freq.art_payMet_class<-data.frame(freq_payMet_by_art=freq.art_payMet_class$freq)
#write.csv(freq.art_col_class,file="freq_art_by_color_class.csv",row.names=FALSE)

###################################################################
########## Names of the data for frequency of paymentMethod by articleID###
###################################################################
#Training: 
freq.art_payMet_train
### Class data set:
freq.art_payMet_class


##########################################################
########### Maximum Freq. of paymentMethod by articleID
Max_art_payMet<-art_payMet %>% group_by(articleID) %>%
  summarise(max_freq=max(freq),max.freq_payMet=paymentMethod[which.max(freq)])

####### Merge with train data
max_freq_payMet_by_art_train<-merge(train.1,Max_art_payMet)
max_freq_payMet_by_art_train<-max_freq_payMet_by_art_train[order(max_freq_payMet_by_art_train$id),]
max_freq_payMet_by_art_train<-data.frame(max_freq_payMet=max_freq_payMet_by_art_train$max_freq,max_freq_payMet=max_freq_payMet_by_art_train$max.freq_payMet)

###Merge with class data
max_freq_payMet_by_art_class<-merge(class,Max_art_payMet)
max_freq_payMet_by_art_class<-max_freq_payMet_by_art_class[order(max_freq_payMet_by_art_class$id),]
max_freq_payMet_by_art_class<-data.frame(max_freq_payMet=max_freq_payMet_by_art_class$max_freq,max_freq_payMet=max_freq_payMet_by_art_class$max.freq_payMet)

######################################
#####Names max_freq paymentMethod by article
###train set:
max_freq_payMet_by_art_train
#class set:
max_freq_payMet_by_art_class

########## Data set to export train
freq_payMet_by_art_train<-cbind(freq.art_payMet_train,max_freq_payMet_by_art_train[,1])
colnames(freq_payMet_by_art_train)=c("Freq","Max Freq")
most_freq_payMet_by_art_train<-max_freq_payMet_by_art_train[,2]
#names(most_freq_color_by_order_train)="Most Freq Color"
########## Data set to export class
freq_payMet_by_art_class<-cbind(freq.art_payMet_class,max_freq_payMet_by_art_class[,1])
colnames(freq_payMet_by_art_class)=c("Freq","Max Freq")
most_freq_payMet_by_art_class<-max_freq_payMet_by_art_class[,2]
#colnames(most_freq_color_by_order_class)=c("Most Freq Color")

table(is.na(freq_color_by_art_train))
table(is.na(freq_color_by_art_class))

####Write the files
write.csv(freq_payMet_by_art_train,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/freq_payMet_by_art_train.csv",row.names=FALSE)
write.csv(freq_payMet_by_art_class,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/freq_payMet_by_art_class.csv",row.names=FALSE)
write.csv(most_freq_payMet_by_art_train,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/most_freq_payMet_by_art_train.csv",row.names=FALSE)
write.csv(most_freq_payMet_by_art_class,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/most_freq_payMet_by_art_class.csv",row.names=FALSE)

