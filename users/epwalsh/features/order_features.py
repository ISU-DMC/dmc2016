#!/usr/bin/env python
# =============================================================================
# File Name:     order_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 23-04-2016
# Last Modified: Sat Apr 23 11:44:28 2016
# =============================================================================

import pandas as pd

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

cutoff = train.shape[0]

train.drop(['returnQuantity'], inplace=True, axis=1)
df = pd.concat([train, test])

del train
del test

size = df.groupby(['orderID'])['sizeCode'].unique()
color = df.groupby(['orderID'])['colorCode'].unique()
size = size.reset_index()
color = color.reset_index()
size['uniqueSizes'] = [len(x) for x in size['sizeCode']]
color['uniqueColors'] = [len(x) for x in color['colorCode']]

color_counts = color.drop(['colorCode'], axis=1)
size_counts = size.drop(['sizeCode'], axis=1)

res = pd.merge(color_counts, size_counts, how='left', on=['orderID'])
res.columns = ['orderID', 'uniqueColors_per_order', 'uniqueSizes_per_order']
res['sizeVsColor_per_order'] = res['uniqueColors_per_order'] - res['uniqueSizes_per_order']

out = pd.merge(df, res, how='left', on=['orderID'])
del res
del df

train = out.iloc[0:cutoff, :]
test = out.iloc[cutoff:, :]

train.head()
train.to_csv('epwalsh_orders2_train.csv', index=False, 
             columns=['uniqueColors_per_order', 'uniqueSizes_per_order',
                      'sizeVsColor_per_order'])

test.to_csv('epwalsh_orders2_class.csv', index=False, 
             columns=['uniqueColors_per_order', 'uniqueSizes_per_order',
                      'sizeVsColor_per_order'])

df.shape

size = df.groupby(['orderID'])['sizeCode'].unique()
color = df.groupby(['orderID'])['colorCode'].unique()
product = df.groupby(['orderID'])['productGroup'].unique()
article = df.groupby(['orderID'])['articleID'].unique()

size = size.reset_index()
color = color.reset_index()
product = product.reset_index()
article = article.reset_index()

size['uniqueSizes'] = [len(x) for x in size['sizeCode']]
color['uniqueColors'] = [len(x) for x in color['colorCode']]
article['uniqueArticles_per_order'] = [len(x) for x in article['articleID']]
product['uniqueProducts_per_order'] = [len(x) for x in product['productGroup']]

size.head()
color.head()
article.head()
product.head()

size.drop(['sizeCode'], axis=1, inplace=True)
color.drop(['colorCode'], axis=1, inplace=True)
article.drop(['articleID'], axis=1, inplace=True)
product.drop(['productGroup'], axis=1, inplace=True)

res = pd.merge(df, size, how='left', on=['orderID'])
res = pd.merge(res, color, how='left', on=['orderID'])
res = pd.merge(res, article, how='left', on=['orderID'])
res = pd.merge(res, product, how='left', on=['orderID'])

res['articleVsSize_per_order'] = res['uniqueSizes'] - res['uniqueArticles_per_order']
res['articleVsColor_per_order'] = res['uniqueColors'] - res['uniqueArticles_per_order']
res['productVsSize_per_order'] = res['uniqueSizes'] - res['uniqueProducts_per_order']
res['productVsColor_per_order'] = res['uniqueColors'] - res['uniqueProducts_per_order']
res['articleVsProduct_per_order'] = res['uniqueArticles_per_order'] - res['uniqueProducts_per_order']

res.head()
out = res.iloc[:, 16:]
del res

train = out.iloc[0:cutoff, :]
test = out.iloc[cutoff:, :]

train.shape
test.shape

train.to_csv('epwalsh_orders3_train.csv', index=False)
test.to_csv('epwalsh_orders3_class.csv', index=False)
