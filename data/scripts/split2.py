#!/usr/bin/env python
# =============================================================================
# File Name:     split2.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 25-04-2016
# Last Modified: Mon Apr 25 18:19:53 2016
# =============================================================================

import pandas as pd

# Read data from txt {{{
train = pd.read_csv('./raw_data/orders_train.txt', sep=';')
test = pd.read_csv('./raw_data/orders_class.txt', sep=';')

train['is_train'] = 1
test['is_train'] = 0

cutoff = train.shape[0]
df = pd.concat([train, test])
del train, test
# }}}

# Read/write from binary {{{
cust = pd.read_pickle('customers.pkl')
cust.to_pickle('customers.pkl')
# }}}

cust = df.groupby(['customerID', 'is_train'])['orderID'].unique()
cust = cust.reset_index()
counts = [len(x) for x in cust['orderID']]
cust['count'] = counts
cust = cust.pivot(index='customerID', columns='is_train', values='count').fillna(0)
cust.columns = ['test', 'train']

peeps = cust.loc[(cust['test'] >= 5) & (cust['train'] >= 5), :].index

# 40,334 columns in test set
df.loc[(df['is_train'] == 0) & (df['customerID'].isin(peeps)), :]

df.loc[df['is_train'] == 0, :].shape

# Roughly 12% of test set
1.0 * 40334 / 341098
