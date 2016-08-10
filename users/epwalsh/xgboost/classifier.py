#!/usr/bin/env python
# =============================================================================
# File Name:     classifier.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 24-04-2016
# Last Modified: Wed 27 Apr 2016 04:55:29 PM CDT
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

# Save and load data from binary {{{
#  dtrain.save_binary('dtrain.buffer')
#  dtest.save_binary('dtest.buffer')
#  dclass.save_binary('dclass.buffer')
dtrain = xgb.DMatrix('dtrain.buffer')
dtest = xgb.DMatrix('dtest.buffer')
dclass = xgb.DMatrix('dclass.buffer')
# }}}

# Load data from txt {{{
train = pd.read_csv('../train.csv')
test = pd.read_csv('../test.csv')
class_ = pd.read_csv('../class.csv')
create_feature_map(train.columns[1:])

train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1

dtrain = xgb.DMatrix(train.drop(['returnQuantity', 'return'], axis=1).as_matrix(),
                     label=train['return'].as_matrix(), missing=np.nan)
dtest = xgb.DMatrix(test.drop(['returnQuantity'], axis=1).as_matrix(),
                    label=test['returnQuantity'].as_matrix(), missing=np.nan)
dclass = xgb.DMatrix(class_.as_matrix(), missing=np.nan)

del train, test, class_
# }}}

# Params {{{
param = {'max_depth': 8,
         'eta': 0.1,
         'silent': 0,
         'n_thread': 4,
         'colsample_bytree': 0.2,
         'objective': 'binary:logistic'}
# }}}

# Cross validate that shit {{{
num_round = 400
cv = xgb.cv(param, dtrain, num_round, nfold=5)
cv.loc[cv['test-error-mean'].argmin(), :]
cv
# }}}

# Train that shit {{{
num_round = 249
bst = xgb.train(param, dtrain, num_round)

preds = bst.predict(dtest)
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0
np.mean(np.absolute(dtest.get_label() - bin_preds))
# }}}

# Predictions {{{
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('epwalsh_xgboost.csv', index=False)
# }}}

# Final predictions {{{
preds = bst.predict(dclass)
# }}}

# Importance {{{
importance = bst.get_fscore(fmap='xgb.fmap')
importance = sorted(importance.items(), key=operator.itemgetter(1), reverse=True)
importance = pd.DataFrame(importance, columns=['feature', 'fscore'])
importance
importance.to_csv('epwalsh_xgboost_v05b.csv', index=False)
# }}}
