#!/usr/bin/env python
# =============================================================================
# File Name:     github_api.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 05-04-2016
# Last Modified: Wed May 18 13:40:06 2016
# =============================================================================

import os
import json
import pandas as pd
import seaborn as sns
from os.path import expanduser
from csv import DictReader

home = expanduser('~')

with open(home + '/.github') as f:
    reader = DictReader(f)
    credentials = list(reader)

username = credentials[0]['username']
password = credentials[0]['password']

base = 'curl -u ' + username + ':' + password + ' https://api.github.com/'


def api_get(cmd):
    res = os.popen(base + cmd).read()
    return json.loads(res)

langs = api_get('repos/epwalsh/dmc2016/languages')
commits = api_get('repos/epwalsh/dmc2016/stats/participation')
commits_all = api_get('repos/epwalsh/dmc2016/stats/commit_activity')

# Commit stats {{{
weeks = [x['days'] for x in commits_all if x['total'] > 0]
weeks = weeks[1:]
weeks
days = [x for week in weeks for x in week]
days = days[:-3]

dates = pd.date_range('3/27/2016', periods=len(days))
dates_pretty = [str(x.month) + '-' + '%02d' % x.day for x in dates]

d = {'commits': days, 'date': dates}
df = pd.DataFrame(d)
df = df.set_index(df.date)

sns.set_style('whitegrid')
sns.set_palette('Paired')

#  sns.tsplot(df.commits)
#  sns.factorplot(x='date', data=df, kind='count', order=dates)
p = sns.barplot(x='date', y='commits', data=df)
p.set_xticklabels(dates_pretty, rotation=90)
p.set(xlabel='', ylabel='commits')
sns.plt.show()
# }}}

# Language stats {{{
names = [x for x in langs.keys()]
counts = [langs[x] for x in names]
d = {'language': names, 'bytes': counts}
df = pd.DataFrame(d)
df = df.loc[df['language'] != 'HTML', :]
df = df.loc[df['language'] != 'Rebol', :]

total = df['bytes'].sum()

sns.set_style('whitegrid')
sns.set_palette('Paired')
ax = sns.factorplot(x='language', y='bytes', data=df, kind='bar')
ax = sns.barplot(x='language', y='bytes', data=df)
for p in ax.patches:
    height = p.get_height()
    ax.text(p.get_x() + 0.1, height + 3500, '%2.2f' % (100 * height / total))

ax.set(xlabel='', ylabel='bytes')
sns.plt.show()
# }}}
