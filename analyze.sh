#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="${1:-nginx-access.log}"
TOP_N="${2:-5}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: file not found: $LOG_FILE" >&2
  exit 1
fi

if ! [[ "$TOP_N" =~ ^[0-9]+$ ]] || [[ "$TOP_N" -lt 1 ]]; then
  echo "Error: top N must be a positive integer (got: $TOP_N)" >&2
  exit 1
fi

echo "Top $TOP_N IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" \
  | sort \
  | uniq -c \
  | sort -nr \
  | sed -n "1,${TOP_N}p" \
  | awk '{print $2 " - " $1 " requests"}'

echo
echo "Top $TOP_N most requested paths:"
awk -F'"' '{split($2, req, " "); if (req[2] != "") print req[2]}' "$LOG_FILE" \
  | sort \
  | uniq -c \
  | sort -nr \
  | sed -n "1,${TOP_N}p" \
  | awk '{print $2 " - " $1 " requests"}'

echo
echo "Top $TOP_N response status codes:"
awk -F'"' '{split($3, post, " "); if (post[1] ~ /^[0-9]{3}$/) print post[1]}' "$LOG_FILE" \
  | sort \
  | uniq -c \
  | sort -nr \
  | sed -n "1,${TOP_N}p" \
  | awk '{print $2 " - " $1 " requests"}'

echo
echo "Top $TOP_N user agents:"
awk -F'"' '{if ($6 != "") print $6}' "$LOG_FILE" \
  | sort \
  | uniq -c \
  | sort -nr \
  | sed -n "1,${TOP_N}p" \
  | awk '{count=$1; $1=""; sub(/^ +/, ""); print $0 " - " count " requests"}'
