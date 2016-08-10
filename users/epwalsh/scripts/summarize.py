#!/usr/bin/env python
# =============================================================================
# File Name:     summarize.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 25-05-2016
# Last Modified: Thu May 26 12:45:40 2016
# =============================================================================

import re
import matplotlib.pyplot as plt
from PIL import Image
from wordcloud import WordCloud

with open('./PYFILES', 'r') as f:
    pyfiles = f.readlines()

with open('./RFILES', 'r') as f:
    rfiles = f.readlines()


RLIB = re.compile(r"^library\(\"?\'?([a-zA-Z0-9]*)\"?\'?\)")
#  s = "library('dplyr')"
#  RLIB.sub("\g<1>", s)

PYLIB = re.compile(r"^(from|import)\s([a-zA-Z0-9]*).*")
#  s2 = "from sys import stdout"
#  s3 = "import xgboost as xgb"
#  s4 = "import csv"
#  PYLIB.sub("\g<2>", s2)
#  PYLIB.sub("\g<2>", s3)
#  PYLIB.sub("\g<2>", s4)
#  PYLIB.search(s4).group(2)
#  PYLIB.search('not a package')
#  PYLIB.sub("\g<2>", 'not a package')


def check_for_package(line, packages, ft='py'):
    if ft == 'py':
        res = PYLIB.search(line)
        if res:
            packages.append(res.group(2))
    if ft == 'r':
        res = RLIB.search(line)
        if res:
            packages.append(res.group(1))


def get_packages(files, ft='py'):
    packages = []
    for item in files:
        with open(item[:-1], 'r') as f:
            lines = f.readlines()
        for line in lines:
            check_for_package(line, packages, ft)
    return packages

rpack = get_packages(rfiles, ft='r'q
pypack = get_packages(pyfiles, ft='py')

text = rpack + pypack
text = ' '.join(text)
text

wordcloud = WordCloud(background_color='white', 
                      max_font_size=200, 
                      relative_scaling=.5,
                      width=1000,
                      height=700).generate(text)
plt.figure()
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
