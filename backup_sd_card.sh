#!/bin/bash

# Variables
SD_CARD="/dev/sdX" # Replace with the device name of your SD card
PARTITION="/dev/sdX1" # Replace with the main partition (check with 'lsblk')
BACKUP_DIR="/path/to/backup" # Replace with the local backup directory
IMAGE_NAME="backup_$(date +'%Y-%m-%d').img.gz"
RCLONE_REMOTE="remote:/backup" # Remote configured in rclone for Nextcloud

# Create the local backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Calculate the effective filesystem size (used blocks)
USED_BLOCKS=$(sudo dumpe2fs "$PARTITION" | grep "Block count:" | awk '{print $3}')
BLOCK_SIZE=$(sudo dumpe2fs "$PARTITION" | grep "Block size:" | awk '{print $3}')

# Calculate the used space in bytes
USED_SIZE=$((USED_BLOCKS * BLOCK_SIZE))

# Create an image of the SD card without the unused space
echo "Starting backup of the SD card without unused space..."
sudo dd if="$SD_CARD" bs=4M count=$((USED_SIZE / 4 / 1024 / 1024)) | gzip > "$BACKUP_DIR/$IMAGE_NAME"

# Verify that the image was created
if [ -f "$BACKUP_DIR/$IMAGE_NAME" ]; then
    echo "Image created successfully: $BACKUP_DIR/$IMAGE_NAME"
else
    echo "Error creating the image."
    exit 1
fi

# Upload the image to Nextcloud using rclone
echo "Uploading the image to Nextcloud..."
rclone copy "$BACKUP_DIR/$IMAGE_NAME" "$RCLONE_REMOTE"

# Verify that the upload was successful
if [ $? -eq 0 ]; then
    echo "Upload completed successfully to Nextcloud."
else
    echo "Error uploading to Nextcloud."
    exit 1
fi

# Remove the local file to free up space
rm "$BACKUP_DIR/$IMAGE_NAME"
echo "Local backup file deleted."

echo "SD card backup completed."
