#number of features to choose
n=200
###############################################################
#Regression versions
#Regression V1
dat1=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Importance Data/mxjki_xgboost_hanye_V1.csv",sep=",")
dat1=as.vector(dat1[1:n,1])
dat1_llr=subset(dat1,substr(dat1,1,3)=="llr")
dat1_not_llr=subset(dat1,substr(dat1,1,3)!="llr")
dat1_llr_c1=rep(0,length(dat1_llr))
dat1_llr_c2=rep(0,length(dat1_llr))
for(i in 1:length(dat1_llr))
{
  dat1_llr_c1[i]=strsplit(sapply(strsplit(dat1_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][1]
  dat1_llr_c2[i]=strsplit(sapply(strsplit(dat1_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][2]
}
f1=unique(dat1_not_llr)
f2=unique(dat1_llr_c1)
f3=unique(dat1_llr_c2)
feature1=unique(c(f1,f2,f3))
###############################################################
#Regression V2
dat2=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Importance Data/mxjki_xgboost_hanye_V2.csv",sep=",")
dat2=as.vector(dat2[1:n,1])
dat2_llr=subset(dat2,substr(dat2,1,3)=="llr")
dat2_not_llr=subset(dat2,substr(dat2,1,3)!="llr")
dat2_llr_c1=rep(0,length(dat2_llr))
dat2_llr_c2=rep(0,length(dat2_llr))
for(i in 1:length(dat2_llr))
{
  dat2_llr_c1[i]=strsplit(sapply(strsplit(dat2_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][1]
  dat2_llr_c2[i]=strsplit(sapply(strsplit(dat2_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][2]
}
f1=unique(dat2_not_llr)
f2=unique(dat2_llr_c1)
f3=unique(dat2_llr_c2)
feature2=unique(c(f1,f2,f3))
###############################################################
#Binary versions
#Binary V1
dat3=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Importance Data/haozhe_xgboost_binary_hanye_V1.csv",sep=",")
dat3=as.vector(dat3[1:n,1])
dat3_llr=subset(dat3,substr(dat3,1,3)=="llr")
dat3_not_llr=subset(dat3,substr(dat3,1,3)!="llr")
dat3_llr_c1=rep(0,length(dat3_llr))
dat3_llr_c2=rep(0,length(dat3_llr))
for(i in 1:length(dat3_llr))
{
  dat3_llr_c1[i]=strsplit(sapply(strsplit(dat3_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][1]
  dat3_llr_c2[i]=strsplit(sapply(strsplit(dat3_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][2]
}
f1=unique(dat3_not_llr)
f2=unique(dat3_llr_c1)
f3=unique(dat3_llr_c2)
feature3=unique(c(f1,f2,f3))
###############################################################
#Binary V2
dat4=read.csv("C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Importance Data/haozhe_xgboost_binary_hanye_V2.csv",sep=",")
dat4=as.vector(dat4[1:n,1])
dat4_llr=subset(dat4,substr(dat4,1,3)=="llr")
dat4_not_llr=subset(dat4,substr(dat4,1,3)!="llr")
dat4_llr_c1=rep(0,length(dat4_llr))
dat4_llr_c2=rep(0,length(dat4_llr))
for(i in 1:length(dat4_llr))
{
  dat4_llr_c1[i]=strsplit(sapply(strsplit(dat4_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][1]
  dat4_llr_c2[i]=strsplit(sapply(strsplit(dat4_llr,split="llr_",fixed=TRUE),'[[',2),"_x_",fixed=TRUE)[[i]][2]
}
f1=unique(dat4_not_llr)
f2=unique(dat4_llr_c1)
f3=unique(dat4_llr_c2)
feature4=unique(c(f1,f2,f3))
###############################################################
#Combining the features
feature=as.data.frame(na.omit(unique(c(feature1,feature2,feature3,feature4))))
names(feature)="Feature"
#Writing as a csv file, change value of n
write.csv(feature,file="C:/Users/acxav/Desktop/Spring 2016/Dmc2016/MyData/Importance Data/combine_200.csv",row.names=FALSE)