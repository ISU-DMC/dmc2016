##################################################################
#### This program is used to tune the parameters
#### library packages
##### only change this part
### set you own work space 
#####


library(Matrix)
library(xgboost)
#library(caTools)
#library(caret)
#library(readr)
#library(dplyr)
#library(tidyr)
# library(foreach)
# library(doParallel)

### read data

train=read.csv("train.csv",head=T)
test=read.csv("test.csv",head=T)
#class=read.csv("class.csv",head=T)

##############################
### define mae function
# mae = function(preds, dtrain){
#   labels = getinfo(dtrain, 'label')
#   pred_labels = as.numeric(preds>0.5)
#   mae = mean(abs(labels-pred_labels))
#   return(list(metric = 'mae', value = mae))
# }

###### format data 
train[is.na(train)]=0
test[is.na(test)]=0
x=train[,-1]
y=train[,1]
y=as.numeric(y>0)

x=as(Matrix(as.matrix(x)),"dgCMatrix")
# test matrix
tst=as.matrix(test[,-1])
# tst=as.matrix(test[1:1000,-1])
tst[is.na(tst)]=0
xx = xgb.DMatrix(tst)
#x=xgb.DMatrix(as.matrix(x), label=y)


#### nfold
NFOLD=5

#out.name = "final_all"
###########################################################
### Step 1: Tuning `max_depth` and `min_child_weight`
cat("Step1: Tuning max_depth and min_child\n")

### initial parameters
ROUNDS = 1000
DEPTH = c(4, 5, 6, 7, 8, 9)
MCW = seq(0.5,20,length=10)
RSAMPLE = 0.7
CSAMPLE = 0.5
ETA =  0.05
SPWEIGHT = 1
GAMMA = 0

grid.step.1 = expand.grid(depth = DEPTH, 
                          mcw = MCW)



xg_auc1 = data.frame("Depth" = numeric(),
                     "Min_child_weight" = numeric(),
                     "r_sample" = numeric(),
                     "c_sample" = numeric(), 
                     "eta" = numeric(),
                     "scale_pos_weight" = numeric(),
                     "gamma" = numeric(),
                     "min.error" = numeric(),
                     "min.error.std" = numeric(),
                     "best_round" = numeric(),
		     "mae"=numeric())

for (i in user.begin:user.end)
{
  depth = grid.step.1$depth[i]
  mcw = grid.step.1$mcw[i]
  
  xgb_params = list(
    objective = "binary:logistic",    # binary classification
    eta = ETA,       # learning rate
    max_depth = grid.step.1$depth[i],      # max tree depth
    min_child_weight = grid.step.1$mcw[i],
    subsample = RSAMPLE,
    colsample_bytree = CSAMPLE,
    gamma = GAMMA,
    eval_metric = "error"    # evaluation/mae,
    # nthread =1
  )
  xgb_cv = xgb.cv(params = xgb_params,
                  data = x,
                  label = y,
                  nrounds = ROUNDS, 
                  nfold = NFOLD,                                                   # number of folds in K-fold
                  stratified = TRUE,                                           # sample is unbalanced; use stratified sampling
                  verbose = 0,
                  print.every.n = 0, 
                  early.stop.round = 100,
                  scale_pos_weight = SPWEIGHT  ## rate of 0/1
  )
 # m = xgb_cv$test.error.mean
 # std = xgb_cv$test.error.std
 # idx = order(m)[1:5]
 # m.top5  = m[idx]
 # std.top5 = std[idx]
 # n.top5 = which(m %in% m.top5)
  n.best = which.min(xgb_cv$test.error.mean)


  bstSparse = xgboost(data = x,label=y, param = xgb_params, nround=n.best)

  y_pred = predict(bstSparse, xx)

  y_pred=y_pred*test$quantity
  y_pred[y_pred<=0.5]=0
  y_pred[y_pred>0.5]=1
  

  #print(paste(depth, mcw, mean(m.top5), mean(std.top5)))
  xg_auc1[nrow(xg_auc1)+1, ] = c(depth, 
                                 mcw,
                                 RSAMPLE,
                                 CSAMPLE,
                                 ETA,
                                 SPWEIGHT,
                                 GAMMA,
				 min(xgb_cv$test.error.mean),
				 xgb_cv$test.error.std[which.min(xgb_cv$test.error.mean)],

                                # mean(m.top5), 
				 n.best,
                                # mean(std.top5),
                                # mean(n.top5)
				 mean(abs(y_pred-test$returnQuantity)))
}
write.csv(xg_auc1, paste0("./tuning/xgboost_step_1_", user.begin,"_",user.end, ".csv"), row.names = FALSE, quote = FALSE)

