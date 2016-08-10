kC50 <- read.table("keguoh_C50.csv", header = T, sep = ",")
mLDA <- read.table("mjohny_LDA.csv", header = T, sep = ",")
Fact <- read.table("actual.csv", sep = ",")
exgb <- read.table("epwalsh_xgboost.csv", head = T, sep = ",")
erfC <- read.table("epwalsh_randomForestClassifier.csv", head = T, sep = ",")
test <- read.table("test.csv", head = T, sep = ",")

exgb.wgt <- exgb$binary
exgb.wgt[exgb.wgt == 1] <- 1.1
exgb.wgt[exgb.wgt == 0] <- -0.1
pred <- kC50$binary + mLDA$binary + exgb.wgt + erfC$binary
table(pred)
p <- pred
p[p<2] <- 0
p[p>=2] <- 1
table(p)

1 - sum(p == test$returnQuantity)/length(p)
1 - sum(p == Fact)/length(p)

1 - sum(exgb$binary == test$returnQuantity)/length(p)


pred2 <- kC50$binary + exgb$binary + erfC$binary
table(pred2)
p2 <- pred
p2[p2<1.5] <- 0
p2[p2>=1.5] <- 1
table(p2)
1 - sum(p2 == Fact)/length(p2)
