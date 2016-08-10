# this part of code select the most important "raw features" 
#based on the first 200 features from xgboost
########################################################################################
#Part 1
#set the n=200 most imporant feature (including llr)
n=200
###get the data
imp <- read.table("/Users/LiQi/Desktop/haozhe_xgboost_binary_hanye_V1.csv", header=T, sep=",")

imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)
# because llr has two feature in a row, I subset the llr part
imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

# delete "llr_"
imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))
featurelist_binaryV1<-unique(rbind(b1,b2,b3))
#featurelist_binaryV1$llr[featurelist_binaryV1$feature %in% b3$feature]<-1

########################################################################################
#Part 2
###get the data
imp <- read.table("/Users/LiQi/Desktop/haozhe_xgboost_binary_hanye_V2.csv", header=T, sep=",")
imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)

imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))

featurelist_binaryV2<-unique(rbind(b1,b2,b3))

featurelist_binary<-unique(rbind(featurelist_binaryV1,featurelist_binaryV2))

################################################################################################
################################################################################################
#Part 3
###get the data
imp <- read.table("/Users/LiQi/Desktop/mxjki_xgboost_hanye_V1.csv", header=T, sep=",")
imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)

imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))

featurelist_reg_V1<-unique(rbind(b1,b2,b3))

############################################
########################################################################################
#Part 4
###get the data
imp <- read.table("/Users/LiQi/Desktop/mxjki_xgboost_hanye_V2.csv", header=T, sep=",")
imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)

imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))

featurelist_reg_V2<-unique(rbind(b1,b2,b3))

featurelist_reg<-unique(rbind(featurelist_reg_V1,featurelist_reg_V2))

################################################################################################
################################################################################################
featurelist_all<-unique(rbind(featurelist_reg,featurelist_binary),row.names=F,header=F)
#row.names(featurelist_all)<-seq(1:length(featurelist_all$feature))
write.csv(featurelist_all, file = "/Users/LiQi/Desktop/featurelist_combine.csv",row.names=F)




################################################################################################
################################################################################################
########### C50   ########
#######################
#set the n=200 most imporant feature (including llr)
n=200
#Part 1
###get the data
imp <- read.table("/Users/LiQi/Desktop/keguoh_C50_hanye_V1.csv", header=T, sep=",")

imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)
# because llr has two feature in a row, I subset the llr part
imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

# delete "llr_"
imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))
featurelist_C50_V1<-unique(rbind(b1,b2,b3))

############
#Part 2
###get the data
imp <- read.table("/Users/LiQi/Desktop/keguoh_C50_hanye_V2.csv", header=T, sep=",")

imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)
# because llr has two feature in a row, I subset the llr part
imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

# delete "llr_"
imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))
featurelist_C50_V2<-unique(rbind(b1,b2,b3))
############
#Part 3
###get the data
imp <- read.table("/Users/LiQi/Desktop/keguoh_C50_hanye_V3.csv", header=T, sep=",")

imp<-imp[1:n,]
imp$llr<-substr(imp$Feature,1,3)
# because llr has two feature in a row, I subset the llr part
imp_llr<-subset(imp,imp$llr=="llr")
imp_llr0<-subset(imp,imp$llr!="llr")

# delete "llr_"
imp_llr$Feature0<-substr(imp_llr$Feature,5,100)

# seperate the feature by "_x_"
a<-strsplit(as.character(imp_llr$Feature0), "_x_")

a<-as.data.frame(a)
a<-t(a)
b1<-as.data.frame(unique(a[,1]))
names(b1)<-"feature"
b1$llr<-rep(0,length(b1$feature))
b2<-as.data.frame(unique(a[,2]))
names(b2)<-"feature"
b2$llr<-rep(0,length(b2$feature))
b3<-as.data.frame(unique(imp_llr0$Feature))
names(b3)<-"feature"
b3$llr<-rep(1,length(b3$feature))
featurelist_C50_V3<-unique(rbind(b1,b2,b3))


featurelist_C50_V123<-unique(rbind(featurelist_C50_V1,featurelist_C50_V2,featurelist_C50_V3))

featurelist_C50_V12<-unique(rbind(featurelist_C50_V1,featurelist_C50_V2))
featurelist_C50_Xgboost<-unique(rbind(featurelist_C50_V123,featurelist_all))

write.csv(featurelist_C50_V123, file = "/Users/LiQi/Desktop/featurelist_C50_V1V2V3combine.csv",row.names=F)
write.csv(featurelist_C50_Xgboost, file = "/Users/LiQi/Desktop/featurelist_C50_Xgboost_combine.csv",row.names=F)
