#!/usr/bin/env python
# =============================================================================
# File Name:     02_features.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 10-04-2016
# Last Modified: Tue Apr 19 18:33:52 2016
# =============================================================================

import pandas as pd
from os.path import expanduser

home = expanduser('~')
path = home + '/ISU-DMC/dmc2016/data/raw_data/orders_train.txt'
df = pd.read_csv(path, sep=';')
path2 = home + '/ISU-DMC/dmc2016/data/raw_data/orders_class.txt'
cdf = pd.read_csv(path2, sep=';')

df.shape[0]   # 2325165
cdf.shape[0]  # 341098
cutoff = df.shape[0]

cdf.head()

df.drop(['returnQuantity'], inplace=True, axis=1)
df = pd.concat([df, cdf])
#  del cdf

# sameArticleDiffSize {{{
# >> Does this order contain another item with the same articleID
# but a different size? (1 for yes, 0 for no)
# Classification set:
tmp = cdf.groupby(['orderID', 'articleID'])['sizeCode'].unique()
mult = [x for x in tmp.index if len(tmp[x]) > 1]
order = [x[0] for x in mult]
article = [x[1] for x in mult]
d = {'orderID': order, 'articleID': article}
rdf = pd.DataFrame(d)
rdf['sameProductDiffSize'] = 1
res = pd.merge(cdf, rdf, how='outer')
res['sameProductDiffSize'].fillna(0, inplace=True)
res.to_csv('sameProductDiffSize_class.csv',
           columns=['sameProductDiffSize'], index=False)
# Training set:
tmp = df.groupby(['orderID', 'articleID'])['sizeCode'].unique()
mult = [x for x in tmp.index if len(tmp[x]) > 1]
order = [x[0] for x in mult]
article = [x[1] for x in mult]
d = {'orderID': order, 'articleID': article}
rdf = pd.DataFrame(d)
rdf['sameProductDiffSize'] = 1
res = pd.merge(df, rdf, how='outer')
res['sameProductDiffSize'].fillna(0, inplace=True)
res.to_csv('sameProductDiffSize_train.csv',
           columns=['sameProductDiffSize'], index=False)
# }}}

# sameArticleDiffColor {{{
tmp = df.groupby(['orderID', 'articleID'])['colorCode'].unique()
mult = [x for x in tmp.index if len(tmp[x]) > 1]
order = [x[0] for x in mult]
article = [x[1] for x in mult]
d = {'orderID': order, 'articleID': article}
rdf = pd.DataFrame(d)
rdf['sameProductDiffColor'] = 1
res = pd.merge(df, rdf, how='outer')
res['sameProductDiffColor'].fillna(0, inplace=True)

del res
# }}}

# sameProductDiffSize {{{
# Same productID within order but different size
tmp = df.groupby(['orderID', 'productGroup'])['sizeCode'].unique()
mult = [x for x in tmp.index if len(tmp[x]) > 1]
order = [x[0] for x in mult]
product = [x[1] for x in mult]
d = {'orderID': order, 'productGroup': product}
rdf = pd.DataFrame(d)
rdf['sameProductDiffSize'] = 1
res = pd.merge(df, rdf, how='outer')
res['sameProductDiffSize'].fillna(0, inplace=True)
# }}}

# repeatOrderSameSize {{{
# >> Has this user ordered this product in the same size before?
# Combine dataframes
cutoff = df.shape[0]
df.drop(['returnQuantity'], inplace=True, axis=1)
df = pd.concat([df, cdf])

grouped = df.groupby(['customerID',
                      'articleID',
                      'sizeCode'])['orderID'].unique()
targs = [x for x in grouped.index if len(grouped[x]) > 1]
customerID = [x[0] for x in targs]
articleID = [x[1] for x in targs]
sizeCode = [x[2] for x in targs]
d = {'customerID': customerID, 'articleID': articleID, 'sizeCode': sizeCode}
targDF = pd.DataFrame(d)
targDF['repeatOrderSameSize'] = 1
res = pd.merge(df, targDF, how='outer')
res['repeatOrderSameSize'].fillna(0, inplace=True)
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('repeatOrderSameSize_train.csv',
             columns=['repeatOrderSameSize'], index=False)
test.to_csv('repeatOrderSameSize_class.csv',
            columns=['repeatOrderSameSize'], index=False)
# }}}

# Date related variables ---- {{{
df['date'] = pd.to_datetime(df['orderDate'], format='%Y-%m-%d')
dow = [x.dayofweek for x in df['date']]
week = [x.week for x in df['date']]
month = [x.month for x in df['date']]
df['dow'] = dow
df['week'] = week
df['month'] = month

df.head()
res.head()
res.shape

res = df[['articleID', 'colorCode', 'sizeCode', 'productGroup',
          'voucherID', 'customerID', 'deviceID', 'paymentMethod',
          'month', 'dow', 'week']]
train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]
train.to_csv('epwalsh_basics_train.csv', index=False)
test.to_csv('epwalsh_basics_test.csv', index=False)
# --------------------------- }}}

train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]
train.to_csv('epwalsh_sameArticleDiffColor_train.csv', 
             columns=['sameArticleDiffColor'], index=False)
test.to_csv('epwalsh_sameArticleDiffColor_test.csv', 
            columns=['sameArticleDiffColor'], index=False)

train = pd.read_csv('epwalsh_sameArticleDiffColor_train.csv')
test = pd.read_csv('epwalsh_sameArticleDiffColor_test.csv')
train['sameArticleDiffColor'] = train['sameProductDiffColor']
test['sameArticleDiffColor'] = test['sameProductDiffColor']


# Combine some features
df1 = pd.read_csv('./epwalsh_orderVsSize_class.csv')
df2 = pd.read_csv('./epwalsh_sameArticleDiffColor_class.csv')
df3 = pd.read_csv('./epwalsh_sameProductDiffSize_class.csv')
df = pd.concat([df1, df2, df3], axis=1)
df.to_csv('epwalsh_orders_class.csv', index=False)
