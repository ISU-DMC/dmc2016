#!/usr/bin/env python
# =============================================================================
# File Name:     past_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 29-04-2016
# Last Modified: Fri Apr 29 17:11:25 2016
# =============================================================================


import pandas as pd

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

train.drop(['returnQuantity'], axis=1, inplace=True)
cutoff = train.shape[0]

df = pd.concat([train, test])
df.columns

del test, train

df['date'] = pd.to_datetime(df['orderDate'])
