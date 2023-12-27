#!/bin/bash

# Database credentials
DB_USER="redmine"
DB_PASSWORD="password"
DB_NAME="redmine"

# Backup directory
BACKUP_DIR="/Users/ankitsmac/redmine"

# Backup file name
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +'%Y%m%d_%H%M%S').sql"

# Function to perform database backup
perform_backup() {
    mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" > "${BACKUP_FILE}"
}

# Function to verify the backup file
verify_backup() {
    if [ -s "${BACKUP_FILE}" ]; then
        echo "============================================"
        echo "Backup verification successful. Backup file size is $(du -h "${BACKUP_FILE}" | cut -f1)"
    else
        echo "Backup verification failed. The backup file is empty or does not exist."
        exit 1
    fi
}

# Perform database backup
echo "Performing database backup..."
perform_backup

# Verify the backup file
echo "Verifying backup..."
verify_backup

# Report backup status
echo "Backup operation completed successfully."
echo "============================================"

