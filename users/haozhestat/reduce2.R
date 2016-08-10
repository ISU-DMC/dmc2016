reduce_name_list=read.csv("featurelist_new_V1_select_combine.csv")

first_line=read.csv("class.csv",nrow=1)
full_name_list=colnames(first_line)

A=rep(NA,1539)

A[-which(full_name_list%in%reduce_name_list$x)]="NULL"

reduce_class=read.csv("class.csv",colClasses=A)

write.csv(reduce_class,"class_reduce.csv",row.names=F)
