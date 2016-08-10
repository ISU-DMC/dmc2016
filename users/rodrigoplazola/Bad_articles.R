###########################################################
################### Bad articles ##########################
############ return rate bigger that non return rate ######
setwd("/Users/rodrigoplazolaortiz/Desktop/Data Mining cup 2016/raw_data")

#Training data
data<-read_delim("orders_train.txt",";")

table.ob<-as.data.frame.matrix(table(data$articleID,data$returnQuantity))
rates<-round(table/rowSums(table),5)

bad.articles<-table[which(rates[,1]-rowSums(rates[,c(2:6)])<0),]
names.bad<-row.names(bad.articles)

feture.vect<-rep(1,dim(data)[1])
for(i in 1:length(names.bad)){
x<-which(data$articleID==names.bad[i])
feture.vect[x]<-0
}

good_art<-data.frame(good_art_1=feture.vect)

#test NA values
table(is.na(good_art))

write.csv(good_art,file="rodrigoplazola_good.art_train.csv")

############# For class data set

data.test<-read_delim("orders_class.txt",";")

feture.vect.class<-rep(1,dim(data.test)[1])
for(i in 1:length(names.bad)){
x<-which(data.test$articleID==names.bad[i])
feture.vect.class[x]<-0
}

good_art.class<-data.frame(good_art=feture.vect.class)

#Test NA values
table(is.na(good_art.class))

write.csv(good_art.class,file="rodrigoplazola_good.art_class.csv")
