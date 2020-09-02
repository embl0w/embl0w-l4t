#!/bin/sh

if test -n "$SHAREDARTIFACTSDIR"; then
    mkdir -p $2
    ln -snf $SHAREDARTIFACTSDIR/$1 $2
else
    rclone copy artifacts:$1/ $2/$1/
fi