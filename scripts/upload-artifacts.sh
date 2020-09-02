#!/bin/sh

DIR=$1
shift

if test -n "$SHAREDARTIFACTSDIR"; then
    DIR="$SHAREDARTIFACTSDIR/$DIR"
    mkdir -p $DIR
    cp "$@" $DIR
else
    for i in "$@"; do
        rclone copy --no-traverse "$i" artifacts:$DIR/
    done
fi