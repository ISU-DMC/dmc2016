#!/usr/bin/env python
# =============================================================================
# File Name:     todo.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 27-04-2016
# Last Modified: Wed Apr 27 21:15:54 2016
# =============================================================================

import pandas as pd

# Read data from txt {{{
train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt',
                    sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt',
                   sep=';')

train.drop(['returnQuantity'], axis=1, inplace=True)
cutoff = train.shape[0]
df = pd.concat([train, test])
# }}}

# Read / write data from binary {{{
#  df.to_pickle('data.pkl')
df = pd.read_pickle('data.pkl')
cutoff = 2325165
# }}}

df.head()

# End rrp and voucherAmount (DONE) {{{
df['end_rrp'] = df['rrp'] % 1
df['end_voucherAmount'] = df['voucherAmount'] % 1
train = df.iloc[:cutoff, :]
test = df.iloc[cutoff:, :]
train.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_endings_train.csv',
             index=False,
             columns=['end_rrp', 'end_voucherAmount'])
test.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_endings_class.csv',
            index=False,
            columns=['end_rrp', 'end_voucherAmount'])
# }}}

# Unique sizes/colors/prods/articles / total quantity within order (DONE) {{{
quant = df.groupby('orderID')['quantity'].sum()
quant = quant.reset_index()
quant.columns = ['orderID', 'total_quantity']
df = pd.merge(df, quant, how='left', on=['orderID'])

aggregation = {
        'sizeCode': {'n_sizes': 'nunique'},
        'colorCode': {'n_colors': 'nunique'},
        'productGroup': {'n_products': 'nunique'},
        'articleID': {'n_articles': 'nunique'}
        }

counts = df.groupby('orderID').agg(aggregation)
sizes = counts['sizeCode'].reset_index()
colors = counts['colorCode'].reset_index()
products = counts['productGroup'].reset_index()
articles = counts['articleID'].reset_index()
df = pd.merge(df, sizes, how='left', on=['orderID'])
df = pd.merge(df, colors, how='left', on=['orderID'])
df = pd.merge(df, products, how='left', on=['orderID'])
df = pd.merge(df, articles, how='left', on=['orderID'])

df['articles_db_total_quantity'] = df['n_articles'] / df['total_quantity']
df['sizes_db_total_quantity'] = df['n_sizes'] / df['total_quantity']
df['colors_db_total_quantity'] = df['n_colors'] / df['total_quantity']
df['products_db_total_quantity'] = df['n_products'] / df['total_quantity']

df['quantity_prop'] = df['quantity'] / df['total_quantity']

train = df.iloc[:cutoff, :]
test = df.iloc[cutoff:, :]

train.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_ordersProp_train.csv',
             index=False,
             columns=['articles_db_total_quantity', 'sizes_db_total_quantity',
                      'colors_db_total_quantity', 'products_db_total_quantity',
                      'quantity_prop'])
test.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_ordersProp_class.csv',
            index=False,
            columns=['articles_db_total_quantity', 'sizes_db_total_quantity',
                     'colors_db_total_quantity', 'products_db_total_quantity',
                     'quantity_prop'])
# }}}

# Time of order - time article/color first appeared (DONE) {{{
# Article
df['date'] = pd.to_datetime(df['orderDate'])
time = df.groupby('articleID')['orderDate'].min()
time = time.reset_index()
time.columns = ['articleID', 'article_first_date']

df = pd.merge(df, time, how='left', on=['articleID'])
df['diff'] = df['date'] - pd.to_datetime(df['article_first_date'])
days = [x.days for x in df['diff']]
df['time_since_article_first_appearance'] = days

# Color
time = df.groupby('colorCode')['orderDate'].min()
time = time.reset_index()
time.columns = ['colorCode', 'color_first_date']

df = pd.merge(df, time, how='left', on=['colorCode'])
df['diff'] = df['date'] - pd.to_datetime(df['color_first_date'])
days = [x.days for x in df['diff']]
df['time_since_color_first_appearance'] = days

train = df.iloc[:cutoff, :]
test = df.iloc[cutoff:, :]

train.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_timeDiffs_train.csv',
             index=False,
             columns=['time_since_article_first_appearance',
                      'time_since_color_first_appearance'])
test.to_csv('/Users/epwalsh/ISU-DMC/data/new/epwalsh_timeDiffs_class.csv',
            index=False,
            columns=['time_since_article_first_appearance',
                     'time_since_color_first_appearance'])
# }}}
