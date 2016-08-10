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
import sys

# Load data from txt / pickle {{{
train = pd.read_pickle('../data/final/train_xgboost.pkl')
test = pd.read_pickle('../data/final/test_xgboost.pkl')
train_final = pd.concat([train, test])
class_ = pd.read_pickle('../data/final/class_xgboost.pkl')

train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1
train_final['return'] = 0
train_final.loc[train_final['returnQuantity'] >= 1, ['return']] = 1

dtrain = xgb.DMatrix(train.drop(['returnQuantity', 'return'], axis=1).as_matrix(),
                     label=train['return'].as_matrix(), missing=np.nan)
dtrain_final = xgb.DMatrix(train_final.drop(['returnQuantity', 'return'], axis=1).as_matrix(),
                           label=train_final['return'].as_matrix(), missing=np.nan)
dtest = xgb.DMatrix(test.drop(['returnQuantity'], axis=1).as_matrix(),
                    label=test['returnQuantity'].as_matrix(), missing=np.nan)
dclass = xgb.DMatrix(class_.as_matrix(), missing=np.nan)

sys.stdout.write('train:       ' + str(train.shape) + '\n')
sys.stdout.write('train final: ' + str(train_final.shape) + '\n')
sys.stdout.write('test:        ' + str(test.shape) + '\n')
sys.stdout.write('class:       ' + str(class_.shape) + '\n')
sys.stdout.flush()
# }}}

# Save and load data from binary {{{
dtrain.save_binary('dtrain.buffer')
dtrain_final.save_binary('dtrain_final.buffer')
dtest.save_binary('dtest.buffer')
dclass.save_binary('dclass.buffer')
# }}}
