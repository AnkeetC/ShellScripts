#!/bin/bash

# Output file with timestamp
output_file="system_report_$(date +"%Y%m%d_%H%M%S").txt"

# System information
echo "=== System Information ===" >> "$output_file"
system_profiler SPSoftwareDataType >> "$output_file"

# CPU usage
echo -e "\n=== CPU Usage ===" >> "$output_file"
top -l 1 -n 0 -F -R >> "$output_file"

# Memory usage
echo -e "\n=== Memory Usage ===" >> "$output_file"
ps aux | head -n 10 >> "$output_file"

# Disk space
echo -e "\n=== Disk Space ===" >> "$output_file"
df -h >> "$output_file"

# Running processes
echo -e "\n=== Running Processes ===" >> "$output_file"
ps aux >> "$output_file"

echo "System report generated and saved to: $output_file"

