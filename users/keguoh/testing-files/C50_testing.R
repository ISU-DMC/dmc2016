library(C50)
set.seed(8)

trn <- read.table("train.csv", header = T, sep = ",")
tst <- read.table("test.csv", header = T, sep = ",")
trn$returnQuantity <- as.numeric(trn$returnQuantity > 0)

system.time(expr = fit.20.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE)))
p.20.Rule.f <- predict(fit.20.Rule.f, tst[, -1], type="class" )
(te.20.Rule.f <- 1- sum(p.20.Rule.f == tst[, 1]) / length(p.20.Rule.f))
d.20.Rule.f <- C5imp(fit.20.Rule.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.Rule.f), splits = d.20.Rule.f$Overall, row.names = NULL), row.names = F, file = "Rule_fuzz_20.csv")
save.image()

system.time(expr = fit.10.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE)))
p.10.Rule.f <- predict(fit.10.Rule.f, tst[, -1], type="class" )
(te.10.Rule.f <- 1- sum(p.10.Rule.f == tst[, 1]) / length(p.10.Rule.f))
d.10.Rule.f <- C5imp(fit.10.Rule.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10.Rule.f), splits = d.10.Rule.f$Overall, row.names = NULL), row.names = F, file = "Rule_fuzz_10.csv")
save.image()

write.csv(data.frame(Rule_fuzz_20 = te.20.Rule.f, Rule_fuzz_10 = te.10.Rule.f), file = "te_Rule_fuzz.txt", row.names = F)






system.time(expr = fit.20.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE)))
p.20.f <- predict(fit.20.f, tst[, -1], type="class" )
(te.20.f <- 1- sum(p.20.f == tst[, 1]) / length(p.20.f))
d.20.f <- C5imp(fit.20.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.f), splits = d.20.f$Overall, row.names = NULL), row.names = F, file = "fuzz_20.csv")

system.time(expr = fit.10.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE)))
p.10.f <- predict(fit.10.f, tst[, -1], type="class" )
(te.10.f <- 1- sum(p.10.f == tst[, 1]) / length(p.10.f))
d.10.f <- C5imp(fit.10.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10.f), splits = d.10.f$Overall, row.names = NULL), row.names = F, file = "fuzz_10.csv")

write.csv(data.frame(fuzz_20 = te.20.f, fuzz_10 = te.10.f), file = "te_fuzz.txt", row.names = F)






########

system.time(expr = fit.20 <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20))
p.20 <- predict(fit.20, tst[, -1], type="class" )
(te.20 <- 1- sum(p.20 == tst[, 1]) / length(p.20))
d.20 <- C5imp(fit.20, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20), splits = d.20$Overall, row.names = NULL), row.names = F, file = "20.csv")

system.time(expr = fit.10 <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10))
p.10 <- predict(fit.10, tst[, -1], type="class" )
(te.10 <- 1- sum(p.10 == tst[, 1]) / length(p.10))
d.10 <- C5imp(fit.10, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10), splits = d.10$Overall, row.names = NULL), row.names = F, file = "10.csv")

write.csv(data.frame(tree_20 = te.20, tree_10 = te.10), file = "te.txt", row.names = F)

## fuzz
idx <- cut(1:nrow(trn), breaks = 3, labels = F)
imp<-list()
system.time(expr = for(i in 1:3){
  trntemp <- trn[idx == i, ]
  fittemp <- C50::C5.0(trntemp[, -1], as.factor(trntemp[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE))
  imp[[i]] <- C50::C5imp(fittemp, metric = "splits", pct = TRUE)
  print(i)
})
ranks <- apply(rbind(t(imp[[1]]),t(imp[[2]]),t(imp[[3]])), 2, mean)
kept500 <- names(ranks)[1:500]  #kept
save.image()
write.csv(data.frame(Features = names(ranks), splits = ranks, row.names = NULL), row.names = F,file = "ranks_fuzz_20.csv")

system.time(expr = fit.20.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, control = C5.0Control(fuzzyThreshold = TRUE)))
p.20.f <- predict(fit.20.f, tst[, -1], type="class" )
(te.20.f <- 1- sum(p.20.f == tst[, 1]) / length(p.20.f))
d.20.f <- C5imp(fit.20.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.f), splits = d.20.f$Overall, row.names = NULL), row.names = F, file = "fuzz_20.csv")

system.time(expr = fit.10.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, control = C5.0Control(fuzzyThreshold = TRUE)))
p.10.f <- predict(fit.10.f, tst[, -1], type="class" )
(te.10.f <- 1- sum(p.10.f == tst[, 1]) / length(p.10.f))
d.10.f <- C5imp(fit.10.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10.f), splits = d.10.f$Overall, row.names = NULL), row.names = F, file = "fuzz_10.csv")

write.csv(data.frame(fuzz_20 = te.20.f, fuzz_10 = te.10.f), file = "te_fuzz.txt", row.names = F)



## Rule
system.time(expr = fit.20.Rule <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, rule = TRUE))
p.20.Rule <- predict(fit.20.Rule, tst[, -1], type="class" )
(te.20.Rule <- 1- sum(p.20.Rule == tst[, 1]) / length(p.20.Rule))
d.20.Rule <- C5imp(fit.20.Rule, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.Rule), splits = d.20.Rule$Overall, row.names = NULL), row.names = F, file = "Rule_20.csv")

system.time(expr = fit.10.Rule <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rule = TRUE))
p.10.Rule <- predict(fit.10.Rule, tst[, -1], type="class" )
(te.10.Rule <- 1- sum(p.10.Rule == tst[, 1]) / length(p.10.Rule))
d.10.Rule <- C5imp(fit.10.Rule, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10.Rule), splits = d.10.Rule$Overall, row.names = NULL), row.names = F, file = "Rule_10.csv")

write.csv(data.frame(Rule_20 = te.20.Rule, Rule_10 = te.10.Rule), file = "te_Rule.txt", row.names = F)


#rule-fuzz
idx <- cut(1:nrow(trn), breaks = 3, labels = F)
imp<-list()
system.time(expr = for(i in 1:3){
  trntemp <- trn[idx == i, ]
  fittemp <- C50::C5.0(trntemp[, -1], as.factor(trntemp[, 1]), trial = 20, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE))
  imp[[i]] <- C50::C5imp(fittemp, metric = "splits", pct = TRUE)
  print(i)
})
ranks <- apply(rbind(t(imp[[1]]),t(imp[[2]]),t(imp[[3]])), 2, mean)
kept500 <- names(ranks)[1:500]  #kept
save.image()
write.csv(data.frame(Features = names(ranks), splits = ranks, row.names = NULL), row.names = F,file = "ranks_Rule_fuzz_20.csv")

system.time(expr = fit.20.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 20, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE)))
p.20.Rule.f <- predict(fit.20.Rule.f, tst[, -1], type="class" )
(te.20.Rule.f <- 1- sum(p.20.Rule.f == tst[, 1]) / length(p.20.Rule.f))
d.20.Rule.f <- C5imp(fit.20.Rule.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.20.Rule.f), splits = d.20.Rule.f$Overall, row.names = NULL), row.names = F, file = "Rule_fuzz_20.csv")

system.time(expr = fit.10.Rule.f <- C5.0(trn[, -1], as.factor(trn[, 1]), trial = 10, rule = TRUE, control = C5.0Control(fuzzyThreshold = TRUE)))
p.10.Rule.f <- predict(fit.10.Rule.f, tst[, -1], type="class" )
(te.10.Rule.f <- 1- sum(p.10.Rule.f == tst[, 1]) / length(p.10.Rule.f))
d.10.Rule.f <- C5imp(fit.10.Rule.f, metric = "splits", pct = TRUE)
write.csv(data.frame(Features = rownames(d.10.Rule.f), splits = d.10.Rule.f$Overall, row.names = NULL), row.names = F, file = "Rule_fuzz_10.csv")

write.csv(data.frame(Rule_fuzz_20 = te.20.Rule.f, Rule_fuzz_10 = te.10.Rule.f), file = "te_Rule_fuzz.txt", row.names = F)



