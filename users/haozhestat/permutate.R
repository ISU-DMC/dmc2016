name_list=read.csv("train_reduce.csv",nrow=1)
A=colnames(name_list)

class_name_list=read.csv("class_reduce.csv")
B=colnames(class_name_list)

which(A==B)
write.csv(reduce_class,"class_reduce.csv",row.names=F)
