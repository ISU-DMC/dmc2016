#!/usr/bin/env python
# =============================================================================
# File Name:     regressor.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 18-04-2016
# Last Modified: Tue 26 Apr 2016 12:00:41 PM CDT
# =============================================================================


import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import Imputer

# Read/write data from binary {{{
#  train.to_pickle('train2.pkl')
#  test.to_pickle('test_imputed.pkl')
train = pd.read_pickle('train2.pkl')
test = pd.read_pickle('test_imputed.pkl')
# }}}

# Read data from text {{{
train = pd.read_csv('../train.csv')
test = pd.read_csv('../test.csv')

train.drop(train.index[pd.isnull(train).any(1)], inplace=True)
#  test.drop(test.index[pd.isnull(test).any(1)], inplace=True)

# Impute missing values
imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)
# }}}

# Train and predict {{{
rf = RandomForestRegressor(n_jobs=4, n_estimators=1000, max_features='sqrt')
rf.fit(train[train.columns[1:]], train['returnQuantity'])

preds = rf.predict(test[test.columns[1:]])
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0
np.mean(np.absolute(test['returnQuantity'].as_matrix() - bin_preds))
# }}}

# Save predictions {{{
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('epwalsh_randomForestRegressor.csv', index=False)
# }}}

# Feature importance {{{
d = {'imp': rf.feature_importances_, 'var': train.columns[:-1]}
imp = pd.DataFrame(d)
imp = imp.sort(columns=['imp'], ascending=False)
imp.to_csv('epwalsh_randomForest_v05.csv', index=False)
# }}}
