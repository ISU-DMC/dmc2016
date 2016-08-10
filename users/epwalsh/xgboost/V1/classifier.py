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

# Save and load data from binary {{{
sys.stdout.write('Reading data...\n')
sys.stdout.flush()

dtrain = xgb.DMatrix('dtrain.buffer')
dtest = xgb.DMatrix('dtest.buffer')
# }}}

# Params {{{
param = {'max_depth': 10,
         'eta': 0.01,
         'silent': 1,
         'n_thread': 16,
         'colsample_bytree': 0.4,
         'objective': 'binary:logistic',
         'seed': 5}

num_round = 1136
# }}}

# Train that shit for test set {{{
sys.stdout.write('Training model for test set...\n')
sys.stdout.flush()

bst = xgb.train(param, dtrain, num_round)

preds = bst.predict(dtest)
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0

sys.stdout.write('Test set error: ')
sys.stdout.write(str(np.mean(np.absolute(dtest.get_label() - bin_preds))) + '\n')
sys.stdout.flush()
# }}}

# Predictions on test {{{
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('epwalsh_xgboost.csv', index=False)
# }}}

dtrain_final = xgb.DMatrix('dtrain_final.buffer')
dclass = xgb.DMatrix('dclass.buffer')

# Train that shit for class set {{{
sys.stdout.write('Training model for class set...')
sys.stdout.flush()

bst = xgb.train(param, dtrain_final, num_round)

preds = bst.predict(dclass)
bin_preds = np.copy(preds)
bin_preds[preds >= 0.5] = 1
bin_preds[preds < 0.5] = 0
# }}}

# Predictions on class {{{
d = {'binary': bin_preds, 'continuous': preds}
out = pd.DataFrame(d)
out.to_csv('epwalsh_xgboost_V1.csv', index=False)
# }}}

sys.stdout.write('Done!')
