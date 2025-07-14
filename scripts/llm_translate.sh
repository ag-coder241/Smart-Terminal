#!/usr/bin/env bash
set -euo pipefail

query="$*"
[[ -z "$query" ]] && { echo "Please provide a query."; exit 1; }

response=$(curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mistralai/mistral-7b-instruct",
    "temperature": 0.0,
    "messages": [
      {"role": "system", "content": "You are a Linux shell expert. Convert English queries into single-line shell command. No explanations, no formatting, no quotes, no markdown. Only the command"},
      {"role": "user", "content": "'"$query"'"}
    ]
  }')

raw=$(echo "$response" | jq -e -r '.choices[0].message.content' 2>/dev/null || true)
cleaned=$(echo "$raw" |
  sed -E '
    s/^```(bash)?//;
    s/```$//;
    s/^["'"'"'`]+//;
    s/["'"'"'`]+$//;
    s/^[[:space:]]+//;
    s/[[:space:]]+$//')

command=$(echo "$cleaned" | awk '
  {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^[[:alnum:]\/\.\-\*\[\]\|\>\<\=]+$/) {
        print substr($0, index($0, $i))
        exit
      }
    }
  }')

if [[ -z "$command" || "$command" == "null" ]]; then
  echo "OpenRouter did not return a command:"
  echo "$response" | jq
  exit 1
fi

command=$(echo "$command" |
  sed -E '
    s/^```(bash)?[[:space:]]*//;   
    s/[[:space:]]*```$//;          
    s/^["'"'"'`]+//;               
    s/["'"'"'`]+$//;               
    s/^[[:space:]]+//;            
    s/[[:space:]]+$//             
  ')

echo "$command"




