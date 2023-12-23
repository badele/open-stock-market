#!/usr/bin/env bash

is_not_cached() {
  FILENAME=$1

    today=$(date +"%Y-%m-%d")
    if [ -e "$FILENAME" ]; then
        filedate=$(stat -c %y "$FILENAME" | cut -d' ' -f1)
        if [ "$filedate" == "$today" ]; then
            return 1 # Cached
        else
            return 0 # Not cached
        fi
    else
        return 0  # not exists
    fi
}
