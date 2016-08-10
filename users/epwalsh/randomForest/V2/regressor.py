#!/usr/bin/env python
# =============================================================================
# File Name:     regressor.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 18-04-2016
# Last Modified: Tue 26 Apr 2016 12:16:53 PM CDT
# =============================================================================


import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import Imputer

# Read/write data from binary {{{
#  train.to_pickle('train2.pkl')
#  test.to_pickle('test_imputed.pkl')
#  train = pd.read_pickle('train2.pkl')
#  test = pd.read_pickle('test_imputed.pkl')

# Use xgboost features
train = pd.read_pickle('../data/final/train_xgboost.pkl')
test = pd.read_pickle('../data/final/test_xgboost.pkl')

train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)
# }}}

# Train and predict {{{
rf = RandomForestRegressor(n_jobs=16, n_estimators=10000, max_features='sqrt')
rf.fit(train.drop(['returnQuantity'], axis=1), train['returnQuantity'])

preds = rf.predict(test.drop(['returnQuantity'], axis=1))
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0
print np.mean(np.absolute(test['returnQuantity'].as_matrix() - bin_preds))
# }}}

# Save predictions {{{
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('predictions_test.csv', index=False)
# }}}

# Feature importance {{{
#  d = {'imp': rf.feature_importances_, 'var': train.columns[:-1]}
#  imp = pd.DataFrame(d)
#  imp = imp.sort(columns=['imp'], ascending=False)
#  imp.to_csv('epwalsh_randomForest_v05.csv', index=False)
# }}}
