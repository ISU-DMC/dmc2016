#!/usr/bin/env python
# =============================================================================
# File Name:     articles.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 29-04-2016
# Last Modified: Fri Apr 29 17:08:26 2016
# =============================================================================


import pandas as pd

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

cutoff = train.shape[0]
df = pd.concat([train, test])

del train, test
df['date'] = pd.to_datetime(df['orderDate'])

prices = df.groupby(['articleID', 'date'])['price'].mean()
prices = prices.reset_index()

prices.head()
prices

# How many times articleID appears
prices2 = df.groupby(['articleID'])['date'].nunique()
prices2 = prices2.reset_index()
prices2.columns = ['articleID', 'n_days_articleID']

df = pd.merge(df, prices2, how='left', on=['articleID'])

artSize = df.groupby(['articleID', 'sizeCode'])['date'].nunique()
artSize = artSize.reset_index()
artSize.columns = ['articleID', 'sizeCode', 'n_days_articleSize']
artSize.head()

df = pd.merge(df, artSize, how='left', on=['articleID', 'sizeCode'])

artColor = df.groupby(['articleID', 'colorCode'])['date'].nunique()
artColor = artColor.reset_index()
artColor.columns = ['articleID', 'colorCode', 'n_days_articleColor']
artColor.head()

df = pd.merge(df, artColor, how='left', on=['articleID', 'colorCode'])
df.head()

train = df.iloc[:cutoff, :]
test = df.iloc[cutoff:, :]

train.to_csv('~/ISU-DMC/data/new/epwalsh_articleDays_train.csv', index=False,
             columns=['n_days_articleID', 'n_days_articleSize', 'n_days_articleColor'])
test.to_csv('~/ISU-DMC/data/new/epwalsh_articleDays_class.csv', index=False,
            columns=['n_days_articleID', 'n_days_articleSize', 'n_days_articleColor'])

# Do same for voucherID
voucher = df.groupby(['voucherID'])['date'].nunique()
voucher = voucher.reset_index()
voucher.columns = ['voucherID', 'n_days_voucherID']

df = pd.merge(df, voucher, how='left', on=['voucherID'])

voucherArticle = df.groupby(['voucherID', 'articleID'])['date'].nunique().reset_index()
voucherArticle.columns = ['voucherID', 'articleID', 'n_days_voucherArticle']
voucherArticle.head()

df = pd.merge(df, voucherArticle, how='left', on=['voucherID', 'articleID'])

voucherColor = df.groupby(['voucherID', 'colorCode'])['date'].nunique().reset_index()
voucherColor.columns = ['voucherID', 'colorCode', 'n_days_voucherColor']
voucherColor.head()

df = pd.merge(df, voucherColor, how='left', on=['voucherID', 'colorCode'])

voucherSize = df.groupby(['voucherID', 'sizeCode'])['date'].nunique().reset_index()
voucherSize.columns = ['voucherID', 'sizeCode', 'n_days_voucherSize']
voucherSize.head()

df = pd.merge(df, voucherSize, how='left', on=['voucherID', 'sizeCode'])

voucherProd = df.groupby(['voucherID', 'productGroup'])['date'].nunique().reset_index()
voucherProd.columns = ['voucherID', 'productGroup', 'n_days_voucherProd']
voucherProd.head()

df = pd.merge(df, voucherProd, how='left', on=['voucherID', 'productGroup'])

train = df.iloc[:cutoff, :]
test = df.iloc[cutoff:, :]

train.to_csv('~/ISU-DMC/data/new/epwalsh_voucherDays_train.csv', index=False,
             columns=['n_days_voucherID', 'n_days_voucherArticle',
                      'n_days_voucherColor', 'n_days_voucherSize',
                      'n_days_voucherProd'])
test.to_csv('~/ISU-DMC/data/new/epwalsh_voucherDays_class.csv', index=False,
            columns=['n_days_voucherID', 'n_days_voucherArticle',
                     'n_days_voucherColor', 'n_days_voucherSize',
                     'n_days_voucherProd'])

df.head()
