trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn.5lvl<-trn
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

library(class)
all <- rbind(trn, tst)
all[is.na.data.frame(all)] <- 0
std.X <- scale(all[, -1])
trn.X <- std.X[1:nrow(trn), ]
tst.X <- std.X[-(1:nrow(trn)), ]
trn.Y <- trn[, 1]
p10 <- knn(trn.X, tst.X, trn.Y, k = 10)
(te <- 1- sum(p10 == tst[, 1]) / length(p10))
