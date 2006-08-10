#!/bin/bash
## ---------------------------------------------------------------------*-sh-*-

if [ -z "$1" ]; then
    echo "Please specify the branch number which will be tagged"
    exit 2
fi

if [ -z "$2" ]; then
    echo "Please specify a tag number to be created from this branch"
    exit 2
fi

URL=`svn info | grep 'URL:' | sed -e 's/^URL: //'`
BRANCH=$1
TAG=$2

echo "svn copy -m \"- tag $BRANCH -> $TAG\" $URL/branches/$BRANCH $URL/tags/$TAG"

## ----------------------------------------------------------------------------
