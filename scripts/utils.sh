#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2155

BOLD='\033[1m'; RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'; NC='\033[0m'

banner(){
    echo -e "${BOLD}${GREEN}Thinking... ${NC}" >&2
}

log(){
    local query="$1"
    local cmd="$2"
    local ts 
    local logfile
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    local ROOT_DIR
    ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    logfile="$ROOT_DIR/logs/smart_terminal.log"
    
    mkdir -p "$(dirname "$logfile")"
    echo "[$ts] $query ::: $cmd" >> "$logfile"
}

confirm_run(){
    local query="$1"
    local cmd="$2"
    #echo "DEBUG‑CONFIRM: [$cmd]"
    cmd=$(printf '%s' "$cmd" | tr -d '\r\n') #remove hidden newline characters
    echo -e "${YELLOW} > $cmd ${NC}" >&2
    read -rp "Run this command? [y/n]" ans < /dev/tty
    [[ $ans =~ ^[Yy]$ ]] || { echo "exiting" >&2; exit 1; }
    echo "$cmd" #executing the command
    log "$query" "$cmd"
}

