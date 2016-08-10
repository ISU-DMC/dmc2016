
trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn.5lv<-trn
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

library(C50)
set.seed(8)


############    trial = 10
fit <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10)
# summary(fit)
p <- predict.C5.0(fit, tst[, -1], type="class" )
1- sum(p == tst[, 1]) / length(p)
C5imp(fit, metric = "usage", pct = TRUE)
d <- C5imp(fit, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_v03.csv")


fit.f <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE))
# summary(fit.f)
p.f <- predict.C5.0(fit.f, tst[, -1], type="class" )
1- sum(p.f == tst[, 1]) / length(p.f)
C5imp(fit.f, metric = "usage", pct = TRUE)


fit.f.GP <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
# summary(fit.f.GP)
p.f.GP <- predict.C5.0(fit.f.GP, tst[, -1], type="class" )
1- sum(p.f.GP == tst[, 1]) / length(p.f.GP)
C5imp(fit.f.GP, metric = "usage", pct = TRUE)


#### 5 levels
fit.5lv <- C50::C5.0(trn.5lv[, -1], as.factor(trn.5lv[, 1]), trial = 10)
# summary(C50.fit10.5lv)
p.5lv <- predict(fit.5lv, tst[, -1], type="class" )
1- sum(p.5lv == tst[, 1]) / length(p.5lv)
C5imp(fit.5lv, metric = "splits", pct = TRUE)

################################# Rule sets

############    trial = 10
Rule10 <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rules = T)
# summary(Rule10)
Rule.prdt10 <- predict(Rule10, tst[, -1], type="class" )
1- sum(Rule.prdt10 == tst[, 1]) / length(Rule.prdt10)
C5imp(Rule10, metric = "usage", pct = TRUE)
table(Rule.prdt10)
d <- C5imp(Rule10, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_Rule-trial10_v03.csv")
