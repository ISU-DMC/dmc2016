##################################################################
#### This program is used to tune the parameters
#### library packages
##### only change this part
#user.begin = 1
#user.end = 1
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

SPWEIGHT = 1



#out.name = "final_all"
###########################################################
#### Step5: Tuning learning rate
cat("Step5: Tuning learning rate\n")

### First combine all of the results from step 1.
user.name.list = c("wangzl/ISU-DMC/","haozhe/ISU_DMC/","hjsang/ISU-DMC/","mxjki/ISU-DMC/data/","hanye/ISU-DMC/","lixinyi/DMC/data/")
xg_auc1 = NULL
xg_auc2 = NULL
xg_auc3 = NULL
for (user.name in user.name.list){
  vi.file.user = list.files(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/"))
  list.step.1.file = vi.file.user[grep("step_1",vi.file.user)]
  for (file.i in list.step.1.file)
  {
    xg_auc1 = rbind(xg_auc1,
                    read.csv(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/",file.i)))
  }
}


for (user.name in user.name.list){
  vi.file.user = list.files(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/"))
  list.step.2.file = vi.file.user[grep("step_2",vi.file.user)]
  for (file.i in list.step.2.file)
  {
    xg_auc2 = rbind(xg_auc2,
                    read.csv(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/",file.i)))
  }
}

for (user.name in user.name.list){
  vi.file.user = list.files(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/"))
  list.step.3.file = vi.file.user[grep("step_3",vi.file.user)]
  for (file.i in list.step.3.file)
  {
    xg_auc3 = rbind(xg_auc3,
                    read.csv(paste0("/work/STAT/",user.name,"featureMatrix_v05/tuning/",file.i)))
  }
}


optpar1 = xg_auc1[which.min(xg_auc1$mae),]
optpar2 = xg_auc2[which.min(xg_auc2$mae),]
optpar3 = xg_auc3[which.min(xg_auc3$mae),]


xg_auc4 = data.frame("Depth" = numeric(),
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

ETA = seq(0.01, 0.3,length=12)
for (i in user.begin:user.end)
{
  eta = ETA[i]
  xgb_params = list(
    objective = "binary:logistic",    # binary classification
    eta = eta,       # learning rate
    max_depth = optpar1$Depth,      # max tree depth
    min_child_weight = optpar1$Min_child_weight,
    subsample = optpar3$r_sample,
    colsample_bytree = optpar3$c_sample,
    gamma = optpar2$gamma,
    scale_pos_weight = 1,
    eval_metric = "error"     # evaluation/auc metric
  )
   xgb_cv = xgb.cv(params = xgb_params,
                  data = x,
                  label = y,
                  #eta = eta,
                  nrounds = ROUNDS, 
                  nfold = NFOLD,                                                   # number of folds in K-fold
                  stratified = TRUE,                                           # sample is unbalanced; use stratified sampling
                  verbose = FALSE,
                  print.every.n = 0, 
                  early.stop.round = 50#,
                  #scale_pos_weight = optpar4$scale_pos_weight ## rate of 0/1
  )
 
  n.best = which.min(xgb_cv$test.error.mean)


  bstSparse = xgboost(data = x,label=y, param = xgb_params, nround=n.best)

  y_pred = predict(bstSparse, xx)

  y_pred=y_pred*test$quantity
  y_pred[y_pred<=0.5]=0
  y_pred[y_pred>0.5]=1
  

  #print(paste(depth, mcw, mean(m.top5), mean(std.top5)))
  xg_auc4[nrow(xg_auc4)+1, ] = c(optpar1$Depth, 
                                 optpar1$Min_child_weight,
                                 optpar3$r_sample,
                                 optpar3$c_sample,
                                 eta,
                                 SPWEIGHT,
                                 optpar2$gamma,
				 min(xgb_cv$test.error.mean),
				 xgb_cv$test.error.std[which.min(xgb_cv$test.error.mean)],

                                # mean(m.top5), 
				 n.best,
                                # mean(std.top5),
                                # mean(n.top5)
				 mean(abs(y_pred-test$returnQuantity)))
  write.csv(xg_auc4, paste0("./tuning/xgboost_step_4_", i, ".csv"), row.names = FALSE, quote = FALSE)
  
}




