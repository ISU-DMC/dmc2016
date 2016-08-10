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
from sklearn.preprocessing import Imputer

# Prepare initial feature matrix {{{
train = pd.read_csv('/work/STAT/mxjki/ISU-DMC/data/featureMatrix_hanye_new_V1_select/train.csv')
test = pd.read_csv('/work/STAT/mxjki/ISU-DMC/data/featureMatrix_hanye_new_V1_select/test.csv')
class_ = pd.read_csv('/work/STAT/mxjki/ISU-DMC/data/featureMatrix_hanye_new_V1_select/class.csv')
train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1
train.drop(['returnQuantity'], axis=1, inplace=True)

train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

# Impute missing values
imputer = Imputer(missing_values="NaN")
imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)

imputed_class = imputer.fit_transform(class_)
class_ = pd.DataFrame(imputed_class, columns=class_.columns)

train.to_pickle('train.pkl')
test.to_pickle('test.pkl')
class_.to_pickle('class.pkl')
# }}}
