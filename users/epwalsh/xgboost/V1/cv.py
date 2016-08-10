#!/usr/bin/env python
# =============================================================================
# File Name:     classifier.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 24-04-2016
# Last Modified: Sun 15 May 2016 05:42:49 PM CDT
# =============================================================================

import xgboost as xgb
import pandas as pd
import numpy as np
import operator
import sys


# Save and load data from binary {{{
dtrain = xgb.DMatrix('dtrain.buffer')
dtest = xgb.DMatrix('dtest.buffer')
# }}}

param = {'max_depth': 8,
         'eta': 0.1,
         'silent': 1,
         'n_thread': 16,
         'colsample_bytree': 0.2,
         'objective': 'binary:logistic'}

num_round = 2000

depths = [10, 11]
etas = [0.01, 0.1, 0.2, 0.3]
cols = [0.4, 0.5]

sys.stdout.write('max_depth,eta,colsample_bytree,round,MAE\n')
sys.stdout.flush()
for x in depths:
    for y in etas:
        for z in cols:
            param['max_depth'] = x
            param['eta'] = y
            param['colsample_bytree'] = z
            watchlist  = [(dtest,'eval')]
            bst = xgb.train(param, dtrain, num_round, watchlist, early_stopping_rounds=150)
            sys.stdout.write(str(x) + ',' + str(y) + ',' + str(z) + ',')
            sys.stdout.write(str(bst.best_iteration) + ',' + str(bst.best_score) + '\n')
            sys.stdout.flush()
