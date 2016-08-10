library(C50)
set.seed(8)
############################################ v05

trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
cls <- read.table("class.csv", header = T, sep = ",")
trn.5lvl<-trn
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

############    trial = 10
fit <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10)
p <- predict(fit, tst[, -1], type="class" )
(te <- 1- sum(p == tst[, 1]) / length(p))
d <- C5imp(fit, metric = "usage", pct = TRUE)
# write.csv(data.frame(Features = rownames(d), Usage = d, row.names = NULL), file = "keguoh.C50.v05.csv")
# summary(fit)

fit.w <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(winnow = TRUE))
p.w <- predict(fit.w, tst[, -1], type="class" )
(te.w <- 1- sum(p.w == tst[, 1]) / length(p.w))
d.w <- C5imp(fit.w, metric = "usage", pct = TRUE)
# write.csv(data.frame(Features = rownames(d.w), Usage = d.w, row.names = NULL), file = "keguoh.C50.winnow.v05.csv")
# summary(fit.w)

fit.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE))
p.f <- predict(fit.f, tst[, -1], type="class" )
(te.f <- 1- sum(p.f == tst[, 1]) / length(p.f))
d.f <- C5imp(fit.f, metric = "usage", pct = TRUE)
# write.csv(data.frame(Features = rownames(d.f), Usage = d.f, row.names = NULL), file = "keguoh.C50.fuzzy.v05.csv")
# summary(fit.f)

fit.fs <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(subset = FALSE, fuzzyThreshold = TRUE))
p.fs <- predict(fit.fs, tst[, -1], type="class" )
(te.fs <- 1- sum(p.fs == tst[, 1]) / length(p.fs))


fit.f.early <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, earlyStopping = FALSE))
p.f.early <- predict(fit.f.early, tst[, -1], type="class" )
(te.f.early <- 1- sum(p.f.early == tst[, 1]) / length(p.f.early))


fit.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE))
p.Rule.f <- predict(fit.Rule.f, tst[, -1], type="class" )
(te.Rule.f <- 1- sum(p.Rule.f == tst[, 1]) / length(p.Rule.f))
d.Rule.f <- C5imp(fit.Rule.f, metric = "usage", pct = TRUE)
# write.csv(data.frame(Features = rownames(d.Rule.f), Usage = d.Rule.f, row.names = NULL), file = "keguoh.Rule.fuzzy.v05.csv")
# summary(fit.Rule.f)


fit.f.GP <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
p.f.GP <- predict(fit.f.GP, tst[, -1], type="class" )
(te.f.GP <- 1- sum(p.f.GP == tst[, 1]) / length(p.f.GP))
d.f.GP <- C5imp(fit.f.GP, metric = "usage", pct = TRUE)
# summary(fit.f.GP)



#### other trials
fit.5.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 5, control = C5.0Control(fuzzyThreshold = TRUE))
p.5.f <- predict(fit.5.f, tst[, -1], type="class" )
(te.5.f <- 1- sum(p.5.f == tst[, 1]) / length(p.5.f))
d.5.f <- C5imp(fit.5.f, metric = "usage", pct = TRUE)

fit.15.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 15, control = C5.0Control(fuzzyThreshold = TRUE))
p.15.f <- predict(fit.15.f, tst[, -1], type="class" )
(te.15.f <- 1- sum(p.15.f == tst[, 1]) / length(p.15.f))
d.15.f <- C5imp(fit.15.f, metric = "usage", pct = TRUE)


fit.20.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE))
p.20.f <- predict(fit.20.f, tst[, -1], type="class" )
(te.20.f <- 1- sum(p.20.f == tst[, 1]) / length(p.20.f))
d.20.f <- C5imp(fit.20.f, metric = "usage", pct = TRUE)
# write.csv(data.frame(Features = rownames(d.20.f), Usage = d.f.20, row.names = NULL), file = "keguoh.C50.fuzzy.20trials.v05.csv")
# summary(fit.20.f)


fit.20.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE))
p.20.Rule.f <- predict(fit.20.Rule.f, tst[, -1], type="class" )
(te.20.Rule.f <- 1- sum(p.20.Rule.f == tst[, 1]) / length(p.20.Rule.f))
d.20.Rule.f <- C5imp(fit.20.Rule.f, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.Rule.f), Usage = d.20.Rule.f, row.names = NULL), file = "keguoh.C50.v05.csv")
write.csv(data.frame(binary = p.20.Rule.f, row.names = NULL), file = "keguoh.C50.csv", row.names = FALSE)
dsp.20.Rule.f <- C5imp(fit.20.Rule.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(dsp.20.Rule.f), Splits = dsp.20.Rule.f, row.names = NULL), row.names = FALSE, file = "keguoh.C50.splits.v05.csv")


fit.20.Ruleb.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, rule = TRUE, control = C5.0Control(bands = 20, fuzzyThreshold = TRUE))
p.20.Ruleb.f <- predict(fit.20.Ruleb.f, tst[, -1], type="class" )
(te.20.Ruleb.f <- 1- sum(p.20.Ruleb.f == tst[, 1]) / length(p.20.Ruleb.f))


fit.20.f.GP <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
p.20.f.GP <- predict(fit.20.f.GP, tst[, -1], type="class" )
(te.20.f.GP <- 1- sum(p.20.f.GP == tst[, 1]) / length(p.f.GP))
# summary(fit.20.f.GP)




########################## 5 levels

fit.f.5lvl <-C5.0(trn.5lvl[, -1], as.factor(trn.5lvl[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE))
p.f.5lvl <- predict(fit.f.5lvl, tst[, -1], type="class" )
(te.f.5lvl <- 1- sum(p.f.5lvl == tst[, 1]) / length(p.f.5lvl))
d.f.5lvl <- C5imp(fit.f.5lvl, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.f.5lvl), Usage = d.f.5lvl, row.names = NULL), file = "keguoh.C50.fuzzy5level.v05.csv")
# summary(fit.f.5lvl)
p.f.5lvl.bin <- p.f.5lvl
p.f.5lvl.bin[p.f.5lvl != 0] <- 1
1- sum(p.f.5lvl.bin == tst[, 1]) / length(p.f.5lvl.bin)
write.csv(data.frame(binary = p.f.5lvl.bin, row.names = NULL), file = "keguoh.C50.csv", row.names = FALSE)



fit.f.GP.5lvl <-C5.0(trn.5lvl[, -1], as.factor(trn.5lvl[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
p.f.GP.5lvl <- predict(fit.f.GP.5lvl, tst[, -1], type="class" )
(te.f.GP.5lvl <- 1- sum(p.f.GP.5lvl == tst[, 1]) / length(p.f.GP.5lvl))
d.f.GP.5lvl <- C5imp(fit.f.GP.5lvl, metric = "usage", pct = TRUE)



fit.fw.5lvl <-C5.0(trn.5lvl[, -1], as.factor(trn.5lvl[, 1]), trial = 10, control = C5.0Control(winnow = TRUE, fuzzyThreshold = TRUE))
p.fw.5lvl <- predict(fit.fw.5lvl, tst[, -1], type="class" )
(te.fw.5lvl <- 1- sum(p.fw.5lvl == tst[, 1]) / length(p.fw.5lvl))
d.fw.5lvl <- C5imp(fit.fw.5lvl, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.fw.5lvl), Usage = d.fw.5lvl, row.names = NULL), file = "keguoh.C50.fuzzywinnow5level.v05.csv")
# summary(fit.fw.5lvl)

rbind(t(d.f.5lvl),t(d.fw.5lvl))

#### other trials

fit.20.f.5lvl <-C5.0(trn.5lvl[, -1], as.factor(trn.5lvl[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE))
p.20.f.5lvl <- predict(fit.20.f.5lvl, tst[, -1], type="class" )
(te.20.f.5lvl <- 1- sum(p.20.f.5lvl == tst[, 1]) / length(p.20.f.5lvl))
d.20.f.5lvl <- C5imp(fit.20.f.5lvl, metric = "usage", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.f.5lvl), Usage = d.20.f.5lvl, row.names = NULL), file = "keguoh.C50.fuzzy5level.20trials.v05.csv")
# summary(fit.20.f.5lvl)

fit.20.f.GP.5lvl <-C5.0(trn.5lvl[, -1], as.factor(trn.5lvl[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE, noGlobalPruning = TRUE))
p.20.f.GP.5lvl <- predict(fit.20.f.GP.5lvl, tst[, -1], type="class" )
(te.20.f.GP.5lvl <- 1- sum(p.20.f.GP.5lvl == tst[, 1]) / length(p.20.f.GP.5lvl))
d.20.f.GP.5lvl <- C5imp(fit.20.f.GP.5lvl, metric = "usage", pct = TRUE)
