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
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import Imputer
import sys

# Read/write data from binary {{{
#  train = pd.read_pickle('train.pkl')
#  test = pd.read_pickle('test.pkl')

# Use xgboost features
sys.stdout.write('Reading data...\n')
sys.stdout.flush()
train = pd.read_pickle('../data/final/train_xgboost.pkl')
test = pd.read_pickle('../data/final/test_xgboost.pkl')
class_ = pd.read_pickle('../data/final/class_xgboost.pkl')

train = pd.concat([train, test])
train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

sys.stdout.write('Imputing values in class set...\n')
sys.stdout.flush()
imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(class_)
class_ = pd.DataFrame(imputed_test, columns=class_.columns)
# }}}

# Train and predict {{{
sys.stdout.write('Training model...\n')
sys.stdout.flush()
rf = RandomForestRegressor(n_jobs=16, n_estimators=10000, max_features='sqrt')
rf.fit(train.drop(['returnQuantity'], axis=1), train['returnQuantity'])

sys.stdout.write('Creating predictions...\n')
sys.stdout.flush()
preds = rf.predict(class_)
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0

# Save predictions
sys.stdout.write('Saving predictions...\n')
sys.stdout.flush()
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('predictions_class.csv', index=False)
#  with open('predictions_class.csv', 'w') as f:
    #  f.write('binary\n')
    #  np.savetxt(f, preds, fmt='%d')
# }}}

print 'Done!'
