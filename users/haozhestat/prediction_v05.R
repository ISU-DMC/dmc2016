##################################################################
#### This program is used to tune the parameters
#### library packages
##### only change this part
# user.begin = 1
# user.end = 1
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

train=read.csv("train_reduce.csv",head=T)

class=read.csv("class_reduce_2.csv",head=T)

model.train=rbind(train)

##############################
### define mae function
# mae = function(preds, dtrain){
#   labels = getinfo(dtrain, 'label')
#   pred_labels = as.numeric(preds>0.5)
#   mae = mean(abs(labels-pred_labels))
#   return(list(metric = 'mae', value = mae))
# }

# fomart the data for final prediction
model.x=model.train[,-1]
model.x[is.na(model.x)]=0

model.y=model.train[,1]
model.y=as.numeric(model.y>0)

model.x=as(Matrix(as.matrix(model.x)),"dgCMatrix")

# test matrix
class[is.na(class)]=0
model.tst=as.matrix(class)
model.xx = xgb.DMatrix(model.tst)
##############################
#### nfold
NFOLD=2
### Initial parameters
ROUNDS = 2000
SPWEIGHT=1
#out.name = "final_all"
###########################################################
### read the optimal pars
optimal_par=read.csv("Step_5_result.csv",head=T)
### delete the last row since it's bad
# time=dim(optimal_par)[1]-1


xg_auc1 = data.frame("Depth" = numeric(),
                     "Min_child_weight" = numeric(),
                     "r_sample" = numeric(),
                     "c_sample" = numeric(), 
                     "eta" = numeric(),
                     "scale_pos_weight" = numeric(),
                     "gamma" = numeric(),
                     "min.error" = numeric(),
                     "min.error.std" = numeric(),
                     "best_round" = numeric())

xg_auc2 = data.frame("Depth" = numeric(),
                     "Min_child_weight" = numeric(),
                     "r_sample" = numeric(),
                     "c_sample" = numeric(), 
                     "eta" = numeric(),
                     "scale_pos_weight" = numeric(),
                     "gamma" = numeric(),
                     "min.error" = numeric(),
                     "min.error.std" = numeric(),
                     "best_round" = numeric())

####### output
binary.class=NULL
prob.class=NULL

i=time
  xgb_params = list(
    objective = "binary:logistic",    # binary classification
    eta = optimal_par$eta[i],       # learning rate
    max_depth = optimal_par$Depth[i],      # max tree depth
    min_child_weight = optimal_par$Min_child_weight[i],
    subsample = optimal_par$r_sample[i],
    colsample_bytree = optimal_par$c_sample[i],
      gamma =optimal_par$gamma[i] ,
    eval_metric =  "error"     # evaluation/auc metric
  )
  
  #### predict the class
  
  set.seed(1234)
  xgb_cv = xgb.cv(params = xgb_params,
                  data = model.x,
                  label = model.y,
                  nrounds = ROUNDS, 
                  nfold = NFOLD,                                                   # number of folds in K-fold
                  stratified = TRUE,                                           # sample is unbalanced; use stratified sampling
                  verbose = 1,
                  print.every.n = 1, 
                  early.stop.round = 50,
                  scale_pos_weight = SPWEIGHT  ## rate of 0/1
  )
  
  n.best = which.min(xgb_cv$test.error.mean)
  bstSparse = xgboost(data = model.x,label=model.y, param = xgb_params, nround=n.best)
  y_pred = predict(bstSparse, model.xx)
  prob.class=cbind(prob.class,y_pred)
  y_pred[y_pred<=0.5]=0
  y_pred[y_pred>0.5]=1
  y_pred[class$quantity==0]=0
  binary.class=cbind(binary.class,y_pred)
  #print(paste(depth, mcw, mean(m.top5), mean(std.top5)))
  xg_auc2[nrow(xg_auc2)+1, ] = c(optimal_par$Depth[i], 
                                 optimal_par$Min_child_weight[i],
                                 optimal_par$r_sample[i],
                                 optimal_par$c_sample[i],
                                 optimal_par$eta[i],
                                 SPWEIGHT,
                                 optimal_par$gamma[i],
                                 min(xgb_cv$test.error.mean),
                                 xgb_cv$test.error.std[which.min(xgb_cv$test.error.mean)],
                                 
                                 # mean(m.top5), 
                                 n.best)
  
write.csv(xg_auc2,paste0("./prediction/output_pars2",time,".csv"),row.names = F)
  
write.csv(xg_auc1,paste0("./prediction/output_pars1",time,".csv"),row.names = F)
write.csv(binary.class,paste0("./prediction/output_binary_class",time,".csv"),row.names = F)
write.csv(prob.class,paste0("./prediction/output_prob_class",time,".csv"),row.names = F)

