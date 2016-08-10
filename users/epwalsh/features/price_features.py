#!/usr/bin/env python
# =============================================================================
# File Name:     price_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 22-04-2016
# Last Modified: Tue Apr 26 17:26:26 2016
# =============================================================================

import pandas as pd

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

cutoff = train.shape[0]

df = pd.concat([train, test])

del train
del test

# Price per size ---------------------------------------------------------- {{{
aggregation = {
        'price': {
            'mean_price_per_size': 'mean',
            'max_price_per_size': 'max',
            'min_price_per_size': 'min',
            'median_price_per_size': 'median'
            }
        }

price_per_size = df.groupby(['sizeCode']).agg(aggregation)
price_per_size = price_per_size['price'].reset_index()
res = pd.merge(df, price_per_size, how='left', on=['sizeCode'])
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('epwalsh_pricePerSize_train.csv',
             columns=['min_price_per_size',
                      'max_price_per_size',
                      'median_price_per_size',
                      'mean_price_per_size'], index=False)
test.to_csv('epwalsh_pricePerSize_class.csv',
            columns=['min_price_per_size',
                     'max_price_per_size',
                     'median_price_per_size',
                     'mean_price_per_size'], index=False)
# ------------------------------------------------------------------------- }}}

# Price per color --------------------------------------------------------- {{{
aggregation = {
        'price': {
            'mean_price_per_color': 'mean',
            'max_price_per_color': 'max',
            'min_price_per_color': 'min',
            'median_price_per_color': 'median'
            }
        }

price_per_color = df.groupby(['colorCode']).agg(aggregation)
price_per_color = price_per_color['price'].reset_index()
res = pd.merge(df, price_per_color, how='left', on=['colorCode'])
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('epwalsh_pricePerColor_train.csv',
             columns=['min_price_per_color',
                      'max_price_per_color',
                      'median_price_per_color',
                      'mean_price_per_color'], index=False)
test.to_csv('epwalsh_pricePerColor_class.csv',
            columns=['min_price_per_color',
                     'max_price_per_color',
                     'median_price_per_color',
                     'mean_price_per_color'], index=False)
# ------------------------------------------------------------------------- }}}

# Price per productGroup -------------------------------------------------- {{{
aggregation = {
        'price': {
            'mean_price_per_product': 'mean',
            'max_price_per_product': 'max',
            'min_price_per_product': 'min',
            'median_price_per_product': 'median'
            }
        }

price_per_product = df.groupby(['productGroup']).agg(aggregation)
price_per_product = price_per_product['price'].reset_index()
res = pd.merge(df, price_per_product, how='left', on=['productGroup'])
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('epwalsh_pricePerProduct_train.csv',
             columns=['min_price_per_product',
                      'max_price_per_product',
                      'median_price_per_product',
                      'mean_price_per_product'], index=False)
test.to_csv('epwalsh_pricePerProduct_class.csv',
            columns=['min_price_per_product',
                     'max_price_per_product',
                     'median_price_per_product',
                     'mean_price_per_product'], index=False)
# ------------------------------------------------------------------------- }}}

# Price per articleID ----------------------------------------------------- {{{
aggregation = {
        'price': {
            'mean_price_per_article': 'mean',
            'max_price_per_article': 'max',
            'min_price_per_article': 'min',
            'median_price_per_article': 'median'
            }
        }

price_per_article = df.groupby(['articleID']).agg(aggregation)
price_per_article = price_per_article['price'].reset_index()
res = pd.merge(df, price_per_article, how='left', on=['articleID'])
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('epwalsh_pricePerArticle_train.csv',
             columns=['min_price_per_article',
                      'max_price_per_article',
                      'median_price_per_article',
                      'mean_price_per_article'], index=False)
test.to_csv('epwalsh_pricePerArticle_class.csv',
            columns=['min_price_per_article',
                     'max_price_per_article',
                     'median_price_per_article',
                     'mean_price_per_article'], index=False)
# ------------------------------------------------------------------------- }}}


# End price
