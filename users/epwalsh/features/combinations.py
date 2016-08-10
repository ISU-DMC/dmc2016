#!/usr/bin/env python
# =============================================================================
# File Name:     combinations.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 27-04-2016
# Last Modified: Wed Apr 27 16:30:34 2016
# =============================================================================

import pandas as pd

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

cutoff = train.shape[0]
df = pd.concat([train, test])

del train, test

orders = df.groupby(['customerID'])['orderID'].nunique()
orders = orders.reset_index()
orders.columns = ['customerID', 'n_orders']
df = pd.merge(df, orders, how='left', on=['customerID'])

timeTrain = pd.read_csv('~/ISU-DMC/data/num/epwalsh_timeBetween_train.csv')
timeTest = pd.read_csv('~/ISU-DMC/data/num/epwalsh_timeBetween_class.csv')

time = pd.concat([timeTrain, timeTest])
del timeTrain, timeTest

out = pd.concat([df['n_orders'].reset_index(), time['mean_time_between'].reset_index()], axis=1)
out = out.drop(['index'], axis=1)
out['orders_per_meanTime'] = out['n_orders'] / out['mean_time_between']


del df

train = pd.read_csv('~/ISU-DMC/data/num/epwalsh_basics_train.csv')
test = pd.read_csv('~/ISU-DMC/data/num/epwalsh_basics_class.csv')

df = pd.concat([train, test])
df.shape
del train, test
df.head()

out = pd.concat([out, df.reset_index()], axis=1)
out.head()
out['totalPrice_per_meanTime'] = out['total_price_by_customerID'] / out['mean_time_between']
out['totalVoucher_per_meanTime'] = out['total_voucherAmount_by_customerID'] / out['mean_time_between']

train = out.iloc[0:cutoff, :]
test = out.iloc[cutoff:, :]

train.columns
train.to_csv('~/ISU-DMC/data/num/epwalsh_combs1_train.csv', index=False,
             columns=['n_orders', 'orders_per_meanTime',
                      'totalPrice_per_meanTime', 'totalVoucher_per_meanTime'])
test.to_csv('~/ISU-DMC/data/num/epwalsh_combs1_class.csv', index=False,
            columns=['n_orders', 'orders_per_meanTime',
                     'totalPrice_per_meanTime', 'totalVoucher_per_meanTime'])
