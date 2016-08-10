setwd("C:/Users/huangke/Documents/GitHub/dmc2016/users/keguoh/featureMatrix_v01")
trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")

# analyse data
trn$returned <- as.numeric(trn$returnQuantity > 0)
tst$returned <- as.numeric(tst$returnQuantity > 0)
names(trn)
apply(is.na.data.frame(trn), 2, sum)
# delete orderDate_day_of_total, duplicate with orderDate_day_of_year
returned <- as.numeric(trn$returnQuantity > 0)
trn1 <- cbind(returned, trn[c("quantity","price","rrp","voucherAmount","repeatOrderSameSize","sameArticleDiffSize",           
                                  "sameArticleDiffColor","sameProductDiffSize","discountProp","orderDate_day_of_month",
                                  "orderDate_day_of_year","orderDate_interval_by_article",
                                  "orderDate_interval_by_customer","total_quantity_per_order","total_quantity_per_article",
                                  "total_quantity_per_customer")])
returned <- as.numeric(tst$returnQuantity > 0)
tst1 <- cbind(returned, tst[c("quantity","price","rrp","voucherAmount","repeatOrderSameSize","sameArticleDiffSize",           
                              "sameArticleDiffColor","sameProductDiffSize","discountProp","orderDate_day_of_month",
                              "orderDate_day_of_year","orderDate_interval_by_article",
                              "orderDate_interval_by_customer","total_quantity_per_order","total_quantity_per_article",
                              "total_quantity_per_customer")])


# 1. logstic
# (1). full feature
# frml <- as.formula(paste("returned ~ ", paste(names(trn)[-c(1,37)], collapse= "+")))
frml1 <- as.formula("returned ~ quantity+price+rrp+voucherAmount+repeatOrderSameSize+sameArticleDiffSize+sameArticleDiffColor+sameProductDiffSize+discountProp+orderDate_day_of_month+orderDate_day_of_year+orderDate_interval_by_article+orderDate_interval_by_customer+total_quantity_per_order+total_quantity_per_article+total_quantity_per_customer")
lgst <- glm(frml1, data = trn, family = binomial)
summary(lgst)
lgst.prdt <- as.numeric(predict(lgst, trn, type = "response") > 0.5)
head(table(lgst.prdt[!is.na(trn$rrp)], trn$returnQuantity[!is.na(trn$rrp)]))
1 - mean(lgst.prdt[!is.na(trn$rrp)] == trn$returnQuantity[!is.na(trn$rrp)]) # training error = 0.3685959

lgst.prdt.tst <- as.numeric(predict(lgst, tst, type = "response") > 0.5)  #can use both tst and tst1
head(table(lgst.prdt.tst[!is.na(tst$rrp)], tst$returnQuantity[!is.na(tst$rrp)]))
1 - mean(lgst.prdt.tst[!is.na(tst$rrp)] == tst$returnQuantity[!is.na(tst$rrp)])  # testing error = 0.367436

# (2). sig features
# delete repeatOrderSameSize, orderDate_day_of_month, orderDate_interval_by_article
frml2 <- as.formula("returned ~ quantity+price+rrp+voucherAmount+sameArticleDiffSize+sameArticleDiffColor+sameProductDiffSize+discountProp+orderDate_day_of_year+orderDate_interval_by_customer+total_quantity_per_order+total_quantity_per_article+total_quantity_per_customer")
lgst <- glm(frml2, data = trn, family = binomial)
summary(lgst)
lgst.prdt <- as.numeric(predict(lgst, trn, type = "response") > 0.5)
head(table(lgst.prdt[!is.na(trn$rrp)], trn$returnQuantity[!is.na(trn$rrp)]))
1 - mean(lgst.prdt[!is.na(trn$rrp)] == trn$returnQuantity[!is.na(trn$rrp)]) # training error = 0.3685648

lgst.prdt.tst <- as.numeric(predict(lgst, tst, type = "response") > 0.5)  #can use both tst and tst1
head(table(lgst.prdt.tst[!is.na(tst$rrp)], tst$returnQuantity[!is.na(tst$rrp)]))
1 - mean(lgst.prdt.tst[!is.na(tst$rrp)] == tst$returnQuantity[!is.na(tst$rrp)])  # testing error = 0.3671527

