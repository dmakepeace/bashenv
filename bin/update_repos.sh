#!/bin/bash
#
# Updates all repos contained in $REPO_DIR
# Changes to repo dir, checks out master and performs 'git pull'
#

REPO_DIR=$HOME/repos

for dir in `ls -d $REPO_DIR/*`
do
    echo "REPO: $dir"
    if ! cd $dir
    then echo "Failed to change to $dir"
    fi

    if ! git checkout master > /dev/null 2>&1
    then echo "Failed to checkout master branch in $dir"
    fi

    if ! git pull
    then echo "Failed to pull down latest master branch in $dir"
    fi

done
