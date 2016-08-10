#!/usr/bin/env python
# =============================================================================
# File Name:     01_explore.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 06-04-2016
# Last Modified: Thu Jun  9 15:28:31 2016
# =============================================================================

import pandas as pd
import seaborn as sns
from os.path import expanduser

home = expanduser('~')
path = home + '/ISU-DMC/dmc2016/data/raw_data/orders_train.txt'
df = pd.read_csv(path, sep=';')
#  path2 = home + '/ISU-DMC/dmc2016/data/raw_data/orders_class.txt'
#  cdf = pd.read_csv(path2, sep=';')

df.shape   # (2325165, 16)
#  cdf.shape  # (341098, 14)

# How many unique values for categorical variables? {{{
len(df['customerID'].unique())     # 311369
len(df['colorCode'].unique())      # 546
len(df['productGroup'].unique())   # 19
len(df['voucherID'].unique())      # 671
len(df['deviceID'].unique())       # 5
len(df['paymentMethod'].unique())  # 10
len(df['sizeCode'].unique())       # 29
len(df['articleID'].unique())      # 3823
# }}}

# Distribution of numerical variables >> max    | mean      {{{
df['quantity'].describe()              # 24.0   | 0.996
df['price'].describe()                 # 623.76 | 35.399
df['rrp'].describe()                   # 799.99 | 42.985
df['voucherAmount'].describe()         # 300    | 2.153
df['returnQuantity'].describe()        # 5      | 0.521     }}}

# rrp, price, vouchers {{{
df['rrp'].unique()

df.loc[df['rrp'] == 0, ['rrp', 'price']]
df.loc[df['rrp'] == 0, :]

# There are some cases where return quantity > quantity... wtf
df.loc[df['returnQuantity'] > df['quantity'], :]

df.loc[(df['price'] == 0) & (df['quantity'] != 0), :].head()
df.loc[(df['price'] == 0) & (df['quantity'] == 0), :]

len(df.loc[df['voucherAmount'] == 0, 'voucherID'].unique())  # 410
df.loc[df['voucherID'] == '0', 'voucherAmount'].describe()
df.loc[pd.isnull(df['voucherID']), :]

# Price > rrp only when quantity >= 2, so this is not an inconsistency
df.loc[df['rrp'] < df['price'],
       ['orderID', 'price', 'rrp', 'voucherID', 'voucherAmount', 'quantity']]

# At most 1 voucher per orderID
df.loc[df['voucherAmount'] > df['price'], :]
res = df.groupby(['orderID'])['voucherID'].unique()
[x for x in res if len(x) > 1]
# }}}

# NA values {{{
len(df.loc[pd.isnull(df['productGroup']), :])   # 351
len(df.loc[pd.isnull(df['rrp']), :])            # 351
len(df.loc[pd.isnull(df['voucherID']), :])      # 6

# rrp is NA iff productGroup is NA
len(df.loc[pd.isnull(df['rrp']) & pd.isnull(df['productGroup']), :])
df.loc[pd.isnull(df['rrp']) & pd.isnull(df['productGroup']), 'price'].describe()
# >> Theory: these are probably wierd items that can't be classified into one
# of the product groups
# Size code is all A
df.loc[pd.isnull(df['rrp']) & pd.isnull(df['productGroup']), 'sizeCode'].describe()
len(df.loc[df['sizeCode'] == 'A', :])  # Shit load
df.loc[pd.isnull(df['rrp']) & pd.isnull(df['productGroup'])]
df.iloc[11633945,:]
df.shape
# }}}

# vouchers yo {{{
vouchers = df['voucherID'].unique()
#  vouchers = vouchers[~pd.isnull(vouchers)]
indices = []
dates = []
for voucher in vouchers:
    index = min(df.loc[df['voucherID'] == voucher, :].index)
    indices.append(index)
    dates.append(df.iloc[index]['date'])
d = {'voucherID': vouchers,
     'position': pd.Series(indices),
     'dates': pd.Series(dates)}
vdf = pd.DataFrame(d)
sns.stripplot(x='position', data=vdf, jitter=True)
sns.plt.show()
# >> There is definitely an influx of new voucherID's around the holiday
# season.
# }}}

# Dates {{{
df['date'] = pd.to_datetime(df['orderDate'])

# Dates in training set from Oct - Dec 2014
df.loc[(df['date'] >= pd.datetime(2014, 10, 1)) &
       (df['date'] <= pd.datetime(2014, 12, 31)), :]
# >> 291764 total

df['returnQuantity'] = df['returnQuantity'].astype(int)
by_day = df.groupby(['date'])['returnQuantity'].mean()
by_day.reset_index().to_csv('./by_day.csv', index=False)

sns.set_context('poster')
p = by_day.plot()
sns.plt.show()

df.iloc[0]['date'].dayofweek
dow = [x.dayofweek for x in df['date']]
df['dow'] = pd.Series(dow, dtype='category')
df.groupby(['dow'])['returnQuantity'].mean()

df['dow'].describe()
week = [x.week for x in df['date']]
df['week'] = pd.Series(week, dtype='category')
df.groupby(['week'])['returnQuantity'].mean().plot()
sns.plt.show()
# }}}

# articleID {{{
df.groupby(['articleID'])['sizeCode'].unique()
# >> The same articleID can correspond to different sizes

df.groupby(['articleID'])['colorCode'].unique()
# >> Same goes for articleID with colorCode

df.groupby(['articleID'])['productGroup'].unique()
# >> Only one productGroup for each articleID
# }}}

# Size vs color in orders {{{
df.groupby(['sizeCode', 'orderID'])['returnQuantity'].mean()
df.groupby(['orderID', 'articleID'])

samp_df = df.iloc[0:10000]
samp_df.to_csv("samp.csv", index=False)
# }}}

df.groupby(['orderID', 'articleID', 'quantity'])['colorCode'].unique()

df.groupby(['productGroup'])['sizeCode'].unique()

sum1 = df.groupby(['productGroup', 'sizeCode'])['price'].mean()
print sum1


def print_full(x):
    pd.set_option('display.max_rows', len(x))
    print(x)
    pd.reset_option('display.max_rows')

print_full(sum1)

del df

train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')
train.drop(['returnQuantity'], axis=1, inplace=True)
df = pd.concat([train, test])
del train, test

sum1 = df.groupby(['customerID'])['orderID'].unique()
sum1 = sum1.reset_index()
counts = [len(x) for x in sum1['orderID']]
sum1['counts'] = counts
sum1.loc[sum1['counts'] > 3, :].shape
