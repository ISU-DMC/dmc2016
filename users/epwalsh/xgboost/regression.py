#!/usr/bin/env python
# =============================================================================
# File Name:     xgb_regression.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 24-04-2016
# Last Modified: Sun 24 Apr 2016 04:56:31 PM CDT
# =============================================================================

import xgboost as xgb
import pandas as pd
import numpy as np
import operator


def create_feature_map(features):
    outfile = open('xgb.fmap', 'w')
    i = 0
    for feat in features:
        outfile.write('{0}\t{1}\tq\n'.format(i, feat))
        i = i + 1
    outfile.close()

# Load data {{{
train = pd.read_csv('../train.csv')
test = pd.read_csv('../test.csv')
create_feature_map(train.columns[1:])

dtrain = xgb.DMatrix(train.drop(['returnQuantity'], axis=1).as_matrix(),
                     label=train['returnQuantity'].as_matrix(), missing=np.nan)
dtest = xgb.DMatrix(test.drop(['returnQuantity'], axis=1).as_matrix(),
                    label=test['returnQuantity'].as_matrix(), missing=np.nan)

del train, test
# }}}

# Params {{{
param = {'max_depth': 2,
         'eta': 1,
         'silent': 0,
         'n_thread': 4,
         'objective': 'reg:linear'}

num_round = 50
# }}}

# Cross validate {{{
xgb.cv(param, dtrain, num_round, nfold=5)
# }}}

# Train that shit {{{
bst = xgb.train(param, dtrain, num_round)

preds = bst.predict(dtest)
bin_preds = preds
bin_preds[bin_preds >= 0.5] = 1
bin_preds[bin_preds < 0.5] = 0
np.mean(np.absolute(dtest.get_label() - preds))
# }}}

# Importance {{{
importance = bst.get_fscore(fmap='xgb.fmap')
importance = sorted(importance.items(), key=operator.itemgetter(1), reverse=True)
importance = pd.DataFrame(importance, columns=['feature', 'fscore'])
importance
# }}}
