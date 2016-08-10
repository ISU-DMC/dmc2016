#!/usr/bin/env python
# =============================================================================
# File Name:     rodgrigo.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 27-04-2016
# Last Modified: Wed Apr 27 12:58:58 2016
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

# Price minus voucher
df['price_minus_voucher'] = df['price'] - df['voucherAmount']

# Totals per day
aggregation = {
        'price': {'total_price_per_day': 'sum',
                  'avg_price_per_day': 'mean'},
        'voucherAmount': {'total_voucherAmt_per_day': 'sum',
                          'avg_voucherAmt_per_day': 'mean'},
        'rrp': {'total_rrp_per_day': 'sum',
                'avg_rrp_per_day': 'mean'}
        }

byday = df.groupby(['date']).agg(aggregation)

bydayPrice = byday['price'].reset_index()
bydayVoucher = byday['voucherAmount'].reset_index()
bydayRRP = byday['rrp'].reset_index()

aggregation2 = {
        'customerID': {'customer_per_day': 'nunique'},
        'articleID': {'articles_per_day': 'nunique'},
        'voucherID': {'vouchers_per_day': 'nunique'}
        }

byday2 = df.groupby(['date']).agg(aggregation2)
bydayVouchers = byday2['voucherID'].reset_index()
bydayArticles = byday2['articleID'].reset_index()
bydayCust = byday2['customerID'].reset_index()

res = pd.merge(df.loc[:, ['price_minus_voucher', 'date']], bydayPrice, how='left', on=['date'])
res = pd.merge(res, bydayVoucher, how='left', on=['date'])
res = pd.merge(res, bydayRRP, how='left', on=['date'])
res = pd.merge(res, bydayVouchers, how='left', on=['date'])
res = pd.merge(res, bydayArticles, how='left', on=['date'])
res = pd.merge(res, bydayCust, how='left', on=['date'])

res.drop(['date'], axis=1, inplace=True)
train = res.iloc[0:cutoff, :]
test = res.iloc[cutoff:, :]

train.shape
test.shape

train.to_csv('~/ISU-DMC/data/num/epwalsh_dayTotals_train.csv', index=False)
test.to_csv('~/ISU-DMC/data/num/epwalsh_dayTotals_class.csv', index=False)
