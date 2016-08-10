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
#  train = pd.read_pickle('train.pkl')
#  test = pd.read_pickle('test.pkl')

# Use xgboost features
train = pd.read_pickle('../data/final/train_xgboost.pkl')
test = pd.read_pickle('../data/final/test_xgboost.pkl')

train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1
train.drop(['returnQuantity'], axis=1, inplace=True)
train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)
# }}}

# Train and predict {{{
mtry=200
min_split=5

rf = RandomForestClassifier(n_jobs=16, 
                            n_estimators=2000, 
                            max_features=mtry,
                            min_samples_split=min_split)
rf.fit(train.drop(['return'], axis=1), train['return'])

preds = rf.predict(test.drop(['returnQuantity'], axis=1))
mae = np.mean(np.absolute(test['returnQuantity'].as_matrix() - preds))
print mtry, min_split, mae

# Save predictions
#  with open('predictions_test.csv', 'w') as f:
    #  f.write('binary\n')
    #  np.savetxt(f, preds, fmt='%d')
# }}}

# Feature importance {{{
#  d = {'imp': rf.feature_importances_, 'var': train.columns[:-1]}
#  imp = pd.DataFrame(d)
#  imp = imp.sort(columns=['imp'], ascending=False)
#  imp.to_csv('importance.csv', index=False)
# }}}
