#!/usr/bin/env python
# =============================================================================
# File Name:     combine.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 17-04-2016
# Last Modified: Sun Apr 24 14:49:08 2016
# Purpose:       Combine features and create log-likelihood ratio
#                transformations for all categorical variables and interactions
#                between categorical variables.
# =============================================================================

import pandas as pd
import numpy as np
import os
import re
import math
import sys


# Only change these variables! -------------------------------------------- {{{
vers = 'featureMatrix_v04'
# We don't transform binary variables into llr's. We only focus on interaction
# between binary variables and other variables. Binary variables by themselves
# should be put into the numeric feature matrices as well.
bin_vars = ['businessCustomer',
            'businessCustomer2',
            'legal_holiday',
            'general_holiday',
            'any_holiday',
            'sameArticleDiffSize',
            'sameArticleDiffColor',
            'sameProductDiffSize',
            'repeatOrderSameSize']
# ------------------------------------------------------------------------- }}}


# Functions --------------------------------------------------------------- {{{
def get_llr(values):
    """ Aggregation function for pandas groupby. Needed for llr function. """
    n1 = sum(values)
    n0 = len(values) - n1
    return math.log(n1 + 0.5) - math.log(n0 + 0.5)


def llr(df, var_names, targets, y='returned'):
    """
    Args:
    - df        DataFrame >> historical set
    - var_names list >> variables to transform into llr's
    - targets   list >> target DataFrames
    - y         string >> response variable
    Returns list of llr's corresponding to targets.
    """
    llrs = df.groupby(var_names)[y].agg(get_llr)
    combos = [x for x in llrs.index]
    temp = pd.DataFrame(combos)
    temp['llr'] = llrs.values
    temp.columns = var_names + ['llr']
    res = []
    for targ in targets:
        merged = pd.merge(targ, temp, how='left', on=var_names).fillna(0)
        res.append(merged['llr'].values)
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
    """ Names must be list. """
    out = 'llr_' + names[0]
    if len(names) > 1:
        for name in names[1:]:
            out += '_x_' + name
    return out
# ------------------------------------------------------------------------- }}}


sys.stdout.write('Creating features for ' + vers + '\n\n')
sys.stdout.flush()


# Load index sets
index_hist = np.loadtxt(vers + '/index_historical.csv', dtype='int')
index_train = np.loadtxt(vers + '/index_train.csv', dtype='int')
index_valid = np.loadtxt(vers + '/index_valid.csv', dtype='int')
index_test = np.loadtxt(vers + '/index_test.csv', dtype='int')

# Load data
y = pd.read_csv('returnQuantity.csv')
hist = y.iloc[index_hist]
train = y.iloc[index_train]
valid = y.iloc[index_valid]
test = y.iloc[index_test]
CLASS = pd.DataFrame()


# Numerical variables ----------------------------------------------------- {{{
sys.stdout.write('Gathering numeric variabes\n')
sys.stdout.flush()

num_files = get_data_files('num')
num_files_class = get_data_files('num', set_type='class')

for f in num_files:
    df = pd.read_csv('num/' + f)
    df_train = df.iloc[index_train]
    df_valid = df.iloc[index_valid]
    df_test = df.iloc[index_test]
    train = pd.concat([train, df_train], axis=1)
    valid = pd.concat([valid, df_valid], axis=1)
    test = pd.concat([test, df_test], axis=1)

for f in num_files_class:
    df = pd.read_csv('num/' + f)
    CLASS = pd.concat([CLASS, df], axis=1)
# ------------------------------------------------------------------------- }}}


# Categorical variables --------------------------------------------------- {{{
sys.stdout.write('Gathering categorical variables\n')
sys.stdout.flush()

# Read categorical variables
f_train = 'epwalsh_basics_train.csv'
f_class = 'epwalsh_basics_class.csv'
df = pd.read_csv('cat/' + f_train)
df_class = pd.read_csv('cat/' + f_class)

varnames = df.columns

# Transform response variable to binary
df['y'] = y
df['returned'] = 0
df.loc[df['y'] > 0, ['returned']] = 1
df.drop(['y'], axis=1, inplace=True)

# Split data into historical, train, and test
df_hist = df.iloc[index_hist]
df_train = df.iloc[index_train]
df_valid = df.iloc[index_valid]
df_test = df.iloc[index_test]

del df


# Get all two-way combinations
combos = []
for i in range(len(varnames)):
    if varnames[i] not in bin_vars:
        combos.append([varnames[i]])
    for j in range(i+1, len(varnames)):
        combos.append([varnames[i], varnames[j]])

for x in combos:
    varname = get_name(x)
    sys.stdout.write('Creating llr for ' + varname + '\n')
    sys.stdout.flush()
    [llr_train, llr_valid, llr_test, llr_class] = llr(df_hist, x, [df_train, df_valid, df_test, df_class])
    train[varname] = llr_train
    valid[varname] = llr_valid
    test[varname] = llr_test
    CLASS[varname] = llr_class
# ------------------------------------------------------------------------- }}}

sys.stdout.write('\nFinished creating features.')
sys.stdout.write('Shape of train:      ' + str(train.shape) + '\n')
sys.stdout.write('Shape of validation: ' + str(valid.shape) + '\n')
sys.stdout.write('Shape of test:       ' + str(test.shape) + '\n')
sys.stdout.write('Shape of class:      ' + str(CLASS.shape) + '\n')
sys.stdout.flush()

sys.stdout.write('Writing training set to file\n')
sys.stdout.flush()
train.to_csv(vers + '/train.csv', index=False)
sys.stdout.write('Writing validation set to file\r')
sys.stdout.flush()
valid.to_csv(vers + '/valid.csv', index=False)
sys.stdout.write('Writing test set to file\r')
sys.stdout.flush()
test.to_csv(vers + '/test.csv', index=False)
sys.stdout.write('Writing classification set to file\r')
sys.stdout.flush()
CLASS.to_csv(vers + '/class.csv', index=False)

sys.stdout.write('\nDone!\n')
