# Stacked Bar Plot with Colors and Legend
library(ggplot2)
library(reshape2)
d<-read.csv(file="/Users/manjujohny/dmc2016/data/raw_data/orders_train.txt",header=TRUE, sep=";")
f<-read.csv("/Users/manjujohny/Documents/Features/ForPlots/epwalsh_orders/epwalsh_orders_train.csv",header=TRUE)

f$returnQuantity<-d$returnQuantity
f$returnQuantity[f$returnQuantity>1]<-1

M<-mean(f$returnQuantity)
F1<-mean(f$returnQuantity[f$sameArticleDiffSize==1])
F2<-mean(f$returnQuantity[f$sameProductDiffSize==1])
summary(f$returnQuantity)

##segmented barchart
data<-NULL
data$return<-c("Returned","Not Returned")
data<-data.frame(data)
data
data$sameArticleDiffSize<-c(F1, 1-F1)
data$sameProductDiffSize<-c(F2, 1-F2)
data$marginal<-c(M, 1-M)
mdata<-melt(data, id.vars="return")
levels(mdata$variable)<-c("sameArticleDiffSize", "sameProductDiffSize", "Overall")

library(RColorBrewer)
brewer.pal(12, "RdGy")
display.brewer.pal(12,"RdGy")
ggplot(mdata, aes(x = variable, y = value, fill = as.factor(return))) +
  geom_bar(stat = 'identity')+xlab("") +
  ylab("") +
  guides(fill=guide_legend(title=NULL))+theme_light() +
  scale_fill_discrete(breaks=c("Returned", "Not Returned"),
                      labels=c("Returned", "Not Returned")) +
  coord_flip() +
  scale_fill_manual(values = c("#E0E0E0", "#67001F")) + 
  theme(axis.text = element_text(size = 20)) +
  theme(legend.text = element_text( size = 20))
