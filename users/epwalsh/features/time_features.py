#!/usr/bin/env python
# =============================================================================
# File Name:     time.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 22-04-2016
# Last Modified: Wed Apr 27 13:09:57 2016
# =============================================================================

import pandas as pd


train = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_train.txt', sep=';')
test = pd.read_csv('~/ISU-DMC/dmc2016/data/raw_data/orders_class.txt', sep=';')

train.drop(['returnQuantity'], axis=1, inplace=True)
cutoff = train.shape[0]

df = pd.concat([train, test])
df.shape

del test
del train

# Time between consequetive visits ---------------------------------------- {{{
df['date'] = pd.to_datetime(df['orderDate'])


def get_diff(values):
    if len(values) <= 1:
        return [-1]
    else:
        res = []
        res.append([-1])
        for i in range(len(values) - 1):
            res.append((pd.to_datetime(values[i+1]) - pd.to_datetime(values[i])) / pd.offsets.Day(1))
    return res


#  test_df = df.iloc[0:10]
#  test_df
times = df.groupby(['customerID'])['date'].unique()
diffs = map(get_diff, times)
diffs = pd.Series(diffs, index=times.index)

customerID = []
date = []
time_diff = []


def build(x):
    for j in range(len(times[x])):
        customerID.append(x)
        date.append(pd.to_datetime(times[x][j]))
        time_diff.append(diffs[x][j])

_ = map(build, times.index)

len(customerID)
len(date)
len(time_diff)

d = {'customerID': customerID, 'date': date, 'time_diff': time_diff}
new_df = pd.DataFrame(d)

res = pd.merge(df, new_df, how='left', on=['customerID', 'date'])

res.shape
df.shape
res.head()
df.head()


res['time_between'] = [x[0] if type(x) is list else x for x in res['time_diff']]
max_time = res['time_between'].max()
max_time
res['time_between2'] = res['time_between'].values
res.loc[res['time_between'] == -1.0, ['time_between2']] = max_time + 1

del df

train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.shape
test.shape

train.to_csv('time_between_train.csv',
             columns=['time_between', 'time_between2'],
             index=False)

test.to_csv('time_between_class.csv',
            columns=['time_between', 'time_between2'],
            index=False)
# ------------------------------------------------------------------------- }}}

# Mean time between visits ------------------------------------------------ {{{
new_train = pd.read_csv('./time_between_train.csv')
new_test = pd.read_csv('./time_between_class.csv')
new = pd.concat([new_train, new_test])

del new_train
del new_test

df = pd.concat([df, new], axis=1)

mean_times = df.groupby(['customerID'])['time_between2'].mean()
mean_times
mean_times = mean_times.reset_index()
mean_times.columns[1] = 'mean_time_between'
mean_times.columns = ['customerID', 'mean_time_between']

res = pd.merge(df, mean_times, how='left', on=['customerID'])

train = res.iloc[0:cutoff]
test = res.iloc[cutoff:]

train.to_csv('epwalsh_timeBetween_train.csv', index=False,
             columns=['time_between', 'time_between2', 'mean_time_between'])

test.to_csv('epwalsh_timeBetween_class.csv', index=False,
            columns=['time_between', 'time_between2', 'mean_time_between'])
# ------------------------------------------------------------------------- }}}


# 
# Time since arrival of new articleID, productGroup, colorCode


