#!/usr/bin/env python
# =============================================================================
# File Name:     blend.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 26-04-2016
# Last Modified: Thu Jun  9 14:59:36 2016
# =============================================================================

import pandas as pd
import numpy as np
import seaborn as sns


# Functions {{{
def blend(predictions, weights):
    res = weights[0] * np.copy(predictions[0])
    for i in range(1, len(predictions)):
        res = res + weights[i] * predictions[i]
    res[res >= 0.5] = 1
    res[res < 0.5] = 0
    return res


def blend2(predictions, weights):
    res = weights[0] * np.copy(predictions[0])
    for i in range(1, len(predictions)):
        res = res + weights[i] * predictions[i]
    #  res[res >= 0.5] = 1
    #  res[res < 0.5] = 0
    return res


def mae(y, y_hat):
    diffs = np.absolute(y - y_hat)
    return np.mean(diffs)


def grid_search(y, y_hat1, y_hat2):
    thetas = np.linspace(0, 1, num=101)
    maes = []
    for theta in thetas:
        blended = blend([y_hat1, y_hat2], [theta, 1 - theta])
        err = mae(y, blended)
        maes.append(err)
        print '%1.8f %1.2f' % (err, theta)
    maes = np.array(maes)
    min_i = np.argmin(maes)
    out = {'theta': thetas[min_i], 'mae': maes[min_i]}
    return out


def compare(y, y_hat1, y_hat2):
    thetas = np.linspace(0, 1, num=101)
    maes = []
    for theta in thetas:
        blended = blend([y_hat1, y_hat2], [theta, 1 - theta])
        err = mae(y, blended)
        maes.append(err)
    maes = np.array(maes)
    min_i = np.argmin(maes)
    d = {'mae': maes, 'theta': thetas}
    df = pd.DataFrame(d)
    sns.set_style('darkgrid')
    ax = sns.pointplot(x='theta', y='mae', data=df)
    ax.set_xticks([])
    sns.plt.axvline(x=min_i)
    lab = 'BEST (theta: ' + str(thetas[min_i]) + ', MAE: ' + str(maes[min_i]) + ')'
    ax.set(xlabel=lab, ylabel='MAE')
    sns.plt.show()


def compare2(y, y_hat1, y_hat2):
    thetas = np.linspace(0, 1, num=101)
    maes = []
    for theta in thetas:
        blended = blend2([y_hat1, y_hat2], [theta, 1 - theta])
        err = mae(y, blended)
        maes.append(err)
    maes = np.array(maes)
    min_i = np.argmin(maes)
    d = {'mae': maes, 'theta': thetas}
    df = pd.DataFrame(d)
    sns.set_style('darkgrid')
    ax = sns.pointplot(x='theta', y='mae', data=df)
    ax.set_xticks([])
    sns.plt.axvline(x=min_i)
    lab = 'BEST (theta: ' + str(thetas[min_i]) + ', MAE: ' + str(maes[min_i]) + ')'
    ax.set(xlabel=lab, ylabel='MAE')
    sns.plt.show()


def compare_multiway(y, y_hat):
    thetas = np.linspace(0, 1, num=101)
    maes = []
    for theta in thetas:
        theta2 = (1 - theta) / (len(y_hat) - 1)
        blended = blend(y_hat, [theta] + list(np.repeat(theta2, len(y_hat) - 1)))
        err = mae(y, blended)
        maes.append(err)
    maes = np.array(maes)
    min_i = np.argmin(maes)
    d = {'mae': maes, 'theta': thetas}
    df = pd.DataFrame(d)
    sns.set_style('darkgrid')
    ax = sns.pointplot(x='theta', y='mae', data=df)
    ax.set_xticks([])
    sns.plt.axvline(x=min_i)
    lab = 'BEST (theta: ' + str(thetas[min_i]) + ', MAE: ' + str(maes[min_i]) + ')'
    ax.set(xlabel=lab, ylabel='MAE')
    sns.plt.show()
# }}}

# Team 1 compare {{{
y = np.loadtxt('returnQuantityV2.csv')

lin_lasso = pd.read_csv('./V1/LiXinyi_LinearLASSO.csv')
lin_ridge = pd.read_csv('./V1/LiXinyi_LinearRidge.csv')
lr_lasso = pd.read_csv('./V1/LiXinyi_LogisticLASSO.csv')
lr_ridge = pd.read_csv('./V1/LiXinyi_LogisticRidge.csv')
lda = pd.read_csv('./V1/mjohny_LDA2.csv')
c50 = pd.read_csv('./V1/keguoh_C50.csv')
xg = pd.read_csv('./V1/epwalsh_xgboost.csv')
rf = pd.read_csv('./V1/yzdu_RF_V1_for_test.csv')
et = pd.read_csv('./V1/qili_extraTrees.csv')

xg1 = pd.read_csv('./output_prob1.csv')
xg2 = pd.read_csv('./output_prob2.csv')
xg3 = pd.read_csv('./output_prob3.csv')
xg4 = pd.read_csv('./output_prob4.csv')

compare_multiway(y, [xg['continuous'], xg1['y_pred'], xg2['y_pred'], xg3['y_pred'], xg4['y_pred']])
compare(y, xg['continuous'], xg1['y_pred'])
compare(y, xg['continuous'], lin_lasso['continuouts'])
compare2(y, xg['continuous'], lin_lasso['continuouts'])
compare(y, lin_lasso['continuouts'], c50['continuous'])

compare(y, xg['continuous'], xg2['y_pred'])
compare(y, xg['continuous'], xg3['y_pred'])
compare(y, xg['continuous'], xg4['y_pred'])
compare(y, xg1['y_pred'], lin_lasso['continuouts'])
compare_multiway(y, [xg['continuous'], xg1['y_pred'], lin_lasso['continuouts']])


mae(y, lin_lasso['binary'])
mae(y, lin_ridge['binary'])
mae(y, lr_lasso['binary'])
mae(y, lr_ridge['binary'])
mae(y, lda['binary'])
mae(y, c50['binary'])
mae(y, xg['binary'])
mae(y, rf['x'])
mae(y, et['binary'])

compare(y, xg['continuous'], lin_lasso['continuouts'])
compare(y, xg['continuous'], lin_ridge['continuouts'])
compare(y, xg['continuous'], lr_lasso['continuous'])
compare(y, xg['continuous'], lr_ridge['continuous'])
compare(y, xg['continuous'], lda['continuous'])
compare(y, xg['continuous'], c50['continuous'])

compare_multiway(y, [xg['continuous'], lr_lasso['continuous'], 
                     lr_ridge['continuous'], lda['continuous'], 
                     c50['continuous'], lin_lasso['continuouts'],
                     lin_ridge['continuouts']])
compare_multiway(y, [xg['binary'], lr_lasso['binary'], 
                     lr_ridge['binary'], lda['binary'], 
                     c50['binary'], rf['x']])
res = blend([xg['continuous'], lin_lasso['continuouts']], [0.72, 0.28])
mae(y, res)
# }}}

# Team 1 final {{{
lasso.head()
xg = pd.read_csv('./final/epwalsh_xgboost_V1.csv')
lasso = pd.read_csv('./final/LiXinyi_LinearLASSO_V1.csv')
out = blend([xg['continuous'], lasso['continuous']], [0.72, 0.28])
np.savetxt('final/final_xgV1_linLassoV1.csv', out.values, fmt='%d')
# }}}

# Team 2 compare {{{
y = np.loadtxt('./returnQuantityV2.csv')
xg1 = pd.read_csv('./V1/epwalsh_xgboost.csv')
xg2 = pd.read_csv('./V2/epwalsh_xgboost.csv')


thetas = np.linspace(0, 1, num=101)
maes = []
for theta in thetas:
    blended = blend([xg1['continuous'], xg2['continuous']], [theta, 1 - theta])
    err = mae(y, blended)
    maes.append(err)

maes = np.array(maes)
min_i = np.argmin(maes)
d = {'mae': maes, 'theta': thetas}
df = pd.DataFrame(d)
df.to_csv('./team2_final.csv', index=False)

sns.set_context('poster')
sns.set_style('darkgrid')

ax = sns.pointplot(x='theta', y='mae', data=df)
ax.set_xticks([])
ax.set(yticklabels=[])
sns.plt.axvline(x=min_i)
ax.set(xlabel='', ylabel='')
sns.plt.show()

compare(y, xg1['continuous'], xg2['continuous'])
compare2(y, xg1['continuous'], xg2['continuous'])
res = blend([xg1['continuous'], xg2['continuous']], [0.55, 0.45])
mae(y, res)
# }}}

# Team 2 final {{{
# 0.55 * xgboost V1 + 0.45 * xgboost V2
xg1 = pd.read_csv('./final/epwalsh_xgboost_V1.csv')
xg2 = pd.read_csv('./final/epwalsh_xgboost_V2.csv')
out = blend([xg1['continuous'], xg2['continuous']], [0.55, 0.45])
np.savetxt('final_xgV1_xgV2.csv', out.values, fmt='%d')
# }}}

# Correlation {{{
df = pd.concat([xg1, xg2], axis=1)
df = pd.concat([xg1, c50], axis=1)
df = pd.concat([xg2, c50], axis=1)
df = pd.concat([xg2, lr1], axis=1)
df = pd.concat([lr1, lr2], axis=1)
df = pd.concat([xg2, lr], axis=1)
df.head()
df.iloc[:, [1, 3]].corr()
df.corr()

xg1 = pd.read_csv('./final/epwalsh_xgboost_V1.csv')
xg2 = pd.read_csv('./final/epwalsh_xgboost_V2.csv')
c50 = pd.read_csv('./final/keguoh_C50_V1.csv')
lr2 = pd.read_csv('./final/abhishek_LR_V2.csv')
lr1 = pd.read_csv('./final/abhishek_LR_V1.csv')
lda = pd.read_csv('./final/mjohny_LDA2_V1.csv')
lda = pd.read_csv('./final/mjohny_LDA2_V2.csv')

c50 = pd.read_csv('./final/keguoh_C50_V1.csv')
lr = pd.read_csv('./final/abhishek_LR_V1.csv')

mae(xg1['binary'], xg2['binary'])
mae(xg2['binary'], lda['binary'])
mae(xg2['binary'], lda['binary'])
mae(c50['binary'], xg2['binary'])
mae(xg2['binary'], lr1['binary'])
mae(xg2['binary'], lr2['binary'])

c50['binary'].mean()

xg1['binary'].mean()
xg2['binary'].mean()
lr['binary'].mean()
lr2['binary'].mean()
lda['binary'].mean()

y.mean()

out1 = np.loadtxt('final/final_xgV1_linLassoV1.csv')
out2 = np.loadtxt('final/final_xgV1_xgV2.csv')
out1.mean()
out2.mean()
mae(out1, out2)

xg1 = pd.read_csv('./output_prob_class1.csv')
xg = pd.read_csv('./final/epwalsh_xgboost_V1.csv')

out = blend([xg['continuous'], xg1['y_pred']], [0.78, 0.22])
out.mean()

# }}}
