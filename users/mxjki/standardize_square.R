setwd("~/Downloads/num/")
names="epwalsh_articleDays"

dmcclass=read.csv(paste0(names,"_class.csv"))
dmcclasssq=dmcclass^2
sddmcclasssq=dmcclasssq/matrix(rep(sqrt(colSums(dmcclasssq^2)),each=dim(dmcclasssq)[1]),ncol=3)

colnames(sddmcclasssq)=paste0(colnames(dmcclass),"_sdsquare")

write.csv(sddmcclasssq,paste0(names,"_sdsquare_class.csv"),row.names=F)


dmctrain=read.csv(paste0(names,"_train.csv"))
dmctrainsq=dmctrain^2
sddmctrainsq=dmctrainsq/matrix(rep(sqrt(colSums(dmctrainsq^2)),each=dim(dmctrainsq)[1]),ncol=3)

colnames(sddmctrainsq)=paste0(colnames(dmctrain),"_sdsquare")

write.csv(sddmctrainsq,paste0(names,"_sdsquare_train.csv"),row.names=F)