#!/bin/bash

# Function to print a separator line
print_separator() {
    echo "============================================"
}

# 1. List all users and their last login time
print_separator
echo "User Accounts and Last Login Times:"
dscl . -list /Users UniqueID | while read user uid; do
    last_login=$(last -1 -t console | grep "$user" | awk '{print $3" "$4" "$5}')
    echo "User: $user, Last Login: ${last_login:-Never logged in}"
done

# 2. Check for world-writable files in sensitive directories
print_separator
echo "World-Writable Files in Sensitive Directories:"
find /etc /var -type f -perm -002 -exec ls -ld {} \;

# Note: The above line finds files in /etc and /var with world-writable permissions and prints their details.

print_separator

