library("xgboost")
library("Ckmeans.1d.dp")
library("DiagrammeR")
train=read.csv("train.csv",header=T)
test=read.csv("test.csv",header=T)

#llr_customerID all equals to 0 useless
unique(train$llr_customerID)

#fill NA by 0
train[is.na(train)]=0

#fill NA by 0
test[is.na(test)]=0

#construct the evaluate function MAE
evalerror <- function(preds, dtrain) {
  labels <- getinfo(dtrain, "label")
  err <- sum(abs(preds-dtrain))
  return(list(metric = "error", value = err))
}

#initialize parameter settings
param <- list(max_depth=8, 
              eta=0.1, 
              nthread=2, 
              silent=1, 
              objective="reg:linear",
              eval_metric=evalerror)

#prepare the data
dtrain=xgb.DMatrix(as.matrix(train[,-1]),label=train$returnQuantity)
dmcxg=xgb.train(data = dtrain, missing = NULL, params = param,
        nrounds=500, verbose = 1, print.every.n = 1L, early.stop.round = NULL,
        maximize = F)

#View feature importance/influence from the learnt model
importance_matrix <- xgb.importance(feature_names=colnames(train)[-1],model = dmcxg)
print(importance_matrix)
write.csv(importance_matrix,"mxjki_xgboost_hanye_V1_select_V1.csv",row.names=F)
xgb.plot.importance(importance_matrix)

#view the trees from your model
xgb.dump(dmcxg, with.stats = T)

#plot the trees from your model
#xgb.plot.tree(model = dmcxg)

#transform the regression result to binary
predict_binary=as.numeric(predict(dmcxg, as.matrix(test[,-1]))>0.5)
predict_binary[test$quantity==0]=0

#measure model performance
diff=predict_binary-test$returnQuantity

MAE=sum(abs(diff))/length(diff)
MAE
