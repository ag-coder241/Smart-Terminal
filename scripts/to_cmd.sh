#!/usr/bin/env bash
set -euo pipefail

input="${1:-}"
shopt -s nocasematch

case "$input" in 
    *"current directory"*) echo "pwd";;
    *"list files"*) echo "ls - lah";;
    *"disk usage"*) echo "du -sh .";;
    *"find large files"*) echo "find . -type f -size +100M";;
    *) echo "not understanding";;
esac


