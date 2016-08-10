# =============================================================================
# File Name:     06_conditional_rf.R
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 18-04-2016
# Last Modified: Thu Apr 21 18:24:03 2016
# =============================================================================

library(party)

cat("Reading data\n")
train = read.csv('/work/STAT/epwalsh/ISU-DMC/data/featureMatrix_v05/train.csv')
test = read.csv('/work/STAT/epwalsh/ISU-DMC/data/featureMatrix_v05/test.csv')

# Remove NA's for now
train = train[complete.cases(train),]
test = test[complete.cases(test),]

cat("Training model\n")
cf = cforest(returnQuantity~., data=train, control=cforest_unbiased(mtry=20, ntree=200))

cat("Making predictions\n")
pred = predict(cf, newdata=test)

cat("Saving raw predictions\n")
write.csv(pred, 'predictions.csv', row.names=FALSE)

cat("Calculating variable importances\n")
vImp = varimp(cf)
impDF = data.frame(var=names(vImp), imp=as.numeric(vImp))
write.csv(impDF, 'epwalsh_conditional_rf_v02b.csv', row.names=FALSE)

pred[pred > 0.5] = 1
pred[pred <= 0.5] = 0
cat("Error: ")
cat(mean(abs(pred - test$returnQuantity)))
