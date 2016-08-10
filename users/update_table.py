#!/usr/bin/env python
# =============================================================================
# File Name:     update_table.py
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 28-03-2016
# Last Modified: Tue Apr  5 10:52:11 2016
# Purpose:       Update the 'Meet the team' table in README.md when new
#                collaborators are added to the repo.
# =============================================================================

import json

with open("users.txt", "r") as f:
    raw_text = f.read()
users = json.loads(raw_text)

with open("collaborators.txt", "r") as f:
    raw_text2 = f.read()
collabs = json.loads(raw_text2)

with open("README.md", "r") as f:
    readme = f.readlines()

user_list = [u['login'] for u in users]
collab_list = [u['login'] for u in collabs]


def update_table(user):
    out = '| <img src="' + user['avatar_url'] + \
            '" width=90 height=70> | [' + \
            user['login'] + '](' + user['html_url'] + ') | | |'
    return out

for user in collabs:
    add = True
    for l in readme:
        if user['login'] in l:
            add = False
    if add:
        print "Creating row for", user['login']
        with open('README.md', 'a') as f:
            f.write(update_table(user) + '\n')
