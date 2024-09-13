
---

# SD Card Backup and Upload to Nextcloud

This repository contains a Bash script that creates a compressed image of your SD card, excluding unused space, and uploads it to Nextcloud using `rclone`.

## Description

The script performs the following tasks:

1. **Calculates the effective filesystem size**: Uses `dumpe2fs` to get the number of used blocks and block size of the specified partition.
2. **Creates an image of the SD card**: Uses `dd` to create an image of the SD card, compresses it with `gzip`, and saves it in a local backup directory.
3. **Uploads the image to Nextcloud**: Uses `rclone` to upload the compressed image to Nextcloud.
4. **Removes the local backup file**: Deletes the local backup file after uploading to free up space.

## Requirements

- **Operating System**: Debian or a compatible Linux distribution
- **Tools**:
  - `dd` (to create the SD card image)
  - `gzip` (to compress the image)
  - `dumpe2fs` (to get filesystem information)
  - `rclone` (to upload the image to Nextcloud)
- **Permissions**: The script requires `sudo` permissions for `dumpe2fs` and `dd`.

## Setup

1. **Install `rclone`**:
   Follow the [rclone installation guide](https://rclone.org/install/) for your operating system.

2. **Configure `rclone`**:
   Run `rclone config` to set up a remote for Nextcloud. The remote name should be specified in the script configuration (e.g., `remote:/backup`).

3. **Edit the Script**:
   Update the following variables in the script as needed:
   - `SD_CARD`: The device name of your SD card (e.g., `/dev/sdX`)
   - `PARTITION`: The main partition name (e.g., `/dev/sdX1`)
   - `BACKUP_DIR`: The local directory where the image will be saved (e.g., `/path/to/backup`)
   - `IMAGE_NAME`: The name of the backup image
   - `RCLONE_REMOTE`: The name of the rclone remote configured for Nextcloud

4. **Grant Execute Permissions to the Script**:
   ```bash
   chmod +x backup_sd_card.sh
   ```

## Running the Script

Execute the script with superuser permissions:
```bash
sudo ./backup_sd_card.sh
```

## Notes

- Ensure that the SD card is not mounted during the script execution to avoid conflicts.
- Check the logs for any errors and verify that the backup completed successfully.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

