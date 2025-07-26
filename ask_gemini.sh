#!/bin/bash

# Check if a prompt is provided
if [ -z "$1" ]; then
  echo "Usage: $0 \"Your prompt to Gemini\""
  exit 1
fi

# The official Gemini API endpoint
API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"

# The user's prompt
PROMPT="$1"

# Prepare the JSON data for the API request
JSON_DATA=$(cat <<EOF
{

  "contents": [
    {
      "parts": [
        {
          "text": "${PROMPT}"
        }
      ]
    }
  ]
}
EOF
)

# Make the API call using curl
response=$(curl -s -X POST "${API_ENDPOINT}?key=${GEMINI_API_KEY}" \
     -H "Content-Type: application/json" \
     -d "${JSON_DATA}")

# echo "--- RAW API RESPONSE ---"
# echo "${response}"
# echo "------------------------"

# Extract and print the generated text
# This uses jq to parse the JSON response. Make sure you have jq installed.
generated_text=$(echo "${response}" | jq -r '.candidates[0].content.parts[0].text')

echo "Gemini says:"
echo "${generated_text}"
