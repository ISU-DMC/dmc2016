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

train = pd.read_csv('../../data/final/train_xgboost.csv')
test = pd.read_csv('../../data/final/test_xgboost.csv')
class_ = pd.read_csv('../../data/final/class_xgboost.csv')
train_final = pd.concat([train, test])

train['return'] = 0
train.loc[train['returnQuantity'] >= 1, ['return']] = 1
train.drop(['returnQuantity'], axis=1, inplace=True)
train.drop(train.index[pd.isnull(train).any(1)], inplace=True)

train_final['return'] = 0
train_final.loc[train_final['returnQuantity'] >= 1, ['return']] = 1
train_final.drop(['returnQuantity'], axis=1, inplace=True)
train_final.drop(train_final.index[pd.isnull(train_final).any(1)], inplace=True)

# Impute missing values
imputer = Imputer(missing_values="NaN")

imputed_test = imputer.fit_transform(test)
test = pd.DataFrame(imputed_test, columns=test.columns)

imputed_class = imputer.fit_transform(class_)
class_ = pd.DataFrame(imputed_class, columns=class_.columns)

train.to_pickle('train.pkl')
train_final.to_pickle('train_final.pkl')
test.to_pickle('test.pkl')
class_.to_pickle('class.pkl')
