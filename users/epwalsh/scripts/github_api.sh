#!/bin/bash
# =============================================================================
# File Name:     github_api.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 21-04-2016
# Last Modified: Thu Apr 21 11:29:06 2016
# =============================================================================

langs='repos/epwalsh/dmc2016/languages'
commits='repos/epwalsh/dmc2016/stats/participation'
commits_all='repos/epwalsh/dmc2016/stats/commit_activity'

curl -u epwalsh:Se@xin10 https://api.github.com/$commits_all
