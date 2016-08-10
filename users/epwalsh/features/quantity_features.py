#!/usr/bin/env python
# =============================================================================
# File Name:     quantity_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 22-04-2016
# Last Modified: Sat Apr 23 10:22:52 2016
# =============================================================================


import pandas as pd


train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

train.drop(['returnQuantity'], axis=1, inplace=True)
cutoff = train.shape[0]

df = pd.concat([train, test])

del test
del train

# Total quantities
customer = df.groupby('customerID')['quantity'].sum()
customer = customer.reset_index()
customer.columns = ['customerID', 'quantity_per_customer']

article = df.groupby('articleID')['quantity'].sum()
article = article.reset_index()
article.columns = ['articleID', 'quantity_per_article']

size = df.groupby('sizeCode')['quantity'].sum()
size = size.reset_index()
size.columns = ['sizeCode', 'quantity_per_size']

color = df.groupby('colorCode')['quantity'].sum()
color = color.reset_index()
color.columns = ['colorCode', 'quantity_per_color']

product = df.groupby('productGroup')['quantity'].sum()
product = product.reset_index()
product.columns = ['productGroup', 'quantity_per_product']

res = pd.merge(df, customer, how='left', on=['customerID'])
res = pd.merge(res, article, how='left', on=['articleID'])
res = pd.merge(res, size, how='left', on=['sizeCode'])
res = pd.merge(res, color, how='left', on=['colorCode'])
res = pd.merge(res, product, how='left', on=['productGroup'])

size_agg = {'quantity': {'customer_size_quantity': 'sum'}}
customer_size = df.groupby(['customerID', 'sizeCode']).agg(size_agg)
customer_size = customer_size['quantity'].reset_index()

color_agg = {'quantity': {'customer_color_quantity': 'sum'}}
customer_color = df.groupby(['customerID', 'colorCode']).agg(color_agg)
customer_color = customer_color['quantity'].reset_index()

product_agg = {'quantity': {'customer_product_quantity': 'sum'}}
customer_product = df.groupby(['customerID', 'productGroup']).agg(product_agg)
customer_product = customer_product['quantity'].reset_index()

article_agg = {'quantity': {'customer_article_quantity': 'sum'}}
customer_article = df.groupby(['customerID', 'articleID']).agg(article_agg)
customer_article = customer_article['quantity'].reset_index()

res = pd.merge(res, customer_size, how='left', on=['customerID', 'sizeCode'])
res = pd.merge(res, customer_color, how='left', on=['customerID', 'colorCode'])
res = pd.merge(res, customer_product, how='left', on=['customerID', 'productGroup'])
res = pd.merge(res, customer_article, how='left', on=['customerID', 'articleID'])

out = res.iloc[:, 14:]
del res

train = out.iloc[0:cutoff, :]
test = out.iloc[cutoff:, :]

train.to_csv('epwalsh_quantity_train.csv', index=False)
test.to_csv('epwalsh_quantity_class.csv', index=False)


# Proportions of quantities
train = pd.read_csv('./epwalsh_quantity_train.csv')
test = pd.read_csv('./epwalsh_quantity_class.csv')
new = pd.concat([train, test])

df = pd.concat([df, new], axis=1)
df.head()

del new, train, test

df['customer_order_size_prop'] = df['quantity'] / df['customer_size_quantity']
df['customer_order_article_prop'] = df['quantity'] / df['customer_article_quantity']
df['customer_order_color_prop'] = df['quantity'] / df['customer_color_quantity']
df['customer_order_product_prop'] = df['quantity'] / df['customer_product_quantity']

out = df.iloc[:, 14:]
train = out.iloc[0:cutoff, :]
test = out.iloc[cutoff:, :]

train.to_csv('epwalsh_quantity_train.csv', index=False)
test.to_csv('epwalsh_quantity_class.csv', index=False)


# Check for na's
train.head()

train.fillna(0, inplace=True)
test.fillna(0, inplace=True)
