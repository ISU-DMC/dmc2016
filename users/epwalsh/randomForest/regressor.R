# =============================================================================
# File Name:     regression.R
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 23-04-2016
# Last Modified: Sat Apr 23 15:33:24 2016
# =============================================================================

library(randomForest)
library(readr)
library(foreach)

cat("Reading data...\n")
train = read_csv('/work/STAT/epwalsh/ISU-DMC/data/featureMatrix_v03/train.csv')
test = read_csv('/work/STAT/epwalsh/ISU-DMC/data/featureMatrix_v03/test.csv')

cat("Removing NA's\n")
train = train[complete.cases(train),]
test = test[complete.cases(test),]

cat("Training forest\n")
rf <- foreach(ntree=rep(100, 8), .combine=combine, .packages='randomForest') %dopar% {
  randomForest(train[-1], train$returnQuantity, ntree=ntree)
}
rf

cat("Creating predictions\n")
preds <- predict(rf, newdata=test[-1])
bin_preds <- preds
bin_preds[bin_preds >= 0.5] <- 1
bin_preds[bin_preds < 0.5] <- 0

cat("Mean absolute error: ")
cat(mean(abs(bin_preds - test$returnQuantity)))
