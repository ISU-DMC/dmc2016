#!/usr/bin/env python
# =============================================================================
# File Name:     04_random_forest.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 18-04-2016
# Last Modified: Tue 26 Apr 2016 11:30:40 AM CDT
# =============================================================================


import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import Imputer

# Read/write data from binary {{{
#  train.to_pickle('train.pkl')
#  test.to_pickle('test_imputed.pkl')
train = pd.read_pickle('train.pkl')
test = pd.read_pickle('test_imputed.pkl')
# }}}

# Read data from text {{{
train = pd.read_csv('../train.csv')
test = pd.read_csv('../test.csv')
train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1
train.drop(['returnQuantity'], axis=1, inplace=True)

train.drop(train.index[pd.isnull(train).any(1)], inplace=True)
#  test.drop(test.index[pd.isnull(test).any(1)], inplace=True)

# Impute missing values
imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)
# }}}

# Train and predict {{{
rf = RandomForestClassifier(n_jobs=4, n_estimators=1000, max_features='sqrt')
rf.fit(train[train.columns[:-1]], train['return'])

preds = rf.predict(test[test.columns[1:]])
np.mean(np.absolute(test['returnQuantity'].as_matrix() - preds))

# Save predictions
with open('epwalsh_randomForest.csv', 'w') as f:
    f.write('binary\n')
    np.savetxt(f, preds, fmt='%d')
# }}}

# Feature importance {{{
d = {'imp': rf.feature_importances_, 'var': train.columns[:-1]}
imp = pd.DataFrame(d)
imp = imp.sort(columns=['imp'], ascending=False)
imp.to_csv('epwalsh_randomForest_v05.csv', index=False)
# }}}
