#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=utils.sh
. "$SCRIPT_DIR/utils.sh"
banner
[[ $# -gt 0 ]] || { echo "Usage: smart-terminal \"your query\""; exit 64; }
INPUT="$*"
CMD="$(bash "$SCRIPT_DIR/to_cmd.sh" "$INPUT")"
confirm "$CMD"
