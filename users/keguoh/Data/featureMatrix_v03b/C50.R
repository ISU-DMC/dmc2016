library(C50)
set.seed(8)
############################################ v03

trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn.5lv<-trn
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

############    trial = 10
fit <- C50::C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10)
# summary(fit)
p <- predict(fit, tst[, -1], type="class" )
1- sum(p == tst[, 1]) / length(p)

d <- C5imp(fit, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh_C50_v03b.csv")



fit.w <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(winnow = TRUE))
# summary(fit.w)
p.w <- predict(fit.w, tst[, -1], type="class" )
1- sum(p.w == tst[, 1]) / length(p.w)

d.w <- C5imp(fit.w, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.w), Usage = d.w, row.names = NULL), file = "keguoh_C50_10trial_winnow_v03b.csv")


fit.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE))
# summary(fit.f)
p.f <- predict(fit.f, tst[, -1], type="class" )
1- sum(p.f == tst[, 1]) / length(p.f)
d.f <- C5imp(fit.f, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.f), Usage = d.f, row.names = NULL), file = "keguoh_C50_10trial_winnow_v03b.csv")


fit.f.GP <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
# summary(fit.f.GP)
p.f.GP <- predict(fit.f.GP, tst[, -1], type="class" )
1- sum(p.f.GP == tst[, 1]) / length(p.f.GP)
d.f.GP <- C5imp(fit.f.GP, metric = "usage", pct = TRUE)
