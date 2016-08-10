#!/usr/bin/env python
# =============================================================================
# File Name:     llr.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 09-04-2016
# Last Modified: Fri Apr 22 10:29:17 2016
# =============================================================================

import pandas as pd
import os
import re
import math


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


def llr_old(df, var_names, targetX, y='returned'):
    """
    Parameters:
      df        - pandas dataframe
      var_names - a list of names of categorical variables in df
      y         - the response variable, should be 0's and 1's
      targetX   - the target feature matrix
    Returns: a list of llr ratios

    This is based on Cory Lanker's LLR approach to transforming categorical
    variables to continuous variables.
    """
    out = []
    counts = df.groupby(var_names + [y])[y].count()
    combos = [x for x in counts.index]
    for i in targetX.index:
        t1 = tuple(list(targetX.ix[i][var_names].values) + [1])
        t0 = tuple(list(targetX.ix[i][var_names].values) + [0])
        n1 = counts[t1] if t1 in combos else 0
        n0 = counts[t0] if t0 in combos else 0
        out.append(math.log(n1 + 0.5) - math.log(n0 + 0.5))
    return out
