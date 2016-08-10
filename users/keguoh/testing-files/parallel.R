#C50rule - pete
library(C50)

trn <- read.table("train.csv", header = T, sep = ",")
trn5 <- trn
tst <- read.table("test.csv", header = T, sep = ",")
tst5 <- tst
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)
tst$returnQuantity <- as.numeric(tst$returnQuantity > 0)
cls <- read.table("xgboost_class.csv", header = T, sep = ",")
# cls <- tst[1:10000,-1]

x=
fit <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = x, rule = TRUE)
p_prob <- C50::predict.C5.0(fit, tst[, -1], type="prob")
p_bnry <- C50::predict.C5.0(fit, tst[, -1], type="class")
err <- 1- sum(p_bnry == tst5[, 1]) / length(p_bnry)
err
write.csv(p_bnry, row.names = F, file = "C50_pred_test_binary.csv")
write.csv(p_prob, row.names = F, file = "C50_pred_test_probability.csv")




#C50rule - pete, class
library(C50)

trn <- read.table("train.csv", header = T, sep = ",")
trn5 <- trn
tst <- read.table("test.csv", header = T, sep = ",")
tst5 <- tst
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)
tst$returnQuantity <- as.numeric(tst$returnQuantity > 0)
cls <- read.table("xgboost_class.csv", header = T, sep = ",")
# cls <- tst[1:10001,-1]

x=50
cmb <- rbind(trn, tst)
fitcmb <- C50::C5.0(cmb[, -1], as.factor(cmb[, 1]), trial = x, rule = TRUE)
save.image()

idx <- cut(1:nrow(cls), breaks = 5, labels = F)
p1_prob <- C50::predict.C5.0(fitcmb, cls[idx == 1,], type="prob")
p2_prob <- C50::predict.C5.0(fitcmb, cls[idx == 2,], type="prob")
p3_prob <- C50::predict.C5.0(fitcmb, cls[idx == 3,], type="prob")
p4_prob <- C50::predict.C5.0(fitcmb, cls[idx == 4,], type="prob")
p5_prob <- C50::predict.C5.0(fitcmb, cls[idx == 5,], type="prob")
pcls_prob <- rbind(p1_prob, p2_prob, p3_prob, p4_prob, p5_prob)
save.image()
p1_class <- C50::predict.C5.0(fitcmb, cls[idx == 1,], type="class")
p2_class <- C50::predict.C5.0(fitcmb, cls[idx == 2,], type="class")
p3_class <- C50::predict.C5.0(fitcmb, cls[idx == 3,], type="class")
p4_class <- C50::predict.C5.0(fitcmb, cls[idx == 4,], type="class")
p5_class <- C50::predict.C5.0(fitcmb, cls[idx == 5,], type="class")
pcls_class <- c(p1_class, p2_class, p3_class, p4_class, p5_class)-1

write.csv(pcls_class, row.names = F, file = "C50_pred_class_binary.csv")
write.csv(pcls_prob, row.names = F, file = "C50_pred_class_probability.csv")

# idx <- cut(1:nrow(cls), breaks = 5, labels = F)
# pcls_prob <- data.frame(matrix(0,nrow(cls),2)
# pcls_bnry <- data.frame(x = rep(0.1,nrow(cls)))
# for(i in 1:1){
#   pcls_prob[idx %in% c(i),] <- C50::predict.C5.0(fitcmb, cls[idx %in% c(i),], type="prob")
#   pcls_bnry[idx %in% c(i)] <- C50::predict.C5.0(fitcmb, cls[idx %in% c(i),], type="class")
# }


write.csv(pcls_bnry, row.names = F, file = "C50_pred_class_binary.csv")
write.csv(pcls_prob, row.names = F, file = "C50_pred_class_probability.csv")








(no_cores <- detectCores())
cl <- makeCluster(no_cores)
clusterExport(cl, c("trn", "tst", "tr"))
te <- parLapply(cl, tr, C5)
write.csv(data.frame(error = unlist(te), trial = tr), row.names = F, file = "Error_C50rule1.csv") #name it!
stopCluster(cl)

#C50rule2
library(C50)
library(parallel)

C5 <- function(x){  #insert function
  ff <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = x, rule = TRUE)
  pp <- C50::predict.C5.0(ff, tst[, -1], type="class")
  a <- 1- sum(pp == tst[, 1]) / length(pp)    
  return(a)}
tr <- 41:56 #define 

(no_cores <- detectCores())
cl <- makeCluster(no_cores)
clusterExport(cl, c("trn", "tst", "tr"))
te <- parLapply(cl, tr, C5)
write.csv(data.frame(error = unlist(te), trial = tr), row.names = F, file = "Error_C50rule2.csv") #name it!
stopCluster(cl)
