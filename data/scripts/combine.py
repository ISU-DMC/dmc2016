#!/usr/bin/env python
# =============================================================================
# File Name:     combine.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 17-04-2016
# Last Modified: Wed Apr 20 13:17:56 2016
# =============================================================================

import pandas as pd
import numpy as np
import os
import re
import math
import sys


# Only change this variable!
# --------------------------
vers = 'featureMatrix_v03'
# --------------------------


def llr(df, var_names, targets, y='returned'):
    """var_names is list, targets is list of DataFrames"""
    counts = df.groupby(var_names + [y])[y].count()
    combos = [x for x in counts.index]
    res = []
    for targ in targets:
        llrs = []
        for i in targ.index:
            t1 = tuple(list(targ.ix[i][var_names].values) + [1])
            t0 = tuple(list(targ.ix[i][var_names].values) + [0])
            n1 = counts[t1] if t1 in combos else 0
            n0 = counts[t0] if t0 in combos else 0
            llrs.append(math.log(n1 + 0.5) - math.log(n0 + 0.5))
        res.append(llrs)
    return res


def get_files(path, hidden=False):
    if not hidden:
        return filter(lambda f: os.path.isfile(os.path.join(path, f)) and not
                      f.startswith('.'), os.listdir(path))
    else:
        return filter(lambda f: os.path.isfile(os.path.join(path, f)),
                      os.listdir(path))


def get_data_files(path, set_type='train'):
    files = get_files(path)
    data_files = []
    pattern = '.*_' + set_type + '\\.csv'
    for f in files:
        if re.search(pattern, f):
            data_files.append(f)
    return data_files


def get_name(names):
    """"names must be list"""
    out = 'llr_' + names[0]
    if len(names) > 1:
        for name in names[1:]:
            out += '_x_' + name
    return out


# Load index sets
index_hist = np.loadtxt(vers + '/index_historical.csv', dtype='int')
index_train = np.loadtxt(vers + '/index_train.csv', dtype='int')
index_test = np.loadtxt(vers + '/index_test.csv', dtype='int')

# Load data
y = pd.read_csv('returnQuantity.csv')
hist = y.iloc[index_hist]
train = y.iloc[index_train]
test = y.iloc[index_test]
CLASS = pd.DataFrame()


# Numerical variables
# ------------------------------------------------------------------------- {{{
sys.stdout.write('Gathering numeric variabes\n')
sys.stdout.flush()

num_files = get_data_files('num')
num_files_class = get_data_files('num', set_type='class')

for f in num_files:
    df = pd.read_csv('num/' + f)
    df_train = df.iloc[index_train]
    df_test = df.iloc[index_test]
    train = pd.concat([train, df_train], axis=1)
    test = pd.concat([test, df_test], axis=1)

for f in num_files_class:
    df = pd.read_csv('num/' + f)
    CLASS = pd.concat([CLASS, df], axis=1)
# ------------------------------------------------------------------------- }}}


# Categorical variables
# ------------------------------------------------------------------------- {{{
sys.stdout.write('Gathering categorical variables\n')
sys.stdout.flush()

#  cat_files = get_data_files('cat')
#  cat_files
f_train = 'epwalsh_basics_train.csv'
f_class = 'epwalsh_basics_class.csv'
df = pd.read_csv('cat/' + f_train)
df_class = pd.read_csv('cat/' + f_class)

varnames = df.columns

df['y'] = y
df['returned'] = 0
df.loc[df['y'] > 0, ['returned']] = 1
df.drop(['y'], axis=1, inplace=True)

df_hist = df.iloc[index_hist]
df_train = df.iloc[index_train]
df_test = df.iloc[index_test]

del df

#  for x in df_hist.columns[:-1]:
    #  print "Creating llr for", x
    #  [llr_train, llr_test] = llr(df_hist, [x], [df_train, df_test])
    #  train['llr_' + x] = llr_train
    #  test['llr_' + x] = llr_test

# Get all two-way combinations
combos = []
for i in range(len(varnames)):
    combos.append([varnames[i]])
    for j in range(i+1,len(varnames)):
        combos.append([varnames[i], varnames[j]])

for x in combos:
    varname = get_name(x)
    sys.stdout.write('Creating llr for ' + varname + '\n')
    sys.stdout.flush()
    [llr_train, llr_test, llr_class] = llr(df_hist, x, [df_train, df_test, df_class])
    train[varname] = llr_train
    test[varname] = llr_test
    CLASS[varname] = llr_class
# ------------------------------------------------------------------------- }}}

# Testing
#  varname = get_name(x)
#  x = combos[51]
#  [llr_train, llr_test, llr_class] = llr(df_hist, x, [df_train, df_test, df_class])

#  train[varname] = llr_train
#  test[varname] = llr_test
#  CLASS[varname] = llr_class
#  CLASS.head()
#  CLASS['llr_paymentMethod_x_week']
#  df_class.head()
#  df_class[['week', 'paymentMethod']]
# ----

# Output to csv files
train.to_csv(vers + '/train.csv', index=False)
test.to_csv(vers + '/test.csv', index=False)
CLASS.to_csv(vers + '/class.csv', index=False)

# LLR interactions
#  varnames = df.columns
#  varnames

#  combine_names(varnames[0], varnames[1])
#  get_name([varnames[0:2]])
#  get_name(varnames[0:3])

#  combos = []
#  for i in range(len(varnames)):
    #  combos.append([varnames[i]])
    #  for j in range(i+1,len(varnames)):
        #  combos.append([varnames[i], varnames[j]])

#  for x in combos:
    #  varname = get_name(combo)
    #  print "Creating llr for", varname
    #  [llr_train, llr_test] = llr(df_hist, x, [df_train, df_test])
    #  train[varname] = llr_train
    #  test[varname] = llr_test
