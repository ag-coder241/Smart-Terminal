#!/usr/bin/env bash
set -euo pipefail

# echo "Script is starting..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=utils.sh
 . "$SCRIPT_DIR/utils.sh"

api_key="${GEMINI_API_KEY:-}"
API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"
query="$*"
[[ -z "$query" ]] && { echo "Please provide a query."; exit 1; }

INSTRUCTION="You are a Linux command expert. Your job is to convert plain English queries into 
            valid macos shell commands. Only return the command. always a return a single command. Never provide explanations, comments, or formatting."

 JSON_DATA=$(cat <<EOF
  {
    "system_instruction": {
      "parts": [
        { "text": "${INSTRUCTION}" }
      ]
    },
    "contents": [
      {
        "parts": [
          { "text": "${query}" }
        ]
      }
    ],
    "generationConfig": {
    "temperature": 0.1
  }
  }
EOF
)


response=$(curl -s -X POST "${API_ENDPOINT}?key=${GEMINI_API_KEY}" \
     -H "Content-Type: application/json" \
     -d "${JSON_DATA}")

# echo "[DEBUG] Response from Gemini API:"
# echo "$response"

error_message=$(echo "${response}" | jq -r '.error.message')
if [ "${error_message}" != "null" ]; then
  echo "An error occurred:"
  echo "${error_message}"
  exit 1
fi


command=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text' | sed -E 's/^```bash//;s/^```//;s/```$//;s/^[[:space:]]+//;s/[[:space:]]+$//')

if [[ -z "$command" || "$command" == "null" ]]; then
  echo "Failed to parse Gemini response:"
  echo "$response" | jq
  exit 1
fi

echo "$command"


# raw=$(echo "$response" | jq -e -r '.choices[0].message.content' 2>/dev/null || true)

# command=$(echo "$raw" |
#   sed -E '
#     s/^```(bash)?//;
#     s/```$//;
#     s/^["'"'"'`]+//;
#     s/["'"'"'`]+$//;
#     s/^[[:space:]]+//;
#     s/[[:space:]]+$//')

# command=$(echo "$cleaned" | awk '
#   {
#     for (i = 1; i <= NF; i++) {
#       if ($i ~ /^[[:alnum:]\/\.\-\*\[\]\|\>\<\=]+$/) {
#         print substr($0, index($0, $i))
#         exit
#       }
#     }
#   }')



# if [[ -z "$command" || "$command" == "null" ]]; then
#   echo "${RED} NO ANSWER ${NC}"
#   echo "$response" | jq
#   exit 1
# fi

# command=$(echo "$command" |
#   sed -E '
#     s/^```(bash)?[[:space:]]*//;   
#     s/[[:space:]]*```$//;          
#     s/^["'"'"'`]+//;               
#     s/["'"'"'`]+$//;               
#     s/^[[:space:]]+//;            
#     s/[[:space:]]+$//             
#   ')

# echo "$command"




