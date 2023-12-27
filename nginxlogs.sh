#!/bin/bash
echo "============================================"
# Specify the path to your Nginx access log file
nginx_access_log="/opt/homebrew/var/log/nginx/access.log"

# Check if the log file exists
if [ ! -f "$nginx_access_log" ]; then
    echo "Error: Nginx access log file not found."
    exit 1
fi

# frequent IP addresses
echo "Most frequent IP addresses:"
awk '{print $1}' "$nginx_access_log" | sort | head -n 5

# frequent request URLs
echo -e "\nMost frequent request URLs:"
awk '{print $7}' "$nginx_access_log" | sort | uniq -c | head -n 5

# count error codes
echo -e "\nError codes and their occurrences:"
awk '$9 >= 400 {print $9}' "$nginx_access_log" | sort | uniq -c
echo "============================================"
