#!/bin/bash
# =============================================================================
# File Name:     update_collaborators.sh
# Author:        Evan Pete Walsh
# Contact:       epwalsh10@gmail.com
# Creation Date: 27-03-2016
# Last Modified: Wed Apr  6 12:01:14 2016
# Purpose:       Update the list of collaborators to this private repo. We use 
#                the ISU-DMC members list as the master list of allowed 
#                collaborators.
# =============================================================================

curl -u "epwalsh" https://api.github.com/repos/epwalsh/dmc2016/collaborators > collaborators.txt

COLLABS=$(perl -nle 'print $& if m{"login": "\K[A-Za-z0-9-_]*(?=",)}' collaborators.txt)
USERS=$(perl -nle 'print $& if m{"login": "\K[A-Za-z0-9-_]*(?=",)}' users.txt)

BASE_URL="https://api.github.com/repos/epwalsh/dmc2016/collaborators/"

new_added=false
for user in $USERS
do
    # Check if user is already a collaborator. If not, we add them to the list
    # through the GitHub API.
    if ! [[ $COLLABS =~ $user ]]
    then
        echo "Adding" $user "as collaborator..."
        curl -u "epwalsh" -X PUT -d '' "$BASE_URL$user"
        new_added=true
    fi
done

if [ "$new_added" = true ]
then
    curl -u "epwalsh" https://api.github.com/repos/epwalsh/dmc2016/collaborators > collaborators.txt
fi

exit 0
