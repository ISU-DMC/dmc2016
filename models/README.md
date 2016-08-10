# Predictions results

Record mean absolute error (MAE) on the test set for each model you fit in the tables below.
Also record the type of model and all parameters used in fitting.

## Feature matrix version 01

| MAE | model | parameters | notes | 
| --- | ----- | ---------- | ----- |
| 0.42889 | random forest | max_features = sqrt(n), n_trees = 500 | removed NA's, continuous predictions  |
| 0.35002 | random forest | max_features = sqrt(n), n_trees = 1000 | removed NA's, regression -> binary with 0.5 cutoff |
| 0.3459176 | logistic regression | family="binomial" | fill all NA by 0, binary predictions  |
| 0.3414753 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.3374451 | xgboost | max.depth=5, eta=0.03, "objective"="binary:logistic", "eval_metric"="error", nrounds=800, colsample_bytree=0.85, subsample=0.95 | "missing=NA", binary classification (returns "1" when p>0.5), nrounds: determined by CV  |
| 0.3461236 | LDA | returnQuantity ~. | removed "0" columns from train,test. removed NA's from train. binary predictions. filled all NA in predictions by 0.   |
| 0.38622 | QDA | returnQuantity ~. | removed "0" columns from train,test. removed NA's from train. binary predictions. filled all NA in predictions by 0. |
|0.34594|logistic ridge regression | family="binomial", lambda= 0.01246 chosen by CV| fill all NA by 0, binary predictions|
|0.34587|logistic Lasso regression | family="binomial", lambda= 0.00082 chosen by CV| fill all NA by 0, binary predictions|
|0.4107233| SVM | 5-fold cross validation | fill all NA's by 0, binary classification|
## Feature matrix version 01b

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.3529609 | C50 | all default | Response as a factcor with 5 levels was used (better than 2 levels) |
| 0.34745 | random forest | max_features = sqrt(n), n_trees = 1000 | removed NA's, 5 way classifier |
| 0.34636 | random forest | max_features = sqrt(n), n_trees = 1000 | removed NA's, binary classification |
| 0.3422222 | C50 | trial = 10 | same as above | 
| 0.3480  | J48 | min. num. instances per leaf (M) =1000 | fill all NA's by 0, binary response |  
| 0.345673  | LDA |returnQuantity ~.  | removed "0" columns from train,test. removed NA's from train. binary predictions. filled all NA in predictions by 0. | 
| 0.3495487 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.34568 |logistic ridge regression | family="binomial", lambda= 0.01272 chosen by CV| fill all NA by 0, binary predictions|
| 0.34500 |logistic lasso regression | family="binomial", lambda= 0.00076 chosen by CV| fill all NA by 0, binary predictions|
----

## Feature matrix version 02

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.3107529 | LDA | returnQuantity ~. | removed "0" columns from train,test. removed NA's from train. binary predictions. filled all NA in predictions by 0 |
| 0.3111649 | C50 | trial = 10 | binary classification (0.3466644 for 5 way!) |
| 0.313729 | random forest | max_features = sqrt(n), n_trees = 500 | removed NA's, binary classification |
| 0.3150406 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.3164  | J48  | min. num. instances per leaf (M) =800 | fill all NA's by 0, binary response |  
| 0.3183498 | C50 | all default | binary classification (0.3541326 for 5 way!) |

## Feature matrix version 02b

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.313576 | random forest | max_featurs = sqrt(n), n_trees = 1000 | removed NA's, binary classifier |
| 0.3159806 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.3179893  | extraTrees  | default, ntree=500 | fill all NA's by 0, 6 levels response | 
| 0.3187103  | extraTrees  | default, ntree=500 | fill all NA's by 0, 2 levels response, much faster | 

----

## Feature matrix version 03

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.3083402 | C50 | trial = 10 | binary classification, about 10 mins to tun |
| 0.3083826 | C50 | trial = 10, rules = TRUE | binary, replace decision tree with rule-based model, 10 min |
| 0.3108194 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.3139  | J48  | min. num. instances per leaf (M) =300 | fill all NA's by 0, binary response |  
| 0.3101996  | extraTrees  | default, ntree=500 | fill all NA's by 0, 6 levels response |  
| 0.3101741  | extraTrees  | default, ntree=500 | fill all NA's by 0, 2 levels response | 
| 0.3100383  | LDA  | returnQuantity ~. | removed NA's from train. binary predictions. filled all NA in predictions by 0 | 
| 0.350453 | knn | k=10 | about 4 hours.. not recommended.. |
## Feature matrix version 03b

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.3088496 | C50 | trial=10 | binary, 17 min |
| 0.3081959 | C50 | trial=10, winnow = TRUE | winnow chose important features before building the tree, 16 min, reached max memory size (4GB) |
| 0.3075081 | C50 | trial=10, fuzzyThreshold = TRUE | 16 min, reached max memory size |
| 0.3148864  | extraTrees  | default, ntree=500 | fill all NA's by 0, 6 levels response, but only have prediction 0 and 1,about 20min|  
| 0.3139439  | extraTrees  | default, ntree=500 | fill all NA's by 0, 2 levels response, about 15 min| 
| 0.3094524 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions  |
| 0.3178835 | AdaBoost.M1 | boos=TRUE, mfinal=5, coeflearn='Breiman' | 6 level response as factor but predictions are only 0s and 1s, replace all NA's by 0, >30mins  |
| 0.3088751  | LDA  | returnQuantity ~. | removed NA's from train. binary predictions. filled all NA in predictions by 0 |

## Feature matrix version 03c

| MAE | model | parameters | notes |
| --- | ----- | ---------- | ----- |
| 0.3077628 | xgboost | max_depth=2, eta=1, nthread=2, silent=1, nrounds=800, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions (mxjki) |
| 0.30636 | xgboost | max_depth=2, eta=1, nthread=2, nrounds=50, objective="reg:linear" | fill NA by 0, transform predictions to binary. (epwalsh) |
| 0.3065657 | LDA | returnQuantity ~. | removed NA's from train. removed "zero variance" predictors. binary predictions. filled NA in predictions by 0. about 3 mins (mjohny) |
| 0.3099449 | C50 | trial = 10 | binary, there must be some overfitting |
| 0.306294 | C50 | trial = 10, fuzzyThreshold = TRUE |

----

## Feature matrix version 05

(Let's keep the table sorted by MAE)

| MAE | model | parameters | notes (username) |
| --- | ----- | ---------- | ----- |
| 0.2994295 | xgboost + randomForest + lda + c5.0 + extraTrees | | 50% xgboost, 20% c5.0, 10% rf, 10% lda, 10% extraTrees |
| 0.3001109 | xgboost | max_depth=8, eta=0.1, colsample_bytree=0.2, nrounds=249, objective="binary:logistic" | 5-fold cv to tune params, training time about 4 mins (epwalsh) |
| 0.3043944 | C50 | trial = 10, fuzzyThreshold = TRUE | 5 level response, 30 mins (keguoh) |
| 0.3061662 | C50 | trial = 10, fuzzyThreshold = TRUE | binary, 30 mins(keguoh) |
| 0.3069839 | LDA | returnQuantity ~. | removed NA's from train. removed "zero variance" predictors. binary predictions. filled NA in predictions by 0. about 3 mins (mjohny) |
| 0.3089114  | extraTrees  | default, ntree=500 | fill all NA's by 0, 6 levels response, about 5 min(qilidmc)| 
| 0.3090672 | C50 | trial = 10 | binary, 30 mins(keguoh)|
| 0.309411  | J48  | min. num. instances per leaf (M) =200 | fill all NA's by 0, binary response (rodrigoplazola) |  
| 0.3099239  | extraTrees  | default, ntree=500 | fill all NA's by 0, 2 levels response, about 5 min(qilidmc)| 

## Feature matrix version 05b

| MAE | model | parameters | notes (username) |
| --- | ----- | ---------- | ----- |
| 0.2995658 | xgboost | max_depth=8, eta=0.1, colsample_bytree=0.2, nrounds=249, objective="binary:logistic" | 5-fold cv to tune params, training time about 4 mins (epwalsh) |
| 0.3012792 | xgboost | max_depth=8, eta=0.1, nthread=2, silent=1, nrounds=249, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions (mxjki) |
| 0.3018243  | boosted trees method  | default, max_depth = 8, max_iteration = 20 | delete all NA's, about 5 min(fly-nail)| 
| 0.3028563  | boosted trees method  | default, max_depth = 8, max_iteration = 20 | change 'NA' in 'rrp' to 0, about 166 seconds(fly-nail)| 
| 0.3036156 | C50 | trial = 20, rule = T, bands = 20, fuzzyThreshold = T | best result of attempted 17 models under diff options(0.3107027 as worst); time range from 30 mins to 1 hour (keguoh) |
| 0.3040245 | extraTrees  | ntree=1000 | use 200 most important features, fill all NA's by 0, 6 levels response, about 20 min(qilidmc)| 
| 0.3041997 | extraTrees  | ntree=800, numRandomCuts =3 | use 200 most important features, fill all NA's by 0, 6 levels response, about 20 min(qilidmc)| 
| 0.3045696  | extraTrees  | ntree=800 | use 150 most important features, fill all NA's by 0, 6 levels response, about 10 min(qilidmc)| 
| 0.3048811 | LDA | returnQuantity ~. | removed NA's from train. removed "zero variance" predictors. binary predictions. filled (661) NA in predictions by 0. about 6 mins (mjohny) |
| 0.3049006  | extraTrees  | default, ntree=500 | use 100 most important features, fill all NA's by 0, 6 levels response, 
| 0.3061662  | extraTrees  | default, ntree=1000 | use 300 most important features, fill all NA's by 0, 6 levels response, about 20 min(qilidmc)| 
| 0.3073733  | extraTrees  | default, ntree=500 | fill all NA's by 0, 6 levels response, about 10 min(qilidmc)| 
| 0.3079185  | extraTrees  | default, ntree=500 | fill all NA's by 0, 2 levels response, about 10 min(qilidmc)| 

## Feature matrix version 06

| MAE | model | parameters | notes (username) |
| --- | ----- | ---------- | ----- |
| 0.3020249 | C50 | trial = 20, rule = T, bands = 20, fuzzyThreshold = T | binary(keguoh) |
| 0.2939565 | xgboost |params = list(objective="binary:logistic",max_depth=8, eta=0.1, nthread=2),nrounds=500 | training time is around 20 mins (Haozhe)|

## Feature matrix version 05c

| MAE | model | parameters | notes (username) |
| --- | ----- | ---------- | ----- |
| 0.3003251 | xgboost | max_depth=8, eta=0.1, nthread=2, silent=1, nrounds=249, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions (mxjki) |
| 0.3029147 | C50 | trial = 20, rule = T, bands = 20, fuzzyThreshold = T | binary(keguoh) |
| 0.3045501 | extraTrees  | ntree=1000, numRandomCuts =3 | fill all NA's by 0, 6 levels response, about 20 min(qilidmc)| 
| 0.3066918 | extraTrees  | ntree=500, numRandomCuts =3 | fill all NA's by 0, 6 levels response, about 20 min(qilidmc)| 

## Feature matrix version 05d

| MAE | model | parameters | notes (username) |
| --- | ----- | ---------- | ----- |
| 0.301612 | xgboost | max_depth=8, eta=0.1, nthread=2, silent=1, nrounds=249, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions (mxjki) |
| 0.30529| LDA  | returnQuantity~. | Removed all columns containing any NA values in train. Binary, fill all NA in predictions by 0 (mjohny)| 
| 0.3056405| LDA  | returnQuantity~. | Removed columns containing excessive NA values in train. Binary, fill all NA in predictions by 0 (mjohny)| 
| 0.3058352 | xgboost | max_depth=8, eta=0.1, nthread=2, silent=1, nrounds=500, objective="reg:linear", eval_metric="MAE"| fill all NA by 0, binary predictions (mxjki) |
| 0.30655 | extraTrees  | ntree=1000, numRandomCuts =1 | fill all NA's by 0, 2 levels response(qilidmc)| 
