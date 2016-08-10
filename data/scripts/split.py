#!/usr/bin/env python
# =============================================================================
# File Name:     split.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 15-04-2016
# Last Modified: Sun Apr 24 15:35:09 2016
# =============================================================================

import pandas as pd
import numpy as np
import random

df = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
df['date'] = pd.to_datetime(df['orderDate'])

index = set(df.index)

# Observations in training set from Oct - Dec 2014
sdf = df.loc[(df['date'] >= pd.datetime(2014, 10, 1)) &
             (df['date'] <= pd.datetime(2014, 12, 31)), :]
sdf.shape
del df

# Get all customers
customers = list(sdf['customerID'].unique())
len(customers)

# Get all orderIDs
sdf_orders = list(sdf['orderID'].unique())
orders = list(df['orderID'].unique())
len(sdf_orders)
len(orders)

# Split data by orders SET 5 ---------------------------------------------- {{{
random.seed(1)
random.shuffle(orders)

orders_sdf_historical = set(sdf_orders[0:30000])
orders_train = set(sdf_orders[30000:80000])
orders_test = set(sdf_orders[80000:])

orders_historical = (set(orders) - orders_train) - orders_test

len(orders_historical) + len(orders_train) + len(orders_test) == len(orders)

historical = df.loc[df['orderID'].isin(orders_historical)]
train = sdf.loc[df['orderID'].isin(orders_train)]
test = sdf.loc[df['orderID'].isin(orders_test)]

historical.shape
train.shape
test.shape

index_historical = historical.index
index_train = train.index
index_test = test.index

np.savetxt('./featureMatrix_v05/index_historical.csv', index_historical, fmt='%d')
np.savetxt('./featureMatrix_v05/index_train.csv', index_train, fmt='%d')
np.savetxt('./featureMatrix_v05/index_test.csv', index_test, fmt='%d')
# ------------------------------------------------------------------------- }}}

# Split data by customers
random.seed(1)
random.shuffle(customers)
customers_historical = set(customers[0:20000])
customers_train = set(customers[20000:50000])
customers_test = set(customers[50000:])
len(customers_historical) + len(customers_train) + len(customers_test) == len(customers)

historical = sdf.index[sdf['customerID'].isin(customers_historical)]
train = sdf.index[sdf['customerID'].isin(customers_train)]
test = sdf.index[sdf['customerID'].isin(customers_test)]

historical.shape
train.shape
test.shape

np.savetxt('index_historical.csv', historical, fmt='%d')
np.savetxt('index_train.csv', train, fmt='%d')
np.savetxt('index_test.csv', test, fmt='%d')


# Feature matrix v02

index_hist = np.loadtxt('./index_historical.csv')
index_train = np.loadtxt('./index_train.csv')
index_test = np.loadtxt('./index_test.csv')

len(index_hist) + len(index_train) + len(index_test)

bottom = min(min(index_train), min(index_hist), min(index_test))
df.iloc[bottom]

new_hist = range(0, int(bottom))
new_hist.extend(index_hist)

top = max(max(index_train), max(index_hist), max(index_test)) + 1
df.iloc[top]

df.iloc[df.shape[0]-1]
new_hist2 = range(int(top), df.shape[0])
new_hist.extend(new_hist2)

len(new_hist) + len(index_train) + len(index_test)
df.shape[0]

np.savetxt('./featureMatrix_v02/index_historical.csv', new_hist, fmt='%d')
np.savetxt('./featureMatrix_v02/index_train.csv', index_train, fmt='%d')
np.savetxt('./featureMatrix_v02/index_test.csv', index_test, fmt='%d')


# Feature matrix v03

global_test = np.loadtxt('featureMatrix_v02/index_test.csv')

orders = df.drop(global_test)['orderID'].unique()
#  orders = list(df['orderID'].unique())
len(orders)  # 738698
df.shape

# Split data by orders
random.seed(1)
random.shuffle(orders)

orders_historical = set(orders[0:600000])
orders_train = set(orders[600000:700000])
orders_test = set(orders[700000:])
len(orders_historical) + len(orders_train) + len(orders_test) == len(orders)
orders_test

index_historical = df.index[df['orderID'].isin(orders_historical)]
index_train = df.index[df['orderID'].isin(orders_train)]
index_test = df.index[df['orderID'].isin(orders_test)]
index_test = np.concatenate((index_test, global_test))

len(index_historical) + len(index_train) + len(index_test) == df.shape[0]

np.savetxt('./featureMatrix_v03/index_global_test.csv', global_test, fmt='%d')
np.savetxt('./featureMatrix_v03/index_historical.csv', index_historical, fmt='%d')
np.savetxt('./featureMatrix_v03/index_train.csv', index_train, fmt='%d')
np.savetxt('./featureMatrix_v03/index_test.csv', index_test, fmt='%d')



# HTVC 4 ------------------------------------------------------------------ {{{
index = df.index

# Remove outlier days
rday = df.groupby('date')['returnQuantity'].mean()
rday = rday.reset_index()
rday['outlier'] = 0
rday.loc[rday['returnQuantity'] <= 0.485, ['outlier']] = 1
rday.drop(['returnQuantity'], axis=1, inplace=True)

df = pd.merge(df, rday, how='left', on=['date'])
outliers = df.loc[df['outlier'] == 1, :].index
new_df = df.loc[df['outlier'] == 0, :]

week = [x.week for x in new_df['date']]
new_df['week'] = week

# Historical
df_hist = new_df.loc[new_df['date'] <= pd.datetime(2015, 6, 30), :]
samp_days = []
for week in range(1, 53):
    sample = df_hist.loc[df_hist['week'] == week, :].sample(1000).index
    samp_days.extend(list(sample))

index_hist = list(set(df_hist.index) - set(samp_days))
index_hist = np.array(index_hist)
np.savetxt('./featureMatrix_v04/index_historical.csv', index_hist, fmt='%d')

# Train
july_index = new_df.loc[(new_df['date'] >= pd.datetime(2015, 7, 1)) & 
                        (new_df['date'] <= pd.datetime(2015, 7, 31)), :].index
index_train = np.array(samp_days + list(july_index))
np.savetxt('./featureMatrix_v04/index_train.csv', index_train, fmt='%d')

# Validation
new_df.loc[(new_df['date'] >= pd.datetime(2015, 8, 1)) &
           (new_df['date'] <= pd.datetime(2015, 8, 31)), :].shape

index_valid = new_df.loc[(new_df['date'] >= pd.datetime(2015, 8, 1)) &
                         (new_df['date'] <= pd.datetime(2015, 8, 31)), :].index
np.savetxt('./featureMatrix_v04/index_valid.csv', index_valid, fmt='%d')

# Test
new_df.loc[(new_df['date'] >= pd.datetime(2015, 9, 1)) &
           (new_df['date'] <= pd.datetime(2015, 9, 30)), :].shape

index_test = new_df.loc[(new_df['date'] >= pd.datetime(2015, 9, 1)) &
                        (new_df['date'] <= pd.datetime(2015, 9, 30)), :].index
np.savetxt('./featureMatrix_v04/index_test.csv', index_test, fmt='%d')


train = np.loadtxt('./featureMatrix_v04/index_train.csv')
test = np.loadtxt('./featureMatrix_v04/index_test.csv')
valid = np.loadtxt('./featureMatrix_v04/index_valid.csv')
hist = np.loadtxt('./featureMatrix_v04/index_historical.csv')
# ------------------------------------------------------------------------- }}}
