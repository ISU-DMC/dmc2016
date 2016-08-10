#!/usr/bin/env python
# =============================================================================
# File Name:     customer_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 22-04-2016
# Last Modified: Wed Apr 27 14:55:16 2016
# =============================================================================

import pandas as pd


train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

train.drop(['returnQuantity'], axis=1, inplace=True)
cutoff = train.shape[0]

df = pd.concat([train, test])
df.columns

del test, train

aggregation = {
        'orderID': {'customer_visits': 'count'},
        'price': {'customer_mean_price': 'mean',
                  'customer_median_price': 'median',
                  'customer_std_price': 'std'},
        'rrp': {'customer_mean_rrp': 'mean',
                'customer_median_rrp': 'median',
                'customer_std_rrp': 'std'},
        'voucherAmount': {'customer_mean_voucherAmount': 'mean',
                          'customer_median_voucherAmount': 'median',
                          'customer_std_voucherAmount': 'std'}
        }

agg = df.groupby(['customerID']).agg(aggregation)
agg_rrp = agg['rrp'].reset_index()
agg_price = agg['price'].reset_index()
agg_orders = agg['orderID'].reset_index()
agg_vouchers = agg['voucherAmount'].reset_index()

res = pd.merge(df.loc[:, ['customerID']], agg_rrp, how='left', on=['customerID'])
res = pd.merge(res, agg_price, how='left', on=['customerID'])
res = pd.merge(res, agg_orders, how='left', on=['customerID'])
res = pd.merge(res, agg_vouchers, how='left', on=['customerID'])
#  res.apply(lambda x: x.fillna(0, axis=0))

res['customer_mean_rrp'].fillna(res['customer_mean_rrp'].mean(), inplace=True)
res['customer_std_rrp'].fillna(0, inplace=True)
res['customer_median_rrp'].fillna(res['customer_median_rrp'].mean(), inplace=True)
res['customer_mean_price'].fillna(res['customer_mean_price'].mean(), inplace=True)
res['customer_median_price'].fillna(res['customer_median_price'].mean(), inplace=True)
res['customer_std_price'].fillna(0, inplace=True)
res['customer_mean_voucherAmount'].fillna(res['customer_mean_voucherAmount'].mean(), inplace=True)
res['customer_median_voucherAmount'].fillna(res['customer_median_voucherAmount'].mean(), inplace=True)
res['customer_std_voucherAmount'].fillna(0, inplace=True)

train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]
train.shape
test.shape

train.drop(['customerID'], axis=1, inplace=True)
test.drop(['customerID'], axis=1, inplace=True)
train.to_csv('epwalsh_customerBehavior_train.csv', index=False)
test.to_csv('epwalsh_customerBehavior_class.csv', index=False)

# TODO:

# Unique number of size, colors, products, articles for customers
def unique_count(values):
    return len(values.unique())

sizes = df.groupby(['customerID'])['sizeCode'].unique()
colors = df.groupby(['customerID'])['colorCode'].unique()
products = df.groupby(['customerID'])['productGroup'].unique()
articles = df.groupby(['customerID'])['articleID'].unique()

size_counts = [len(x) for x in sizes]
color_counts = [len(x) for x in colors]
product_counts = [len(x) for x in products]
article_counts = [len(x) for x in articles]

d_sizes = {'customerID': sizes.index, 'customer_size_counts': size_counts}
d_colors = {'customerID': colors.index, 'customer_color_counts': color_counts}
d_prods = {'customerID': products.index, 'customer_prod_counts': product_counts}
d_articles = {'customerID': articles.index, 'customer_art_counts': article_counts}

sizes_df = pd.DataFrame(d_sizes)
colors_df = pd.DataFrame(d_colors)
prods_df = pd.DataFrame(d_prods)
art_df = pd.DataFrame(d_articles)

sizes_df.shape
colors_df.shape
prods_df.shape
art_df.shape

res = pd.merge(df.loc[:, ['customerID']], sizes_df, how='left', on=['customerID'])
res = pd.merge(res, colors_df, how='left', on=['customerID'])
res = pd.merge(res, prods_df, how='left', on=['customerID'])
res = pd.merge(res, art_df, how='left', on=['customerID'])

train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]
train.drop(['customerID'], inplace=True, axis=1)
test.drop(['customerID'], inplace=True, axis=1)

train.to_csv('epwalsh_customerCounts_train.csv', index=False)
test.to_csv('epwalsh_customerCounts_class.csv', index=False)


# Repeat articleID, colorCode, sizeCode by customer
colors = df.groupby(['customerID', 'colorCode'])['orderID'].nunique()
sizes = df.groupby(['customerID', 'sizeCode'])['orderID'].nunique()
articles = df.groupby(['customerID', 'articleID'])['orderID'].nunique()
prods = df.groupby(['customerID', 'productGroup'])['orderID'].nunique()

colors = colors.reset_index()
sizes = sizes.reset_index()
articles = articles.reset_index()
prods = prods.reset_index()

colors['repeat_color'] = 0
colors.loc[colors['orderID'] > 1, ['repeat_color']] = 1
sizes['repeat_size'] = 0
sizes.loc[sizes['orderID'] > 1, ['repeat_size']] = 1
articles['repeat_article'] = 0
articles.loc[articles['orderID'] > 1, ['repeat_article']] = 1
prods['repeat_product'] = 0
prods.loc[prods['orderID'] > 1, ['repeat_product']] = 1

colors.drop(['orderID'], axis=1, inplace=True)
sizes.drop(['orderID'], axis=1, inplace=True)
prods.drop(['orderID'], axis=1, inplace=True)
articles.drop(['orderID'], axis=1, inplace=True)

res = pd.merge(df, colors, how='left', on=['customerID', 'colorCode'])
res = pd.merge(res, sizes, how='left', on=['customerID', 'sizeCode'])
res = pd.merge(res, prods, how='left', on=['customerID', 'productGroup'])
res = pd.merge(res, articles, how='left', on=['customerID', 'articleID'])

del df
res.iloc[:, 14:]
train = res.iloc[0:cutoff, 14:]
test = res.iloc[cutoff:, 14:]

train.to_csv('~/ISU-DMC/data/num/epwalsh_repeats_train.csv', index=False)
test.to_csv('~/ISU-DMC/data/num/epwalsh_repeats_class.csv', index=False)
