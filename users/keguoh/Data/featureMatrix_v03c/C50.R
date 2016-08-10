library(C50)
set.seed(8)
############################################ v03

trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)


trn1 <- trn[1:(nrow(trn)/5), ]
idx <- cut(1:nrow(trn), breaks = 4, labels = F)
############    trial = 10

imp<-list()
for(i in 5:5){
  trntemp <- trn[idx == i, ]
  fittemp <- C50::C5.0(trntemp[, -1], as.factor(trntemp[, 1]), trial = 10)
  imp[[i]] <- C50::C5imp(fittemp, metric = "usage", pct = TRUE)
}

ranks <- apply(rbind(t(imp[[1]]),t(imp[[2]]),t(imp[[3]]),t(imp[[4]])), 2, mean)
kept <- names(ranks)[ranks>10]  #kept
names(ranks)[ranks<=10]         #deleted!

fit176 <- C50::C5.0(trn[, kept], as.factor(trn[, 1]), trial = 10)
# summary(C50.fit10)
prdt10 <- predict(C50.fit10, tst[, -1], type="class" )
1- sum(prdt10 == tst[, 1]) / length(prdt10)

d <- C50::C5imp(C50.fit10, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_10trial_v03b.csv")



C50.fit10w <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(winnow = TRUE))
# summary(C50.fit10w)
prdt10w <- predict(C50.fit10w, tst[, -1], type="class" )
1- sum(prdt10w == tst[, 1]) / length(prdt10w)

d <- C5imp(C50.fit10w, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_10trial_winnow_v03b.csv")





C50.fit10f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE))
# summary(C50.fit10w)
prdt10f <- predict(C50.fit10f, tst[, -1], type="class" )
1- sum(prdt10f == tst[, 1]) / length(prdt10f)

d <- C5imp(C50.fit10f, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_10trial_winnow_v03b.csv")

