# Project Page URL
https://roadmap.sh/projects/nginx-log-analyser

# Nginx Log Analyzer

A simple command-line shell script to analyze Nginx access logs.

## What it shows

- Top N IP addresses with the most requests
- Top N most requested paths
- Top N response status codes
- Top N user agents

## Project files

- `analyze.sh` - analyzer script
- `nginx-access.log` - sample log file

## Requirements

- Bash
- `awk`
- `sort`
- `uniq`
- `sed`

## Download sample log data

```bash
curl -L "https://gist.githubusercontent.com/kamranahmedse/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log" -o nginx-access.log
```

## Usage

```bash
./analyze.sh [log_file] [top_n]
```

- `log_file` (optional): path to access log file  
  Default: `nginx-access.log`
- `top_n` (optional): number of top results to show  
  Default: `5`

## Examples

Run with defaults:

```bash
./analyze.sh
```

Run with custom values:

```bash
./analyze.sh nginx-access.log 10
```

## Notes

- Status codes are parsed safely from the field after the quoted request.
- Only valid 3-digit HTTP status codes are counted.
- The script exits with an error if the file is missing or `top_n` is not a positive integer.
