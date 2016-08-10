#!/usr/bin/env python
# =============================================================================
# File Name:     classifier.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 24-04-2016
# Last Modified: Sun 24 Apr 2016 05:56:09 PM CDT
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

train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1

dtrain = xgb.DMatrix(train.drop(['returnQuantity', 'return'], axis=1).as_matrix(),
                     label=train['return'].as_matrix(), missing=np.nan)
dtest = xgb.DMatrix(test.drop(['returnQuantity'], axis=1).as_matrix(),
                    label=test['returnQuantity'].as_matrix(), missing=np.nan)

del train, test
# }}}

# Params {{{
param = {'max_depth': 5,
         'eta': 0.3,
         'silent': 0,
         'n_thread': 4,
         'objective': 'binary:logistic'}

num_round = 100
# }}}

# Cross validate {{{
cv = xgb.cv(param, dtrain, num_round, nfold=5)
cv.loc[cv['test-error-mean'].argmin(), :]
# }}}

# Train that shit {{{
bst = xgb.train(param, dtrain, num_round)

preds = bst.predict(dtest)
bin_preds = preds
bin_preds[bin_preds >= 0.5] = 1
bin_preds[bin_preds < 0.5] = 0
np.mean(np.absolute(dtest.get_label() - bin_preds))
np.mean(np.absolute(dtest.get_label() - preds))
# }}}

# Importance {{{
importance = bst.get_fscore(fmap='xgb.fmap')
importance = sorted(importance.items(), key=operator.itemgetter(1), reverse=True)
importance = pd.DataFrame(importance, columns=['feature', 'fscore'])
importance
# }}}
