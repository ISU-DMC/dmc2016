#!/usr/bin/env python
# =============================================================================
# File Name:     finalize.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 17-05-2016
# Last Modified: Tue May 17 20:54:30 2016
# =============================================================================

import pandas as pd
import numpy as np

df = pd.read_csv('../raw_data/orders_class.txt', sep=';')

df.drop(['orderDate', 'productGroup', 'price', 'rrp', 
         'voucherID', 'voucherAmount', 'customerID', 
         'deviceID', 'paymentMethod'], axis=1, inplace=True)

# Team 1 {{{
preds = np.loadtxt('./final/final_xgV1_linLassoV1.csv')

#  preds.drop(['continuous'], axis=1, inplace=True)
#  preds.columns = ['prediction']

#  df = pd.concat([df, preds], axis=1)
df['prediction'] = preds
df['prediction'] = df['prediction'].astype(int)

# Check for quantity = 0
df.loc[(df['quantity'] == 0) & (df['prediction'] == 1), :]
df.loc[df['quantity'] < df['prediction'], :]

# Save results
df.drop(['quantity'], axis=1, inplace=True)
df.to_csv('Uni_Iowa_State_1.txt', index=False, sep=';')
# }}}

# Team 2 {{{
preds = np.loadtxt('./final_xgV1_xgV2.csv')

#  preds.drop(['continuous'], axis=1, inplace=True)
#  preds.columns = ['prediction']

#  df = pd.concat([df, preds], axis=1)
df['prediction'] = preds
df['prediction'] = df['prediction'].astype(int)

# Check for quantity = 0
df.loc[(df['quantity'] == 0) & (df['prediction'] == 1), :]
df.loc[df['quantity'] < df['prediction'], :]

# Save results
df.drop(['quantity'], axis=1, inplace=True)
df.to_csv('Uni_Iowa_State_2.txt', index=False, sep=';')
# }}}
