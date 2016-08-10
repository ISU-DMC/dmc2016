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
import sys

# Read/write data from binary {{{
train = pd.read_pickle('train.pkl')
test = pd.read_pickle('test.pkl')

# Use xgboost features
#  train = pd.read_pickle('../data/final/train_xgboost.pkl')
#  test = pd.read_pickle('../data/final/test_xgboost.pkl')

#  train['return'] = 0
#  train.loc[train['returnQuantity'] >= 1, ['return']] = 1
#  train.drop(['returnQuantity'], axis=1, inplace=True)
#  train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

#  imputer = Imputer(missing_values="NaN")
#  imputed_test = imputer.fit_transform(test)
#  test = pd.DataFrame(imputed_test, columns=test.columns)
# }}}

# Train and predict {{{
mtry = [50, 100, 150]
min_split = [5, 30, 50, 100]

sys.stdout.write('mtry, min_split, mae\n')
sys.stdout.flush()

for x in mtry:
    for y in min_split:
        rf = RandomForestClassifier(n_jobs=16, 
                                    n_estimators=1000, 
                                    max_features=x,
                                    min_samples_split=y)
        rf.fit(train.drop(['return'], axis=1), train['return'])
        preds = rf.predict(test.drop(['returnQuantity'], axis=1))
        mae = np.mean(np.absolute(test['returnQuantity'].as_matrix() - preds))
        sys.stdout.write(str(x) + ', ' + str(y) + ', ' + str(mae) + '\n')
        sys.stdout.flush()
# }}}
