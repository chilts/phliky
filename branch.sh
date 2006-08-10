#!/bin/bash
## ---------------------------------------------------------------------*-sh-*-

if [ -z "$1" ]; then
    echo "Please specify a branch number to be created from the trunk"
    exit 2
fi

URL=`svn info | grep 'URL:' | sed -e 's/^URL: //'`
BRANCH=$1

echo "svn copy -m \"- branch trunk -> $BRANCH\" $URL/trunk $URL/branches/$BRANCH"

## ----------------------------------------------------------------------------
