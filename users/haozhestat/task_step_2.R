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
### Initial parameters
ROUNDS = 1000

RSAMPLE = 0.7
CSAMPLE = 0.5
ETA =  0.05
SPWEIGHT = 1

#out.name = "final_all"
###########################################################
### Step 2: Tuning `gamma`
cat("Step2: Tuning gamma\n")
### First combine all of the results from step 1.
user.name.list = c("wangzl/ISU-DMC/","haozhe/ISU_DMC/","hjsang/ISU-DMC/","mxjki/ISU-DMC/data/","hanye/ISU-DMC/","lixinyi/DMC/data/")
xg_auc1 = NULL
for (user.name in user.name.list){
  vi.file.user = list.files(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/"))
  list.step.1.file = vi.file.user[grep("step_1",vi.file.user)]
  for (file.i in list.step.1.file)
  {
    xg_auc1 = rbind(xg_auc1,
                    read.csv(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/",file.i)))
  }
}



GAMMA = c(seq(0, .85, by=0.05))
optpar1 = xg_auc1[which.min(xg_auc1$mae),]



xg_auc2 = data.frame("Depth" = numeric(),
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
  gamma = GAMMA[i]
  
  xgb_params = list(
    objective = "binary:logistic",    # binary classification
    eta = ETA,       # learning rate
    max_depth = optpar1$Depth,      # max tree depth
    min_child_weight = optpar1$Min_child_weight,
    subsample = RSAMPLE,
    colsample_bytree = CSAMPLE,
    gamma = GAMMA[i],
    eval_metric =  "error"     # evaluation/auc metric
  )
  
  xgb_cv = xgb.cv(params = xgb_params,
                  data = x,
                  label = y,
                  # gamma = gamma,
                  nrounds = ROUNDS, 
                  nfold = NFOLD,                                                   # number of folds in K-fold
                  stratified = TRUE,                                           # sample is unbalanced; use stratified sampling
                  verbose = FALSE,
                  print.every.n = 0, 
                  early.stop.round = 50,
                  scale_pos_weight = SPWEIGHT  ## rate of 0/1
  )
 
  n.best = which.min(xgb_cv$test.error.mean)


  bstSparse = xgboost(data = x,label=y, param = xgb_params, nround=n.best)

  y_pred = predict(bstSparse, xx)

  y_pred=y_pred*test$quantity
  y_pred[y_pred<=0.5]=0
  y_pred[y_pred>0.5]=1
  

  #print(paste(depth, mcw, mean(m.top5), mean(std.top5)))
  xg_auc2[nrow(xg_auc2)+1, ] = c(optpar1$Depth, 
                                 optpar1$Min_child_weight,
                                 RSAMPLE,
                                 CSAMPLE,
                                 ETA,
                                 SPWEIGHT,
                                 gamma,
				 min(xgb_cv$test.error.mean),
				 xgb_cv$test.error.std[which.min(xgb_cv$test.error.mean)],

                                # mean(m.top5), 
				 n.best,
                                # mean(std.top5),
                                # mean(n.top5)
				 mean(abs(y_pred-test$returnQuantity)))
  write.csv(xg_auc2, paste0("./tuning/xgboost_step_2_", i, ".csv"), row.names = FALSE, quote = FALSE)
  
}




