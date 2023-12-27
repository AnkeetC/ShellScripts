#!/bin/bash

# Function to send an email alert
send_email() {
    # Replace with your email and app password
    sender_email="chauhan.ankit505@gmail.com"
    app_password="mzle nxyq gmhv gzok"
    receiver_email="chauhan.ankit505@gmail.com"

    subject="Network Alert"
    body="Failed to ping $1 at $(date +'%Y-%m-%d %H:%M:%S')"

    echo -e "Subject:$subject\n$body" | \
    (
        /usr/sbin/sendmail -f "$sender_email" -t "$receiver_email"
    )
}

# Function to check the network health
check_network_health() {
    for target in "$@"; do
        timestamp=$(date +'%Y-%m-%d %H:%M:%S')
        if ping -c 1 "$target" > /dev/null 2>&1; then
            echo "[$timestamp] Ping to $target successful."
        else
            echo "[$timestamp] Ping to $target failed. Sending alert."
            send_email "$target"
        fi
    done
}

targets=("google.com" "example.com" "192.168.1.1")

# Run check in loop
while true; do
    check_network_health "${targets[@]}"

    # Check the network health
    sleep 200
done

