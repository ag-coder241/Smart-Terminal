#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=utils.sh
. "$SCRIPT_DIR/utils.sh"

[[ $# -gt 0 ]] || { echo "Usage: smart-terminal \"your query\"" >&2 ; exit 64; }

INPUT="$*"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_FILE="$ROOT_DIR/logs/smart_terminal.log"
SUGGESTED_CMD=""

if [[ -f "$LOG_FILE" ]] && \
   SUGGESTED_CMD=$( (cat "$LOG_FILE" | fzf --tac --no-sort --query="$INPUT" --preview="echo {} | cut -d':' -f4-" --preview-window=up:3:wrap) | awk -F ' ::: ' '{print $2}' ) && \
   [[ -n "$SUGGESTED_CMD" ]]; then
    
    echo -e "${GREEN}Suggested from history:${NC}" >&2
    confirm_run "$INPUT" "$SUGGESTED_CMD"
else
    banner
    CMD="$(bash "$SCRIPT_DIR/llm_translate.sh" "$INPUT")"
    confirm_run "$INPUT" "$CMD"
fi
