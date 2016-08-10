
trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn.5lv<-trn
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

library(C50)
set.seed(100)


fit <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10)
# summary(fit)
p <- predict(fit, tst[, -1], type="class" )
1- sum(p == tst[, 1]) / length(p)
C5imp(fit, metric = "usage", pct = TRUE)
d <- C5imp(fit, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_trial10_v03.csv")

fit.Rule <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rules = T)
# summary(fit.Rule)
p.Rule <- predict(fit.Rule, tst[, -1], type="class" )
1- sum(p.Rule == tst[, 1]) / length(p.Rule)
C5imp(fit.Rule, metric = "usage", pct = TRUE)


fit.Ruleb <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), rules = TRUE, trial = 10, control = C5.0Control(bands = 20))
# summary(fit.Ruleb)
p.Ruleb <- predict(fit.Ruleb, tst[, -1], type="class" )
1- sum(p.Ruleb == tst[, 1]) / length(p.Ruleb)
C5imp(fit.Ruleb, metric = "usage", pct = TRUE)







#### 5 levels
fit.5lv <- C50::C5.0(trn.5lv[, -1], as.factor(trn.5lv[, 1]), trial = 15)
# summary(fit.5lv)
p.5lv <- predict(fit.5lv, tst[, -1], type="class" )
1- sum(p.5lv == tst[, 1]) / length(p.5lv)
C5imp(fit.5lv, metric = "usage", pct = TRUE)






