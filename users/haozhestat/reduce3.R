reduce_name_list=read.csv("featurelist_new_V1_select_combine.csv")

first_line=read.csv("train.csv",nrow=1)
full_name_list=colnames(first_line)
full_name_list=full_name_list[-1]

A=rep(NA,1539)

A[-which(full_name_list%in%reduce_name_list$x)]="NULL"

reduce_train=read.csv("train.csv",colClasses=c(NA,A))

write.csv(reduce_train,"train_reduce.csv",row.names=F)
