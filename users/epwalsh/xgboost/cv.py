#!/usr/bin/env python
# =============================================================================
# File Name:     05_xgboost.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 18-04-2016
# Last Modified: Sat Apr 23 21:16:25 2016
# =============================================================================

import xgboost as xgb
import pandas as pd
import numpy as np


train = pd.read_csv('~/ISU-DMC/dmc2016/data/feature_matrix/train.csv')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/feature_matrix/test.csv')

dtrain = xgb.DMatrix(train.drop(['returnQuantity'], axis=1).as_matrix(),
                     label=train['returnQuantity'].as_matrix(), missing=np.nan)
dtest = xgb.DMatrix(test.drop(['returnQuantity'], axis=1).as_matrix(),
                    label=test['returnQuantity'].as_matrix(), missing=np.nan)

del train, test

param = {'max_depth': 1,
         'eta': 1,
         'silent': 0,
         'n_thread': 2,
         'objective': 'reg:linear'}

num_round = 2

xgb.cv(param, dtrain, num_round, nfold=3, seed=0)


# Training

# watchlist  = [(dtest,'eval'), (dtrain,'train')]
bst = xgb.train(param, dtrain, num_round)

preds = bst.predict(dtest)
bin_preds = preds
bin_preds[bin_preds >= 0.5] = 1
bin_preds[bin_preds < 0.5] = 0
np.mean(np.absolute(dtest.get_label() - preds))
