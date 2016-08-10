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
# }}}

param = {'max_depth': 8,
         'eta': 0.1,
         'silent': 1,
         'n_thread': 16,
         'colsample_bytree': 0.2,
         'objective': 'binary:logistic'}

num_round = 1200

depths = [10, 11, 12]
etas = [0.01]
cols = [0.3, 0.4, 0.5]

sys.stdout.write('max_depth,eta,colsample_bytree,round,MAE\n')
sys.stdout.flush()
for x in depths:
    for y in etas:
        for z in cols:
            param['max_depth'] = x
            param['eta'] = y
            param['colsample_bytree'] = z
            cv = xgb.cv(param, dtrain, num_round, nfold=2, early_stopping_rounds=80)
            res = cv.loc[cv['test-error-mean'].argmin(), :]
            sys.stdout.write(str(x) + ',' + str(y) + ',' + str(z) + ',')
            sys.stdout.write(str(res.name) + ',' + str(res[0]) + '\n')
            sys.stdout.flush()
