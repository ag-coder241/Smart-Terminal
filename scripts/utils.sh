#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2155

BOLD='\033[1m'; RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'; NC='\033[0m'
banner(){
    echo -e "${BOLD}${GREEN}Smart Terminal ${NC}"
}

log(){
    local msg="$1"
    local ts logFile
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    local ROOT_DIR
    ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    logfile="$ROOT_DIR/logs/$(date '+%Y-%m-%d').log"
    
    mkdir -p "$(dirname "$logfile")"
    echo "[$ts] $msg" >> "$logfile"

}

confirm_run(){
    local cmd="$1"
    echo "DEBUG‑CONFIRM: [$cmd]"
    echo -e "${YELLOW}> $cmd${NC}"
    read -rp "Run this command? [y/n]" ans
    [[ $ans =~ ^[Yy]$ ]] || { echo "exiting"; exit 1; }
    eval "$cmd"
    log "$cmd"
}





