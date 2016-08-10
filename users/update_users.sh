#!/bin/bash
# =============================================================================
# File Name:     update_users.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 25-03-2016
# Last Modified: Mon Mar 28 10:28:53 2016
# Purpose:       Use the GitHub API to get a list of all members in the ISU-DMC 
#                organization. When we update the list, if new members have 
#                been added, a new folder is created for that user with a 
#                README.md and .gitignore file.
# =============================================================================

curl -u "epwalsh" https://api.github.com/orgs/ISU-DMC/members > users.txt
USERS=$(perl -nle 'print $& if m{"login": "\K[A-Za-z0-9-_]*(?=",)}' users.txt)

n=0
i=0
for u in $USERS
do
    let "n+=1"
    if ! [ -d $u ] 
    then
        let "i+=1"
        echo 'Creating directory for' $u
        mkdir $u
        touch $u/README.md
        touch $u/.gitignore
        echo '## Personal space for' $u >> $u/README.md
        echo $'\nAdd the names of any files you don\'t want to commit to the ```.gitignore``` file in this directory.' >> $u/README.md
   fi
done

echo "$i new users added"
echo "$n users total"

exit 0
